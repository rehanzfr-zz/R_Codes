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

```R
install.packages("leaflet")
```

After it we need to load the library for further usage in Rstudio. You can use the same in R terminal.

```R
library(leaflet)
```

## Our Data

We will make three datasets with names `df1`, `df2` and `df3`. `df1` is simple dataframe which contains two arguments i.e. `lat` and `lng` of the location which arer actually **Latitude** and **Longitude**, respectively. These coordinates can be taken from Google maps and openstreetmap.

```R
df1 <- data.frame(lng=174.768, lat=-36.852)
```

Second dataset i.e. `df2` is the dataframe which contains three locations and three `lat` and `lng`. Moreover, these three locaitons are also annotated with the dummy `Description` and `size`. If you see the data then it will look like a table of four coloumns with headers `lat`, `lng`, `Description` and `Size`. In three rows, the values are given for three different locations. You can change the values here with your own.

```R
df2 <- data.frame(
  lat = c(39.2973166, 39.3288851, 39.2906617),
  lng = c(-76.5929798, -76.6206598, -76.5469683),
  Description=c("Place1","Place2","Place3"),
  Size=c(900, 500, 100))
```

Next dataframe i.e. `df3` is mae by reading a csv file containing information about different cities of Pakistan.

```R
df3 <-read.csv("F:/FINAL_CODES/R_Codes/LeafletPlot/pk.csv")
```

You can use anyone of the dataframes in the following code. I am using `df2` as simple case. Just replace `df2` with `df1` or `df3`  and see the results.

## Add Color Pallete for categorical input

Color pallets can be usd to distinguish between different locations. Specifically when we will add circle markers or cicles. Following code can be used to make a **pallete** object for later useage. 

```R
pallete <- colorFactor(
  palette = c('red', 'blue', 'green'),
  domain = df2$Description
)
```

`colorFactor()` is used to describe the colors for categorical data. `domain` is an argument to link the colors with the categorical values in the dataframe `df2` stored in `Description`. Here, `red` color is used for `Place1` i.e. stored in `description` of `df2` (`df2$Description`). On the other hand, you can also give the default color pallete. I am using `Set2` color pallet. For other color pallets you can see the image below.  

```R
pal <- colorFactor(
  palette = 'Set2',
  domain = df2$Description
)
```

You can definitely search `Set2` in following image.

<img src="https://www.datanovia.com/en/wp-content/uploads/dn-tutorials/ggplot2/figures/029-r-color-palettes-rcolorbrewer-palettes-1.png" width="200">

Similarly, following cocde can be used to describe colors for continuous data such as `Size` in `df2`.

```R
Contpallete <- colorQuantile("YlOrRd", df2$Size, n = 3)
```

## Add the html based object for labels

The following object i.e. `content` will be used to describe the labels/markers text. 

```R
content <- paste(sep = "<br/>",
"<b><a href='https://github.com/rehanzfr'>Rehan Zafar</a></b>",
"Youtuber",
"Educator"
)
```

## Interactive Map

Now we will see a long code which will make object of interactive map. In this context, you will need to understand the pipe (`%>%`) operator first. I think the function of this operator like this:  

```R
World %>% Continent %>% Country %>% City %>% Street %>% Home
```

In similar way, the following code contains the pipe operator.

```R
prepare_map <-  df2 %>% leaflet() %>%
addTiles() 
```

We read this line of code as take `df2` and apply `leaflet()` function on it. Later on `addtiles()`.  The function `addtiles()` is used to add map of specific format. Later on This will be commented and some other formats are used.

```R
prepare_map <-  df2 %>% leaflet() %>%
addTiles() %>%
setView(lng = -76.5929798, lat = 39.2973166, zoom = 12)  %>%  
```

`setview()` set the view to a specific location with zoom level. Now, we will comment out the these two lines and add new format of map by using the function `addaddProviderTiles()`. Different format of maps can be found on [http://leaflet-extras.github.io/leaflet-providers/preview/index.html](http://leaflet-extras.github.io/leaflet-providers/preview/index.html). Search `MtbMAP` over there.

```R
prepare_map <-  df2 %>% leaflet() %>%
#addTiles() %>%
#setView(lng = -76.5929798, lat = 39.2973166, zoom = 12)  %>%  
addProviderTiles(providers$MtbMap, group = 'MtbMAP')
```

Now add two more formats and superimpose all of them to make a new format of the map. These are `Tonerlines` and `TonerLabels`. These formats are also taken from the same website given above. The transparency of `Tonerlines` is set to be `0.35`.  

```R
prepare_map <-  df2 %>% leaflet() %>%
#addTiles() %>%
#setView(lng = -76.5929798, lat = 39.2973166, zoom = 12)  %>%  
addProviderTiles(providers$MtbMap, group = 'MtbMAP') %>%  
addProviderTiles(providers$Stamen.TonerLines, 
                 options = providerTileOptions(opacity = 0.35), group = 'Tonerlines')  %>% 
addProviderTiles(providers$Stamen.TonerLabels,group = 'TonerLabels')
```

The `group` is devised for later control. So keep it ming until the end of the code where it will be used. Now, add one more function of `addMarkers` to describe the locaitons saved in `df2`.  Here rest of the arguments are self explanatory/ However, `clusterOptions` is used to describe that when we scroll mouse wheel then cluster the three locations into one cluster and number the cluster with how many locations are in this cluster. Do it and scroll the mouse wheel. 

```R
prepare_map <-  df2 %>% leaflet() %>%
#addTiles() %>%
#setView(lng = -76.5929798, lat = 39.2973166, zoom = 12)  %>%  
addProviderTiles(providers$MtbMap, group = 'MtbMAP') %>%  
addProviderTiles(providers$Stamen.TonerLines, 
                 options = providerTileOptions(opacity = 0.35), group = 'Tonerlines')  %>% 
addProviderTiles(providers$Stamen.TonerLabels,group = 'TonerLabels') %>% 
addMarkers(lat=df2$lat, lng= df2$lng, popup=df2$Description,
          clusterOptions = markerClusterOptions())
```

If you are interested in labeling with only text then use following script which contains `addLabelOnlyMarkers()`:

```R
prepare_map <-  df2 %>% leaflet() %>%
#addTiles() %>%
#setView(lng = -76.5929798, lat = 39.2973166, zoom = 12)  %>%  
addProviderTiles(providers$MtbMap, group = 'MtbMAP') %>%  
addProviderTiles(providers$Stamen.TonerLines, 
                 options = providerTileOptions(opacity = 0.35), group = 'Tonerlines')  %>% 
addProviderTiles(providers$Stamen.TonerLabels,group = 'TonerLabels') %>% 
#addMarkers(lat=df2$lat, lng= df2$lng, popup=df2$Description,
#           clusterOptions = markerClusterOptions()) %>% 
addLabelOnlyMarkers(~lng, ~lat, label =  df2$Description, 
                   labelOptions = labelOptions(noHide = T, direction = 'top'
                                               ,textOnly = T))
```

Now change the type of marker by using another function of `addCircleMarkers()`.

```R
prepare_map <-  df2 %>% leaflet() %>%
#addTiles() %>%
#setView(lng = -76.5929798, lat = 39.2973166, zoom = 12)  %>%  
addProviderTiles(providers$MtbMap, group = 'MtbMAP') %>%  
addProviderTiles(providers$Stamen.TonerLines, 
                 options = providerTileOptions(opacity = 0.35), group = 'Tonerlines')  %>% 
addProviderTiles(providers$Stamen.TonerLabels,group = 'TonerLabels') %>% 
#addMarkers(lat=df2$lat, lng= df2$lng, popup=df2$Description,
#           clusterOptions = markerClusterOptions()) %>% 
#addLabelOnlyMarkers(~lng, ~lat, label =  df2$Description, 
#                   labelOptions = labelOptions(noHide = T, direction = 'top'
#                                               ,textOnly = T)) %>% 
addCircleMarkers(color= "red", lat=~lat, lng= ~lng, 
                 clusterOptions = markerClusterOptions())
#addCircleMarkers(color= ~pallete(Description), lat=~lat, lng= ~lng, 
#                 clusterOptions = markerClusterOptions(), 
#                 #radius = ~ifelse(Description == "Place1", 26, 10),
#                 radius = ~sqrt(Size),
#                 stroke = FALSE, fillOpacity = 0.5) 
```

Lets, format the circle markers by chcanging the radius of the markers according to the size of locations mentioned in `df2`. 

```R
prepare_map <-  df2 %>% leaflet() %>%
#addTiles() %>%
#setView(lng = -76.5929798, lat = 39.2973166, zoom = 12)  %>%  
addProviderTiles(providers$MtbMap, group = 'MtbMAP') %>%  
addProviderTiles(providers$Stamen.TonerLines, 
                 options = providerTileOptions(opacity = 0.35), group = 'Tonerlines')  %>% 
addProviderTiles(providers$Stamen.TonerLabels,group = 'TonerLabels') %>% 
#addMarkers(lat=df2$lat, lng= df2$lng, popup=df2$Description,
#           clusterOptions = markerClusterOptions()) %>% 
#addLabelOnlyMarkers(~lng, ~lat, label =  df2$Description, 
#                   labelOptions = labelOptions(noHide = T, direction = 'top'
#                                               ,textOnly = T)) %>% 
#addCircleMarkers(color= "red", lat=~lat, lng= ~lng, 
#                 clusterOptions = markerClusterOptions())
addCircleMarkers(color= ~pallete(Description), lat=~lat, lng= ~lng, 
                 clusterOptions = markerClusterOptions(), 
                 #radius = ~ifelse(Description == "Place1", 26, 10),
                 radius = ~sqrt(Size),
                 stroke = FALSE, fillOpacity = 0.5)
```

Another funcction i.e. `addCircles()` cana alo be used to devise the radius of the cicles for eachc location.

```R
prepare_map <-  df2 %>% leaflet() %>%
#addTiles() %>%
#setView(lng = -76.5929798, lat = 39.2973166, zoom = 12)  %>%  
addProviderTiles(providers$MtbMap, group = 'MtbMAP') %>%  
addProviderTiles(providers$Stamen.TonerLines, 
                 options = providerTileOptions(opacity = 0.35), group = 'Tonerlines')  %>% 
addProviderTiles(providers$Stamen.TonerLabels,group = 'TonerLabels') %>% 
#addMarkers(lat=df2$lat, lng= df2$lng, popup=df2$Description,
#           clusterOptions = markerClusterOptions()) %>% 
addLabelOnlyMarkers(~lng, ~lat, label =  df2$Description, 
                   labelOptions = labelOptions(noHide = T, direction = 'top'
                                               ,textOnly = T)) %>% 
#addCircleMarkers(color= "red", lat=~lat, lng= ~lng, 
#                 clusterOptions = markerClusterOptions())
#addCircleMarkers(color= ~pallete(Description), lat=~lat, lng= ~lng, 
#                 clusterOptions = markerClusterOptions(), 
#                 #radius = ~ifelse(Description == "Place1", 26, 10),
#                 radius = ~sqrt(Size),
#                 stroke = FALSE, fillOpacity = 0.5) %>%
addCircles(lng = ~lng, lat = ~lat, weight = 1,
             popup = ~Description, radius = ~sqrt(Size)*15, 
             color = ~Contpallete(Size), fillOpacity = 1, group = "df2")
```

Let's add the legend to the map.

```R
prepare_map <-  df2 %>% leaflet() %>%
#addTiles() %>%
#setView(lng = -76.5929798, lat = 39.2973166, zoom = 12)  %>%  
addProviderTiles(providers$MtbMap, group = 'MtbMAP') %>%  
addProviderTiles(providers$Stamen.TonerLines, 
                 options = providerTileOptions(opacity = 0.35), group = 'Tonerlines')  %>% 
addProviderTiles(providers$Stamen.TonerLabels,group = 'TonerLabels') %>% 
#addMarkers(lat=df2$lat, lng= df2$lng, popup=df2$Description,
#           clusterOptions = markerClusterOptions()) %>% 
addLabelOnlyMarkers(~lng, ~lat, label =  df2$Description, 
                   labelOptions = labelOptions(noHide = T, direction = 'top'
                                               ,textOnly = T)) %>% 
#addCircleMarkers(color= "red", lat=~lat, lng= ~lng, 
#                 clusterOptions = markerClusterOptions())
#addCircleMarkers(color= ~pallete(Description), lat=~lat, lng= ~lng, 
#                 clusterOptions = markerClusterOptions(), 
#                 #radius = ~ifelse(Description == "Place1", 26, 10),
#                 radius = ~sqrt(Size),
#                 stroke = FALSE, fillOpacity = 0.5) %>%
addCircles(lng = ~lng, lat = ~lat, weight = 1,
             popup = ~Description, radius = ~sqrt(Size)*15, 
             color = ~Contpallete(Size), fillOpacity = 1, group = "df2") %>%

addLegend("bottomright", pal = Contpallete, values = ~Size, 
            title = "Size", opacity = 1)
```
If you want to add rectangle. 

```R
prepare_map <-  df2 %>% leaflet() %>%
#addTiles() %>%
#setView(lng = -76.5929798, lat = 39.2973166, zoom = 12)  %>%  
addProviderTiles(providers$MtbMap, group = 'MtbMAP') %>%  
addProviderTiles(providers$Stamen.TonerLines, 
                 options = providerTileOptions(opacity = 0.35), group = 'Tonerlines')  %>% 
addProviderTiles(providers$Stamen.TonerLabels,group = 'TonerLabels') %>% 
#addMarkers(lat=df2$lat, lng= df2$lng, popup=df2$Description,
#           clusterOptions = markerClusterOptions()) %>% 
addLabelOnlyMarkers(~lng, ~lat, label =  df2$Description, 
                   labelOptions = labelOptions(noHide = T, direction = 'top'
                                               ,textOnly = T)) %>% 
#addCircleMarkers(color= "red", lat=~lat, lng= ~lng, 
#                 clusterOptions = markerClusterOptions())
#addCircleMarkers(color= ~pallete(Description), lat=~lat, lng= ~lng, 
#                 clusterOptions = markerClusterOptions(), 
#                 #radius = ~ifelse(Description == "Place1", 26, 10),
#                 radius = ~sqrt(Size),
#                 stroke = FALSE, fillOpacity = 0.5) %>%
addCircles(lng = ~lng, lat = ~lat, weight = 1,
             popup = ~Description, radius = ~sqrt(Size)*15, 
             color = ~Contpallete(Size), fillOpacity = 1, group = "df2") %>%

addLegend("bottomright", pal = Contpallete, values = ~Size, 
            title = "Size", opacity = 1) %>%

addRectangles(
  lng1=-76.5929798, lat1=39.2973166,
  lng2=-76.6206598, lat2=39.3288851,
  fillColor = "transparent")
```

Add popups according to your need.

```R
prepare_map <-  df2 %>% leaflet() %>%
#addTiles() %>%
#setView(lng = -76.5929798, lat = 39.2973166, zoom = 12)  %>%  
addProviderTiles(providers$MtbMap, group = 'MtbMAP') %>%  
addProviderTiles(providers$Stamen.TonerLines, 
                 options = providerTileOptions(opacity = 0.35), group = 'Tonerlines')  %>% 
addProviderTiles(providers$Stamen.TonerLabels,group = 'TonerLabels') %>% 
#addMarkers(lat=df2$lat, lng= df2$lng, popup=df2$Description,
#           clusterOptions = markerClusterOptions()) %>% 
addLabelOnlyMarkers(~lng, ~lat, label =  df2$Description, 
                   labelOptions = labelOptions(noHide = T, direction = 'top'
                                               ,textOnly = T)) %>% 
#addCircleMarkers(color= "red", lat=~lat, lng= ~lng, 
#                 clusterOptions = markerClusterOptions())
#addCircleMarkers(color= ~pallete(Description), lat=~lat, lng= ~lng, 
#                 clusterOptions = markerClusterOptions(), 
#                 #radius = ~ifelse(Description == "Place1", 26, 10),
#                 radius = ~sqrt(Size),
#                 stroke = FALSE, fillOpacity = 0.5) %>%
addCircles(lng = ~lng, lat = ~lat, weight = 1,
             popup = ~Description, radius = ~sqrt(Size)*15, 
             color = ~Contpallete(Size), fillOpacity = 1, group = "df2") %>%

addLegend("bottomright", pal = Contpallete, values = ~Size, 
            title = "Size", opacity = 1) %>%

#addRectangles(
#  lng1=-76.5929798, lat1=39.2973166,
#  lng2=-76.6206598, lat2=39.3288851,
#  fillColor = "transparent")  %>%

addPopups(lng=-76.61289, lat=39.29793, content,
            options = popupOptions(closeButton = FALSE))
```

Let's add the customised marker. 

```R
prepare_map <-  df2 %>% leaflet() %>%
#addTiles() %>%
#setView(lng = -76.5929798, lat = 39.2973166, zoom = 12)  %>%  
addProviderTiles(providers$MtbMap, group = 'MtbMAP') %>%  
addProviderTiles(providers$Stamen.TonerLines, 
                 options = providerTileOptions(opacity = 0.35), group = 'Tonerlines')  %>% 
addProviderTiles(providers$Stamen.TonerLabels,group = 'TonerLabels') %>% 
#addMarkers(lat=df2$lat, lng= df2$lng, popup=df2$Description,
#           clusterOptions = markerClusterOptions()) %>% 
addLabelOnlyMarkers(~lng, ~lat, label =  df2$Description, 
                   labelOptions = labelOptions(noHide = T, direction = 'top'
                                               ,textOnly = T)) %>% 
#addCircleMarkers(color= "red", lat=~lat, lng= ~lng, 
#                 clusterOptions = markerClusterOptions())
#addCircleMarkers(color= ~pallete(Description), lat=~lat, lng= ~lng, 
#                 clusterOptions = markerClusterOptions(), 
#                 #radius = ~ifelse(Description == "Place1", 26, 10),
#                 radius = ~sqrt(Size),
#                 stroke = FALSE, fillOpacity = 0.5) %>%
addCircles(lng = ~lng, lat = ~lat, weight = 1,
             popup = ~Description, radius = ~sqrt(Size)*15, 
             color = ~Contpallete(Size), fillOpacity = 1, group = "df2") %>%

addLegend("bottomright", pal = Contpallete, values = ~Size, 
            title = "Size", opacity = 1) %>%

#addRectangles(
#  lng1=-76.5929798, lat1=39.2973166,
#  lng2=-76.6206598, lat2=39.3288851,
#  fillColor = "transparent")  %>%

#addPopups(lng=-76.61289, lat=39.29793, content,
#            options = popupOptions(closeButton = FALSE))

addMarkers(lng = -76.61289, lat = 39.29793,
    label = "Label with custom style",
    labelOptions = labelOptions(noHide = T, direction = "bottom",
                                style = list(
                                  "color" = "red",
                                  "font-family" = "serif",
                                  "font-style" = "italic",
                                  "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                  "font-size" = "15px",
                                  "border-color" = "rgba(0,0,0,0.5)"
                                ))) 
```

Add the polygon around the location. 

```R
prepare_map <-  df2 %>% leaflet() %>%
#addTiles() %>%
#setView(lng = -76.5929798, lat = 39.2973166, zoom = 12)  %>%  
addProviderTiles(providers$MtbMap, group = 'MtbMAP') %>%  
addProviderTiles(providers$Stamen.TonerLines, 
                 options = providerTileOptions(opacity = 0.35), group = 'Tonerlines')  %>% 
addProviderTiles(providers$Stamen.TonerLabels,group = 'TonerLabels') %>% 
#addMarkers(lat=df2$lat, lng= df2$lng, popup=df2$Description,
#           clusterOptions = markerClusterOptions()) %>% 
addLabelOnlyMarkers(~lng, ~lat, label =  df2$Description, 
                   labelOptions = labelOptions(noHide = T, direction = 'top'
                                               ,textOnly = T)) %>% 
#addCircleMarkers(color= "red", lat=~lat, lng= ~lng, 
#                 clusterOptions = markerClusterOptions())
#addCircleMarkers(color= ~pallete(Description), lat=~lat, lng= ~lng, 
#                 clusterOptions = markerClusterOptions(), 
#                 #radius = ~ifelse(Description == "Place1", 26, 10),
#                 radius = ~sqrt(Size),
#                 stroke = FALSE, fillOpacity = 0.5) %>%
addCircles(lng = ~lng, lat = ~lat, weight = 1,
             popup = ~Description, radius = ~sqrt(Size)*15, 
             color = ~Contpallete(Size), fillOpacity = 1, group = "df2") %>%

addLegend("bottomright", pal = Contpallete, values = ~Size, 
            title = "Size", opacity = 1) %>%

#addRectangles(
#  lng1=-76.5929798, lat1=39.2973166,
#  lng2=-76.6206598, lat2=39.3288851,
#  fillColor = "transparent")  %>%

#addPopups(lng=-76.61289, lat=39.29793, content,
#            options = popupOptions(closeButton = FALSE))

    
addMarkers(lng = -76.61289, lat = 39.29793,
    label = "Label with custom style",
    labelOptions = labelOptions(noHide = T, direction = "bottom",
                                style = list(
                                  "color" = "red",
                                  "font-family" = "serif",
                                  "font-style" = "italic",
                                  "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                  "font-size" = "15px",
                                  "border-color" = "rgba(0,0,0,0.5)"
                                ))) %>%
  
addPolygons(data = df2, lng = ~lng, lat = ~lat,
              fill = F, weight = 2, color = "red", group = "Outline")
```

Now, we will use `addLayersControl()` function in the script to define the groups mentioned above at different levels as our options which can be turned on or off.   

```R
addLayersControl(
  baseGroups = c("MtbMAP", "Tonerlines", "TonerLabels"),
  overlayGroups = c("df2", "Outline"),
  options = layersControlOptions(collapsed = FALSE)
)
```

The measurement option can be added using following lines:

```R
addMeasure(position = "bottomleft",
             primaryLengthUnit = "meters",
             primaryAreaUnit = "sqmeters",
             activeColor = "#3D535D",
             completedColor = "#7D4479")
```

Now add a mini map on one side of the interactive map. 

```R
addMiniMap(
    tiles = providers$Esri.WorldStreetMap,
    toggleDisplay = TRUE) 
```

Scale bar of the main map can be defined as:

```R
addScaleBar()
```

Several other things can be done with `leaflet`. However, this tutorial is finised here with the last line given below as most of the requirements for producing maps  have been fulfilled.

```R
prepare_map  # Print the map
```

> Note: Clerical mistakes are expected. Suggesstions are welcome to improve this readme along with the source codes. 
