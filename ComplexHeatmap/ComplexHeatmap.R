## Install Packages

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

## Call Libraries
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

## Setting Working folder

folder<- "C:/Users/rehan/OneDrive/Desktop/Heatmap/Heatmap"
setwd(folder)
getwd()

## Calling CSV file of interest and data formating

mydf_orig <- read.csv("ASTAPEC.csv", header = FALSE)
mydf <- mydf_orig  %>%  mutate_all(trimws)
mydf[,1]
mydf[2,]

rownames(mydf)<-mydf[,1]
colnames(mydf)<-mydf[2,]

mydf<-mydf[-c(1,2),]
mydf2 <- mydf[order(mydf[,2]),]
mydf<-mydf2[,-c(1,2)]
class(mydf)

mat<- as.matrix(mydf)
head(mat)
#write.csv(mat, file="matrix.csv")

## Starting the data manipulation for complex heatmap

# Annotation for Classes.
Antibiotics <- t(mydf_orig[1,-c(1,2)])
Antibiotics

Antibiotics_unique <- t(unique(Antibiotics))
Antibiotics_unique

colourCount_Antibiotics = length(Antibiotics_unique)
colourCount_Antibiotics

getPalette = colorRampPalette(brewer.pal(9, "Set1"))

Antibiotics_colors<- getPalette(colourCount_Antibiotics)
Antibiotics_colors

show_col(Antibiotics_colors)

list_antibiotics_colors <- setNames(Antibiotics_colors, Antibiotics_unique)
list_antibiotics_colors

h_antib = HeatmapAnnotation(Antibiotics = Antibiotics,
                       col = list(Antibiotics= list_antibiotics_colors),
                       gp = gpar(col = "black"),
                       border = TRUE)
					   
plot(h_antib)

## Annotation for Locations.

Cities <- (mydf2[,2])
Cities

Cities_unique <- t(unique(Cities))
Cities_unique

colourCount_Cities = length(Cities_unique)
colourCount_Cities

getPalette2 = colorRampPalette(brewer.pal(9, "Set3"))
colors_Cities<- getPalette2(colourCount_Cities)
colors_Cities

show_col(colors_Cities)

col2_cities <- setNames(colors_Cities, Cities_unique)

h_cities= rowAnnotation(Cities = Cities,
                   col = list(Cities= col2_cities),
                   gp = gpar(col = "black", fontsize = 3),
                   border = TRUE)
				   
plot(h_cities)

## Generation of colors for conditions.

condition_colors <- c("#36D3C4","#D33636", "#3CD336")

condition_colors_list = structure(condition_colors, names = c("I","R","S"))
condition_colors_list
show_col(condition_colors_list)

haha <- setNames(condition_colors, c("I","R","S"))
haha
show_col(haha)

## Generation of dendogram for character data.

# For calculating distances using stringdist package
dist_letters = function(x, y) {
  x = strtoi(charToRaw(paste(x, collapse = "")), base = 16)
  y = strtoi(charToRaw(paste(y, collapse = "")), base = 16)
  sqrt(sum((x - y)^2))
}

fA =c("A","A","B")
fB=c("A","A","B")
dist_letters(fA,fB)

fA=c("A","A","A")
fB =c("Z","Z","Z")
dist_letters(fA,fB)

#between 1st and 2nd row
dist_letters(mat[1,],mat[2,])

#between 1st and 2nd column
dist_letters(mat[,1],mat[,2])

## Calculation of frequencies of R, I and S.

table(mydf[,1],useNA = "ifany")
lapply(mydf, table)

factors <- sort(unique(unlist(mydf)))
factors

total_IRS<- as.data.frame(do.call(rbind, lapply(mydf, function(x) table(factor(x, levels=factors)))))
total_IRS

total <- tibble::rownames_to_column(total, "Antibiotic")
total

total_t<- t(total)
total_t

colnames(total_t)<-total_t[1,]
total_t <- total_t[-1,]
total_t

class(total_t) <- "numeric"

## Annotation of Frequency Plot for Heatmap

h_frequencies = HeatmapAnnotation(Frequencies=anno_barplot(t(total_t),
                                                 gp=gpar(fill = condition_colors, 
                                                         col = condition_colors)))
plot(h_frequencies)

## Generation of Heatmap

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

## Generation of Correlation plot

correlations <-cor(total_t)
head(correlations)


corrplot(correlations, type="lower", order="hclust",
         hclust.method = "ward.D",
         addrect = 2, 
         col=brewer.pal(n=8, name="RdYlBu"),
         cl.cex = 0.75,
         tl.cex=0.75,
         tl.col = "black",
         tl.srt = 90) 
		 
corrplot(correlations, type="lower", order="hclust",
         method="number",
         addrect = 2, 
         col=brewer.pal(n=8, name="RdYlBu"),
         cl.cex = 0.75,
         tl.cex=0.75,
         tl.col = "black",
         tl.srt = 90,
         number.cex=0.3)

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
			  
## ggplot of frequencies.

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
