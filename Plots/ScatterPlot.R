# Datasets 
# https://vincentarelbundock.github.io/Rdatasets/datasets.html
# Iris Dataset will be used in this example
dataset <- iris

# How many rows and columns in this dataset
nrow(dataset) 
ncol(dataset)

#Setting up the Working Directory
setwd("c:/Users/rehan/Documents/Example")

# Validating the current working Directory
getwd()

# Saving Iris dataset to csv
write.csv(iris, file = "IRIS.csv",row.names=FALSE)

# Lets Import Data (Its just like you have your data in csv file so think like it)
imported_data <- read.csv("IRIS.csv", header = TRUE)

# See its Summary along with number of columns and rows
nrow(imported_data) 
ncol(imported_data)
summary(imported_data)

# Fill the variable species with values of column Species in iris data
species <- imported_data[,"Species"]
species

# Subset of Imported_data (Only rows with specie "Setosa" are taken)
Subset_sp <- subset(imported_data, Species=="setosa", select=c(Sepal.Length, Sepal.Width, Species))
Subset_sp

# Filling X and Y variables with different values
SL_x <- Subset_sp$Sepal.Length
SW_y <- Subset_sp$Sepal.Width
SL_x
SW_y
#=======================================================================
# Different Types of Simple Scatter plots. Only arguments are changed with different values. 
title <-"Scatter Plot of Sepal Length versus Sepal Width"

## Type 1
plot(SL_x,SW_y, pch = 20, frame = FALSE,
     main = title, xlab = "Sepal Legnth", ylab = "Sepal Width")

## Type 2
plot(SL_x,SW_y, pch = 18, frame = TRUE,
     main = title , xlab = "Sepal Legnth", ylab = "Sepal Width")

## Type 3
plot(SL_x,SW_y, pch = 11, frame = FALSE,
     main = title , xlab = "Sepal Legnth", ylab = "Sepal Width")

?plot.default()
#=======================================================================
# Complex Example
## For margins (bottom, left, top and right margins) and line width of the plot
par(mar = c(5, 4.5, 2, 2), # margins
    lwd = 2  #line thickness
)

?plot.default()
## Title of the plot
title <-"Scatter Plot of Sepal Length versus Sepal Width"

# Plot with different parameters
plot(SL_x, SW_y, pch = 20, cex = 2, frame = FALSE,
     main = title, xlab = "Sepal Legnth", ylab = "Sepal Width",
     sub = "sub title", cex.main = 1.5,   font.main= 4, col.main= "blue", cex.sub = 0.75, 
     font.sub = 3, col.sub = "red", col.axis = "blue", col.lab = "red", cex.axis = 1.5, 
     cex.lab = 1.5, las=3, bty="l", xlim=c(4, 6), ylim=c(2, 6),col="green")
#=======================================================================
# Straing lines along horizontal and verticle at different values
abline(h=4, col="orange")
abline(v=5, col="red")

# For Regression Line. 
abline(lm(SW_y ~ SL_x), col = "Orange", lty =2)
#=======================================================================
# Lets Calculate the Intercept, slop and r-square values. 
## Build a model on scatterplot
model <- lm(SW_y ~ SL_x)

## Save its summary
mod.sum <- summary(model)
mod.sum

## Fetch Intercept value from the summary
mod.sum$coefficients[1,1]
## Round off this value
Intercet<- round(mod.sum$coefficients[1,1],digits = 3)
Intercept
## Now save the slope in Slope variable in 2nd row and 1st columnd
Slope<- round(mod.sum$coefficients[2,1],digits = 3)
Slope

## Now save the r-square value
R2 <- mod.sum$r.squared
R2

# Paste these values as text on the plot
mtext(paste("R2=",R2,
            "\n",
            "Intercept=", Intercet,
            "\n",
            "Slope=", Slope, 
            sep=" "), side = 3, line = -4, adj = 1)
#=======================================================================
# Now add a lowess curve in the scatterplot
lines(lowess(SL_x, SW_y), col = "blue", lty =2)

# Generate a grid
grid (NULL,NULL, lty = 6, col = "gray") 

# Make a box around the plot 
box(col = 'red')
#=======================================================================
# Lets change the labels and axis
## First we have to remove the axis and labels from main command of plot. 
## For removing the labels and axis use xaxt="n", yaxt="n", axes = F
## Plot copied from above and added some arguments and removed others
plot(SL_x, SW_y, pch = 20, cex = 2, frame = FALSE,
     main = title, xlab = "Sepal Legnth", ylab = "Sepal Width",
     sub = "sub title", cex.main = 1.5,   font.main= 4, col.main= "blue", cex.sub = 0.75, 
     font.sub = 3, col.sub = "red", las=3, bty="l", col="green", xaxt="n", yaxt="n", axes = F)

# For X-axis
## Manage the range of X-ticks
xtick<-seq(4, 7, by=0.5)

## Format the x-axis
axis(1, col = 'blue', col.axis = 'purple', col.ticks = 'darkred', 
     cex.axis = 1.5, font = 2, family = 'serif', at=xtick, labels = FALSE, lwd = 0.2)

## Format the labels on X-axis
text(x=xtick,  par("usr")[3], 
     labels = xtick,  xpd = TRUE, pos = 1, srt = 45, adj = 0.965)

# For Y-axis
## Manage the range of Y-ticks
ytick<-seq(2, 6, by=0.25)

## Format the Y-axis
axis(2, col = 'maroon', col.axis = 'pink', col.ticks = 'limegreen', 
     cex.axis = 0.9, font =3, family = 'mono', at=ytick, labels = FALSE, lwd = 0.2)

## Format the Labels on Y-axis
text(par("usr")[1], ytick,  
     labels = ytick, xpd = TRUE, pos = 2, srt = 45, adj = 0.965)