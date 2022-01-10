# Complex Heatmap

### Install Packages

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
#install.packages("ggplot2")
```


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
library(ggplot2)
```

### Setting Working folder

```{r}
###### Folder Settings
folder<- "C:/Users/rehan/OneDrive/Desktop/Heatmap/Heatmap"
setwd(folder)
getwd()
```

### Calling CSV file of interest and data formating


```{r}
###### Reading Data
mydf_orig <- read.csv("ASTAPEC.csv", header = FALSE)
```

```{r}
head(mydf_orig)
```
#### Removing white spaces around the data

```{r}
mydf <- mydf_orig  %>%  mutate_all(trimws)
```

#### Making rownames and column names of the data

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

```{r}
mydf<-mydf[-c(1,2),]
```

#### Order data according to 2nd column

```{r}
mydf2 <- mydf[order(mydf[,2]),]
mydf<-mydf2[,-c(1,2)]
```

#### Generating matrix from the data.

```{r}
class(mydf)
```

```{r}
mat<- as.matrix(mydf)
head(mat)
#write.csv(mat, file="matrix.csv")
```

### Starting the data manipulation for complex heatmap

1. Annotation for Classes.
2. Annotation for Locations.
3. Generation of colors for conditions.
4. Generation of dendogram for character data.
3. Calculation of frequencies of R, I and S.
4. Generation of Heatmap.

#### Annotation for Classes.

```{r}
Antibiotics <- t(mydf_orig[1,-c(1,2)])
Antibiotics
```

```{r}
Antibiotics_unique <- t(unique(Antibiotics))
Antibiotics_unique
```

```{r}
colourCount_Antibiotics = length(Antibiotics_unique)
colourCount_Antibiotics
```

```{r}
getPalette = colorRampPalette(brewer.pal(9, "Set1"))
```

```{r}
Antibiotics_colors<- getPalette(colourCount_Antibiotics)
Antibiotics_colors
```
```{r}
show_col(Antibiotics_colors)
```
```{r}
list_antibiotics_colors <- setNames(Antibiotics_colors, Antibiotics_unique)
list_antibiotics_colors
```

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

```{r}
Cities <- (mydf2[,2])
Cities
```

```{r}
Cities_unique <- t(unique(Cities))
Cities_unique
```

```{r}
colourCount_Cities = length(Cities_unique)
colourCount_Cities
```

```{r}
getPalette2 = colorRampPalette(brewer.pal(9, "Set3"))
colors_Cities<- getPalette2(colourCount_Cities)
colors_Cities
```

```{r}
show_col(colors_Cities)
```

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

```{r}
# For calculating distances using stringdist package
dist_letters = function(x, y) {
  x = strtoi(charToRaw(paste(x, collapse = "")), base = 16)
  y = strtoi(charToRaw(paste(y, collapse = "")), base = 16)
  sqrt(sum((x - y)^2))
}
```

```{r}
fA =c("A","A","B")
fB=c("A","A","B")
dist_letters(fA,fB)
```

```{r}
fA=c("A","A","A")
fB =c("Z","Z","Z")
dist_letters(fA,fB)
```

```{r}
#between 1st and 2nd row
dist_letters(mat[1,],mat[2,])
```
```{r}
#between 1st and 2nd column
dist_letters(mat[,1],mat[,2])
```

#### Calculation of frequencies of R, I and S.

```{r}
table(mydf[,1],useNA = "ifany")
```



```{r}
lapply(mydf, table)
```


```{r}
factors <- sort(unique(unlist(mydf)))
factors
```

```{r}
total_IRS<- as.data.frame(do.call(rbind, lapply(mydf, function(x) table(factor(x, levels=factors)))))
total_IRS
```

```{r}
total <- tibble::rownames_to_column(total_IRS, "Antibiotic")
total
```


```{r}
total_t<- t(total)
total_t
```

```{r}
colnames(total_t)<-total_t[1,]
total_t <- total_t[-1,]
total_t
```

```{r}
class(total_t) <- "numeric"
```

#### Annotation of Frequency Plot for Heatmap

```{r}
h_frequencies = HeatmapAnnotation(Frequencies=anno_barplot(t(total_t),
                                                 gp=gpar(fill = condition_colors, 
                                                         col = condition_colors)))
plot(h_frequencies)
```
#### Generation of Heatmap

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
#knitr::include_graphics("Rplot.png")
```

# Generation of Correlation plot

```{r}
correlations <-cor(total_t)
head(correlations)
```

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

# Heatmap between two variables by using ggplot

```{r}
# Column names by Combining Row 1 and 2 after columns 1 and 2 with the names Isolates and Location. 
col.names <- c("Isolates", "Location", tail(paste(t(mydf_orig[1,]),t(mydf_orig[2,]),sep="."),n=-2))
```

```{r}
col.names
```

```{r}
# Setting column names of the data
mydf4 <- setNames(mydf_orig,col.names)
```

```{r}
# Removing 1st and 2nd row. 
mydf4 <- mydf4[-(1:2),]
```

```{r}
# Changing the data to long table
mydf5 <- melt(mydf4, id=c("Isolates", "Location"))
head(mydf5)
```
```{r}
# Separating the Antibiotic class from  generic names 
mydf6 <- separate(data = mydf5, col = variable, into = c("Antibiotic", "Generic"), sep = "\\.")

head(mydf6)
```

```{r}

###### Check Values in Column of "value" before and after removing whitespaces
mydf6 %>% group_by(value) %>% summarise(Count = n())

```

```{r}
mydf6 <- mydf6 %>%
  mutate_all(trimws)
mydf6 %>% group_by(value) %>% summarise(Count = n())
```

## Making Heatmap

we will make three different heatmaps:

1. Location versus generic (`L_G`).
2. Location versus Antibiotic Class (`L_A`).
3. Antibiotic Class versus Generic (`A_G`).

# Generating the Heatmap between Locations and Generic
```{r}
L_G <- ggplot(mydf6, aes(x = Location, y = Generic, fill = value)) +
  #add border white colour of line thickness 0.25
  geom_tile(colour="black",size=0.25) +
  #remove extra space
  scale_y_discrete(expand=c(0,0))+
  scale_fill_manual(values=c("#002EFF", "#FF2D00", "#56B4E9")) +
  coord_fixed() +
  scale_x_discrete(guide = guide_axis(angle = 45)) +
  geom_tile(color = "gray")

L_G
```


```{r}
# Generating the Heatmap between Locations and Antibiotic class
L_A <- ggplot(mydf6, aes(x = Location, y = Antibiotic, fill = value)) +
  #add border white colour of line thickness 0.25
  geom_tile(colour="black",size=0.25) +
  #remove extra space
  scale_y_discrete(expand=c(0,0))+
  scale_fill_manual(values=c("#002EFF", "#FF2D00", "#56B4E9")) +
  coord_fixed() +
  scale_x_discrete(guide = guide_axis(angle = 45)) +
  geom_tile(color = "gray")
L_A
```

```{r}
## Generating the Heatmap between Antibiotic and Generic
A_G <- ggplot(mydf6, aes(x = Antibiotic, y = Generic, fill = value)) +
  #add border white colour of line thickness 0.25
  geom_tile(colour="black",size=0.25) +
  #remove extra space
  scale_y_discrete(expand=c(0,0))+
  scale_fill_manual(values=c("#002EFF", "#FF2D00", "#56B4E9")) +
  coord_fixed() +
  scale_x_discrete(guide = guide_axis(angle = 45)) +
  geom_tile(color = "gray")
A_G
```


```{r}
# Combining all the above plots in three columns and one row. 

figure <- ggarrange(L_G, L_A, A_G,
                    labels = c("A", "B","C"),
                    ncol = 2, nrow = 2)
figure

```
