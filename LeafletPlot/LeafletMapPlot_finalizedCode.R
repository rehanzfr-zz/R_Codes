install.packages("leaflet")
library(leaflet)

# Data for the leaflet
df1 <- data.frame(lng=174.768, lat=-36.852)

df2 <- data.frame(
  lat = c(39.2973166, 39.3288851, 39.2906617),
  lng = c(-76.5929798, -76.6206598, -76.5469683),
  Description=c("Place1","Place2","Place3"),
  Size=c(900, 500, 100))

df3 <-read.csv("F:/FINAL_CODES/R_Codes/LeafletPlot/pk.csv")

# Add Color Pallete for categorical input
pallete <- colorFactor(
  palette = c('red', 'blue', 'green'),
  domain = df2$Description
)
# or
pal <- colorFactor(
  palette = 'Set2',
  domain = df2$Description
)
# Add Color Pallete for continuous input
Contpallete <- colorQuantile("YlOrRd", df2$Size, n = 3)

# Adding html based popup information
content <- paste(sep = "<br/>",
"<b><a href='https://github.com/rehanzfr'>Rehan Zafar</a></b>",
"Youtuber",
"Educator"
)

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
              fill = F, weight = 2, color = "red", group = "Outline") %>%

# Layers control
addLayersControl(
  baseGroups = c("MtbMAP", "Tonerlines", "TonerLabels"),
  overlayGroups = c("df2", "Outline"),
  options = layersControlOptions(collapsed = FALSE)
) %>%

addMeasure(position = "bottomleft",
             primaryLengthUnit = "meters",
             primaryAreaUnit = "sqmeters",
             activeColor = "#3D535D",
             completedColor = "#7D4479") %>%

addMiniMap(
    tiles = providers$Esri.WorldStreetMap,
    toggleDisplay = TRUE) %>% addScaleBar()
prepare_map  # Print the map


