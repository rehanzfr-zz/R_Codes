# Youtube Tutorial

This code is explained in my vide at youtube. Please like and subscribe so that I can make more for you. 

https://youtu.be/bVI9W7mplec


# Complex Heatmap

In this code, we will make complex heatmap. It will contain heatmap, frequency plot, dendograms and colored representation of different variables. We will start with the introduction to the data. After that we will see the related code for making the heatmap by using complex heatmap package. So grab a cup of coffee and enjoy. 

Suppose you have a table. Not this one, this one. Here you can see different columns and rows with values R,S and I in the cells. Above that you have a major columns which represent that each two columns are under this one. Similarly each two rows are under one major row. Then by using this data we want to generate the heatmap. Over and above, we also want to show the major columns and rows in the information along with it. So in this video we will see this happening. So let's move forward. 

So take a look at this data which we will use to generate all those plots. Here in first column we added IDs of the rows or samples. 2nd column represents the location of the data from where these have been taken.  As you can see in these columns there are two rows for the representation of values. In first row of the column, we have defined the class and in 2nd row we have mentioned the subclass. The classes are repeated in some cases to define the subclasses. These are the values, R , S and I.  Let’s save this as csv file for later use in R.

Let’s open Rstudio and make a new script file. Here you can paste the code which I have written and compiled as HTML file. Let me open it as well. For the time being, I am not interested in writing the code again so I will move forward by using this html file to introduce the steps. 

### Install Packages

First we will install some packages. If you have already installed them then we can skip this step. I have commented these with `#` in the start. You can remove hash and run these. 

```{r}
#install.packages("dplyr")
#install.packages("tidyr")
#install.packages("plyr")
#install.packages("reshape2")
#install.packages("ComplexHeatmap")
#install.packages("ggpubr")
#install.packages("circlize")
#install.packages("RColorBrewer")
#install.packages("scales")
#install.packages("stringdist")
#install.packages("corrplot")
#install.packages("heatmaply")
```

After installation, we can call these libraries. 

```{r}
library(dplyr)
library(tidyr)
library(plyr)
library(reshape2)
library(ComplexHeatmap)
library(ggpubr)
library(circlize)
library(RColorBrewer)
library(scales)
library(stringdist)
library(corrplot)
library(heatmaply)
```

### Setting Working folder

Now we will set the working folder for us. *Note:* We need to change the back slahes to forward slashes in the path of the folder (if copied from windows address bar).

```{r}
###### Folder Settings
folder<- "C:/Users/rehan/OneDrive/Desktop/Heatmap/Heatmap"
setwd(folder)
getwd()
```


### Calling CSV file of interest and data formating

We have a file named `ASTAPEC.csv` in our working folder as set above. We want to read the data into an object `mydf_orig`. We will do this by using the function of `read.csv`. Moreover, we are not interested in the getting the data with headers. 

```{r}
###### Reading Data
mydf_orig <- read.csv("ASTAPEC.csv", header = FALSE)
```

If we see the data then there are `R, S and I` in the cells with some row headers and column headers. The first row (starting from column 3) in the data represents the classes of the columns. The second row (starting from column 3) represents the subclasses. The first column with header `Isolates` represents the IDs of the samples and second column with header `Locations` represents the area of sampling. 

```{r}
head(mydf_orig)
```
#### Removing white spaces around the data

Now we will remove the white spaces around the text of data. Here, `%>%` is a specific operator available in tidyr, dplyr, tidyverse etc. In the following code: 

1. **trimws**: removes leading and/or trailing whitespace from character strings.
2. **mutate_all**: make it easy to apply the same transformation to multiple variables of the data (`mydf_orig`).


```{r}
mydf <- mydf_orig  %>%  mutate_all(trimws)
```

#### Making rownames and column names of the data

Now we will extract the row names (`rownames`) and column names (`colnames`) from the data.

1. Rownames from the 1st column (`mydf[,1]`). 
2. Column names from the 2nd row (`mydf[2,]`). 

```{r}
mydf[,1]
```

```{r}
mydf[2,]
```


```{r}
rownames(mydf)<-mydf[,1]
colnames(mydf)<-mydf[2,]
```

#### Remove 1st and 2nd row from data

Now we will remove 1st and 2nd row from the data. Here, `-` sign represents not and `c` represents the list of 1st and 2nd row before comma `,`.

```{r}
mydf<-mydf[-c(1,2),]
```

#### Order data according to 2nd column

Now we will order the data according to 2nd column. Later remove the 1st and 2nd column. 

```{r}
mydf2 <- mydf[order(mydf[,2]),]
mydf<-mydf2[,-c(1,2)]
```

#### Generating matrix from the data.

If we look at the class of `mydf` then will see it as data.frame. We want to convert it to matrix by using the function of `as.matrix`. You can save it as csv as well, if you want by using `write.csv` (delete # and uncomment). 

```{r}
class(mydf)
```

```{r}
mat<- as.matrix(mydf)
head(mat)
#write.csv(mat, file="matrix.csv")
```

### Starting the data manipulation for complex heatmap

In complex heatmap, we want to generate a heatmap of values `R, I and S`. Along with it, we want to identify rows as IDs  and columns as subclasses. Moreover, the Locations would be used as colored annotation along the rows and Classes as colored annotations for the columns. A dendogram will also be generated both for rows and columns for classification. At the top of the heatmap, we want to generate and graph for the frequencies of the values `R,S and I` for each column. Therefore, following things will be generated:

1. Annotation for Classes.
2. Annotation for Locations.
3. Generation of colors for conditions.
4. Generation of dendogram for character data.
3. Calculation of frequencies of R, I and S.
4. Generation of Heatmap.

#### Annotation for Classes.


We want to take specific rows and columns from our original data (`mydf_orig`) which is first row excluding the first 2 columns.  

```{r}
Antibiotics <- t(mydf_orig[1,-c(1,2)])
Antibiotics
```

As you can see there some values are repeated. So we want to take only unique names among it. Here, `t` represents transverse. If these are in row then these will become column and vice versa. 

```{r}
Antibiotics_unique <- t(unique(Antibiotics))
Antibiotics_unique
```

We want to count these unique names and save it for later use. These are 11. 

```{r}
colourCount_Antibiotics = length(Antibiotics_unique)
colourCount_Antibiotics
```
So we want 11 different colors from `rcolorbrewer`. However, it only gives 9 different colors. Therefore, we need a function which can generate as many colors out of these 9 colors after scaling. 

We will make a function of `getPallete` by using `colorRampPalette` and `brewer.pal`. `colorRampPalette` returns a palette generating function and takes an integer argument and generates a palette with that many colors. `brewer.pal` makes the color palettes from ColorBrewer available as R palettes. Differet sets are available however, we are selecting `Set1` for now. 


```{r}
getPalette = colorRampPalette(brewer.pal(9, "Set1"))
```

Now we can generate many colors  by this function. Though we want only those number of colors ass stored in `colourCount_Antibiotics`. These are hex codes for the colors.

```{r}
Antibiotics_colors<- getPalette(colourCount_Antibiotics)
Antibiotics_colors
```
If really you want to see them in colors.

```{r}
show_col(Antibiotics_colors)
```
Now we will generate a named list (a special data class) which will merge classes and colors in a list. 

```{r}
list_antibiotics_colors <- setNames(Antibiotics_colors, Antibiotics_unique)
list_antibiotics_colors
```

Now we are ready to generate the first annotatio of classes for our heatmap. We need to give the `Antibiotics`. We need to identify these antibiotics versus their list of colors.

```{r}
h_antib = HeatmapAnnotation(Antibiotics = Antibiotics,
                       col = list(Antibiotics= list_antibiotics_colors),
                       gp = gpar(col = "black"),
                       border = TRUE)
```



```{r}
plot(h_antib)
```

#### Annotation for Locations.

We will perform the same steps as given above to produce the annotation for locations. Therefore, refer to above discussion for some of the explanation.

We want to take 2nd column from our original data (`mydf_orig`).

```{r}
Cities <- (mydf2[,2])
Cities
```

Remove the repeated values. 

```{r}
Cities_unique <- t(unique(Cities))
Cities_unique
```
Get the length of these.

```{r}
colourCount_Cities = length(Cities_unique)
colourCount_Cities
```

Get Colors for these cities from `Set3`.  

```{r}
getPalette2 = colorRampPalette(brewer.pal(9, "Set3"))
colors_Cities<- getPalette2(colourCount_Cities)
colors_Cities
```

```{r}
show_col(colors_Cities)
```
Make a named list of colors against cities and generate the row annotation of heatmap this time. 

```{r}
col2_cities <- setNames(colors_Cities, Cities_unique)

h_cities= rowAnnotation(Cities = Cities,
                   col = list(Cities= col2_cities),
                   gp = gpar(col = "black", fontsize = 3),
                   border = TRUE)
```

```{r}
plot(h_cities)
```

#### Generation of colors for conditions.  

We will generate three different colors according to our choice for these three conditions of `R,I and S`. We will use `#36D3C4","#D33636", "#3CD336` for `I, R and S`, respectively in an object `condition_colors` and make a named list from this in an object `condition_colors_list`.  Instead of `setnames` function here we are using `structure` function. This will also produce the same named list of colors against conditions. I have also used here the `setNames` funciton for comparison only. 


```{r}
condition_colors <- c("#36D3C4","#D33636", "#3CD336")

condition_colors_list = structure(condition_colors, names = c("I","R","S"))
condition_colors_list
show_col(condition_colors_list)

haha <- setNames(condition_colors, c("I","R","S"))
haha
show_col(haha)
```

#### Generation of dendogram for character data.

We want to add dendogram both for column and rows in this heatmap. On this text/character data in our case we will use `stringdist` package. We will write a function which can make a dendogram after approximate String Matching. This package performs approximate String Matching, Fuzzy Text Search, and String Distance Functions.

```{r}
# For calculating distances using stringdist package
dist_letters = function(x, y) {
  x = strtoi(charToRaw(paste(x, collapse = "")), base = 16)
  y = strtoi(charToRaw(paste(y, collapse = "")), base = 16)
  sqrt(sum((x - y)^2))
}
```

Suppose we have two objects `fA` and `fB` as below composed of same characters. Then the distance between them will be `0`. 

```{r}
fA =c("A","A","B")
fB=c("A","A","B")
dist_letters(fA,fB)
```
and the distance between these objects will be high with different characters.

```{r}
fA=c("A","A","A")
fB =c("Z","Z","Z")
dist_letters(fA,fB)
```

we an see the distancec between two columsn and two rows in our matrix `mat` as below:

```{r}
#between 1st and 2nd row
dist_letters(mat[1,],mat[2,])
```
```{r}
#between 1st and 2nd column
dist_letters(mat[,1],mat[,2])
```

#### Calculation of frequencies of R, I and S.

We want to calculate the frequencies of R, I and S in our data column wise with respect to antibiotics. 
For this we can use `table function` as given below on 1st column of the data `mydf`.

```{r}
table(mydf[,1],useNA = "ifany")
```

`lapply` can also be used to calculate `table` on complete `mydf`.

```{r}
lapply(mydf, table)
```

However, we will do this in this way. We will sort out the unique factors which are "I","R" and "S" in our case.

```{r}
factors <- sort(unique(unlist(mydf)))
factors
```

After this, we will make a dataframe by calling `do.call`. This constructs and executes a function provided with a list of arguments. We are binding rows by `rbind` which will be obtained after performing the `lapply` on `table` function for these factors. 

```{r}
total_IRS<- as.data.frame(do.call(rbind, lapply(mydf, function(x) table(factor(x, levels=factors)))))
total_IRS
```

We will add the header of "Antibiotic" in first column. 

```{r}
total <- tibble::rownames_to_column(total, "Antibiotic")
total
```


We will transverse the `total`. 

```{r}
total_t<- t(total)
total_t
```

We will take first row as column name and later delete this row.

```{r}
colnames(total_t)<-total_t[1,]
total_t <- total_t[-1,]
total_t
```

later we will change the class of this object to numeric. 

```{r}
class(total_t) <- "numeric"
```

#### Annotation of Frequency Plot for Heatmap

Now we can generate the annotation of frequencies plot coloumn wise. We will take same colors as given in object `condition_colors` for filling and coloring the barplots. 

```{r}
h_frequencies = HeatmapAnnotation(Frequencies=anno_barplot(t(total_t),
                                                 gp=gpar(fill = condition_colors, 
                                                         col = condition_colors)))
plot(h_frequencies)
```
#### Generation of Heatmap
Now we can generate the heatmap. We can directly save it in png file to our disk. However, I have commented first and last line and you can uncomment these if you want. Most of the arguments are self explanatory. I will introduce our varibale generated in this exercise only.

1. `mat` is our matrix of values.
2. `col = condition_colors_list` is the named list of our conditions versus colors.
3. `bottom_annotation = h_antib` is the annotation of antibotics at bottom. 
4. `top_annotation = h_frequencies` is the annotation for frequencies.
5. `right_annotation =h_cities` is the annotation for locations/cities. 
6. `clustering_distance_columns = dist_letters` is the ditance calculation between columns. 

I have commented the `clustering_distance_rows = dist_letters`. You can generate the dendogram between rows as well.However, if you will generate then it will effect the order of rows which are currently sorted ascending for the locations/cities.


```{r}
#png("test.png",width=10,height=10,units="in", res=1200)

Heatmap(mat, name = "Condition",
        border_gp = gpar(col = "black", lty = 2),
        clustering_method_rows = "single",
        column_title = "Heatmap",
        column_title_gp = gpar(fontsize = 20, fontface = "bold"),
        col = condition_colors_list,
        row_title = "Strains",
        bottom_annotation = h_antib ,
        top_annotation = h_frequencies,
        right_annotation =h_cities,
        column_km = 3,
        row_names_side = "left",
        row_names_gp = gpar(fontsize = 5),
        show_row_names = FALSE,
        column_names_rot = 45,
        column_names_gp = gpar(fontsize = 10),
        heatmap_height = unit(1.5, "mm")*nrow(mat),
#clustering_distance_rows = dist_letters,
clustering_distance_columns = dist_letters,
row_dend_reorder = FALSE,
column_dend_reorder = FALSE,
heatmap_width = unit(5, "mm")*ncol(mat),
)
#dev.off()
```


```{r,out.width = '100%'}
knitr::include_graphics("test.png")
```

# Generation of Correlation plot

Let's make a correlation plot as well for the data. We have an object `total_t` calculated above. We can calculate the correlation of the antibiotics by using the frequency values of `I,R and S`. We will use `cor` function for this. 


```{r}
correlations <-cor(total_t)
head(correlations)
```

I am giving here two ways to generate correlation plots. You can select anyone of these.

```{r}
corrplot(correlations, type="lower", order="hclust",
         hclust.method = "ward.D",
         addrect = 2, 
         col=brewer.pal(n=8, name="RdYlBu"),
         cl.cex = 0.75,
         tl.cex=0.75,
         tl.col = "black",
         tl.srt = 90) 

```

```{r}
corrplot(correlations, type="lower", order="hclust",
         method="number",
         addrect = 2, 
         col=brewer.pal(n=8, name="RdYlBu"),
         cl.cex = 0.75,
         tl.cex=0.75,
         tl.col = "black",
         tl.srt = 90,
         number.cex=0.3)
```
We can use `heatmaply` package as well and calculate the p.values for correlations as well. 

```{r}
cor.test.p <- function(x){
  FUN <- function(x, y) cor.test(x, y)[["p.value"]]
  z <- outer(
    colnames(x), 
    colnames(x), 
    Vectorize(function(i,j) FUN(x[,i], x[,j]))
  )
  dimnames(z) <- list(colnames(x), colnames(x))
  z
}

p <- cor.test.p(total_t)


heatmaply_cor(correlations,
              node_type = "scatter",
              k_col = 2,
              k_row = 2, 
              point_size_mat = -log10(p), 
              point_size_name = "-log10(p-value)",
              label_names = c("x", "y", "Correlation"))
```


# ggplot of frequencies.

Following plots can be generated if you want by using ggplot.

```{r}
df.long <- pivot_longer(total, cols=2:4, names_to = "Classes", values_to = "Count")

# Calculate the cumulative sum of len for each dose
df_cumsum <- ddply(df.long, "Antibiotic",
                   transform, label_ypos=cumsum(Count))

#png("test2.png",width=10,height=10,units="in", res=1200)
ggplot(df_cumsum[which(df_cumsum$Count>0),],aes(x=Antibiotic,y=Count,fill=Classes))+
  geom_bar(stat="identity") +
  geom_text(aes(label=Count),
            position = position_stack(vjust = .5), 
            color="white", size=3.5)+
  scale_x_discrete(guide = guide_axis(angle = 45))+
#  scale_fill_brewer(palette="Paired") +
  scale_fill_manual(values=condition_colors_list)+
# scale_fill_manual(values=c("#999999", "#e6001b", "#56B4E9"))+
  labs(title="Cumulative Counts",
       x ="Antibiotics", y = "Count",fill= "Classes") +
  theme_minimal()+
  theme(plot.title = element_text(hjust = 0.5)) 
#dev.off()
```
