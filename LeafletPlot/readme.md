# Leaflet based interactive Maps in R

This repository has the R codes for genearting an interactive map based
on `leaflet package` of R. Complete description is given at [Leaflet
website](https://rstudio.github.io/leaflet/).

Here, `LeafletMapPlot.R` contains the code under different comments and
can be used according to your choice. Whereas,
`LeafletMapPlot_finalizedCode.R` contains the code written for youtube
video.`pk.csv` contains the lat, long with other columns for different
cities of Pakistan. This file can be obtained for your Country from
[Simplemaps.com](https://simplemaps.com/data/world-cities). 

The description of each line given in `LeafletMapPlot_finalizedCode.R` is given below in simple language.  

## Installation of leaflet package in R

We can install the leadlet package using the following command.

`install.packages("leaflet")`

After it we need to load the library for further usage in Rstudio. You can use the same in R terminal. 

`library(leaflet)`

## Our Data

We will make three datasets with names `df1`, `df2` and `df3`. `df1` is simple dataframe which contains two arguments i.e. `lat` and `lng` of the location which arer actually **Latitude** and **Longitude**, respectively. These coordinates can be taken from Google maps and openstreetmap. 

```
df1 <- data.frame(lng=174.768, lat=-36.852)
```

Second dataset i.e. `df2` is the dataframe which contains three locations and three `lat` and `lng`. Moreover, these three locaitons are also annotated with the dummy `Description` and `size`. If you see the data then it will look like a table of four coloumns with headers `lat`, `lng`, `Description` and `Size`. In three rows, the values are given for three different locations. 

```
df2 <- data.frame(
  lat = c(39.2973166, 39.3288851, 39.2906617),
  lng = c(-76.5929798, -76.6206598, -76.5469683),
  Description=c("Place1","Place2","Place3"),
  Size=c(900, 500, 100))
```
