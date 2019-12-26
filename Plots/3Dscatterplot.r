#Install Scatterplot3D
install.packages("scatterplot3d") 

# Call Library
library("scatterplot3d")

# For Colors Visit http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf
colors <- c("chartreuse", "#E69F00", "#56B4E9")

# Lets Import Data (You can import your csv after saving it from Excel)
imported_data <- read.csv("IRIS.csv", header = TRUE)

# Iris dataset
z <- imported_data$Sepal.Length
x <- imported_data$Sepal.Width
y <- imported_data$Petal.Length

# Make Sctterplot
S3D <- scatterplot3d(x, y, z,
                     main="3D Scatter Plot",
                     sub="Subtitle",
                     xlab="X-axis", 
                     ylab="Y-axis", 
                     zlab="Z-axis",
                     #highlight.3d=TRUE, 
                     #col.axis="blue",
                     #col.grid="lightblue",
                     #col.lab="royalblue",
                     #cex.axis =1, 
                     #cex.lab=1,
                     #font.axis=2 , 
                     #font.lab=1,
                     #lty.axis=2, 
                     #lty.grid=2,
                     #color=colors[grps],                          # Will be ignored if highlight.3d = TRUE
                     #pch=shapes,
                     #xlim=c(-1,2), 
                     #ylim=c(-1,2),
                     #zlim=c(-9, 10),
                     #type="h",
                     #scale.y,
                     #grid=TRUE, 
                     #box=FALSE,
                     #angle = 45,
                     #axis=TRUE,                              
                     #tick.marks=TRUE,                             # only if axis = TRUE
                     #label.tick.marks=TRUE,
                     #lab=c(-1,1,1),
                     #lab.z=
                     #lwd=5,
                     #mar = c(5, 5, 4, 3)
)




# Add labels to the points (OPTIONAL)
S3D.coords <- S3D$xyz.convert(x, y, z)
text(S3D.coords$x, S3D.coords$y,                                   # x and y coordinates
     labels=iris$Species,                                          # text on plot
     cex=.5, pos=4)                                        

# add the legend (OPTIONAL)
legend("topleft",                                                  # topleft, right, bottom
       inset=.05,
       legend = levels(iris$Species),
       bty="n", cex=1,                                             # suppress legend box, shrink text 50%
       pch = c(16, 17, 18),
       col =  colors, 
       title="Type",
       xpd = TRUE,
       c("Sepal.Width", "Petal.Length", "Sepal.Length"), 
       #fill=colors, 
       horiz = FALSE
)

# Add regression plane (OPTIONAL)
lm <- lm(z ~ x + y)
S3D$plane3d(lm, draw_polygon = TRUE, draw_lines = FALSE, 
            polygon_args = list(col = adjustcolor( "slategray1", alpha.f = 0.2)),lty= "dotted" , lwd=0.7)