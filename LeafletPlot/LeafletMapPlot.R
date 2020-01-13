install.packages("leaflet")
library(leaflet)

########################
# Simple World Map
########################
my_map <-  leaflet() %>% 
  addTiles() 
my_map  # Print the map

########################
# Simple World Map with set view
########################
my_map <- leaflet() %>%
  addTiles()  %>%
  setView(lng = -71.0589, lat = 42.3601, zoom = 12)
my_map

########################
# Dfferent formats of World Map. Visit following link for third-party tiles
# http://leaflet-extras.github.io/leaflet-providers/preview/
########################
# Stamen.Watercolor
# OpenTopoMap
my_map <- leaflet() %>%
  setView(lng = -71.0589, lat = 42.3601, zoom = 12) %>%
  addProviderTiles(providers$MtbMap)
my_map

########################
# Add single Marker
########################
prepare_map <- leaflet() %>%
  addProviderTiles(providers$MtbMap) %>%
  addProviderTiles(providers$Stamen.TonerLines,
                   options = providerTileOptions(opacity = 0.35)) %>%
  addProviderTiles(providers$Stamen.TonerLabels)

my_map <- prepare_map %>%
      addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")
my_map  


########################
# Add Several Markers
########################
df <- data.frame(
  lat = c(39.2973166, 39.3288851, 39.2906617),
  lng = c(-76.5929798, -76.6206598, -76.5469683))

prepare_map <- df %>%leaflet() %>%
  addProviderTiles(providers$MtbMap) %>%
  addProviderTiles(providers$Stamen.TonerLines,
                   options = providerTileOptions(opacity = 0.35)) %>%
  addProviderTiles(providers$Stamen.TonerLabels)


my_map <- prepare_map %>%
  addMarkers(clusterOptions = markerClusterOptions())
my_map

########################
# Add Several Markers after importing csv
########################
setwd("F:/FINAL_CODES/R_Codes/LeafletPlot/")
df <-read.csv("pk.csv") 

prepare_map <- df %>% leaflet() %>%
  addProviderTiles(providers$MtbMap) %>%
  addProviderTiles(providers$Stamen.TonerLines,
                   options = providerTileOptions(opacity = 0.35)) %>%
  addProviderTiles(providers$Stamen.TonerLabels)


my_map <- prepare_map %>%
  addMarkers(clusterOptions = markerClusterOptions())
my_map

########################
# Add Circle Markers
########################
my_map <- df %>% leaflet() %>% 
          addTiles() %>% 
          addCircleMarkers()


# Create a palette that maps factor levels to colors
pal <- colorFactor(c("navy", "red"), domain = c("admin", "minor"))

leaflet(df) %>% addTiles() %>%
  addCircleMarkers(
    radius = ~ifelse(type == "admin", 6, 10),
    color = ~pal(type),
    stroke = FALSE, fillOpacity = 0.5
  )

########################
# Add Circle Markers with radius
########################

cities <- read.csv(textConnection("
City,Lat,Long,Pop
Boston,42.3601,-71.0589,645966
Hartford,41.7627,-72.6743,125017
New York City,40.7127,-74.0059,8406000
Philadelphia,39.9500,-75.1667,1553000
Pittsburgh,40.4397,-79.9764,305841
Providence,41.8236,-71.4222,177994
"))

leaflet(cities) %>% addTiles() %>%
  addCircles(lng = ~Long, lat = ~Lat, weight = 1,
             radius = ~sqrt(Pop) * 30, popup = ~City
  )


########################
# Add Circle Markers of different colours
########################

cities <- read.csv(textConnection("
City,Lat,Long,Pop
Boston,42.3601,-71.0589,645966
Hartford,41.7627,-72.6743,125017
New York City,40.7127,-74.0059,8406000
Philadelphia,39.9500,-75.1667,1553000
Pittsburgh,40.4397,-79.9764,305841
Providence,41.8236,-71.4222,177994
"))

qpal <- colorQuantile("YlOrRd", cities$Pop, n = 4)

leaflet(cities) %>% 
  addTiles() %>%
  addCircles(lng = ~Long, lat = ~Lat, weight = 1,
             popup = ~City, radius = 30000, 
             color = ~qpal(Pop), fillOpacity = 1) %>%
  addLegend("bottomright", pal = qpal, values = ~Pop, 
            title = "Pop", opacity = 1)


########################
# Add Rectangles
########################
leaflet() %>% addTiles() %>%
  addRectangles(
    lng1=-118.456554, lat1=34.078039,
    lng2=-118.436383, lat2=34.062717,
    fillColor = "transparent"
  )

########################
# Adding popups
########################

content <- paste(sep = "<br/>",
                 "<b><a href='http://www.samurainoodle.com'>Samurai Noodle</a></b>",
                 "606 5th Ave. S",
                 "Seattle, WA 98138"
)

leaflet() %>% addTiles() %>%
  addPopups(-122.327298, 47.597131, content,
            options = popupOptions(closeButton = FALSE)
  )

########################
# Another way of showing popups
########################

library(htmltools)

df <- read.csv(textConnection(
  "Name,Lat,Long
Samurai Noodle,47.597131,-122.327298
Kukai Ramen,47.6154,-122.327157
Tsukushinbo,47.59987,-122.326726"
))

leaflet(df) %>% addTiles() %>%
  addMarkers(~Long, ~Lat, popup = ~htmlEscape(Name))

########################
# Customizing Marker Labels
########################
# Change Text Size and text Only and also a custom CSS
leaflet() %>% addTiles() %>% setView(-118.456554, 34.09, 13) %>%
  addMarkers(
    lng = -118.456554, lat = 34.105,
    label = "Default Label",
    labelOptions = labelOptions(noHide = T)) %>%
  addMarkers(
    lng = -118.456554, lat = 34.095,
    label = "Label w/o surrounding box",
    labelOptions = labelOptions(noHide = T, textOnly = TRUE)) %>%
  addMarkers(
    lng = -118.456554, lat = 34.085,
    label = "label w/ textsize 15px",
    labelOptions = labelOptions(noHide = T, textsize = "15px")) %>%
  addMarkers(
    lng = -118.456554, lat = 34.075,
    label = "Label w/ custom CSS style",
    labelOptions = labelOptions(noHide = T, direction = "bottom",
                                style = list(
                                  "color" = "red",
                                  "font-family" = "serif",
                                  "font-style" = "italic",
                                  "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                  "font-size" = "12px",
                                  "border-color" = "rgba(0,0,0,0.5)"
                                )))

########################
# Interactive Layer Display
########################

outline <- quakes[chull(quakes$long, quakes$lat),]

map <- leaflet(quakes) %>%
  # Base groups
  addTiles(group = "OSM (default)") %>%
  addProviderTiles(providers$Stamen.Toner, group = "Toner") %>%
  addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
  # Overlay groups
  addCircles(~long, ~lat, ~10^mag/5, stroke = F, group = "Quakes") %>%
  addPolygons(data = outline, lng = ~long, lat = ~lat,
              fill = F, weight = 2, color = "#FFFFCC", group = "Outline") %>%
  # Layers control
  addLayersControl(
    baseGroups = c("OSM (default)", "Toner", "Toner Lite"),
    overlayGroups = c("Quakes", "Outline"),
    options = layersControlOptions(collapsed = FALSE)
  )
map


########################
# Add measure
########################

m <- leaflet() %>% addTiles() %>%
  # Central Park
  fitBounds(-73.9, 40.75, -73.95,40.8) %>%
  #addMeasure()
  addMeasure(position = "bottomleft",
             primaryLengthUnit = "meters",
             primaryAreaUnit = "sqmeters",
             activeColor = "#3D535D",
             completedColor = "#7D4479")

m 

########################
# Minimap
########################

m <- leaflet() %>% addTiles() %>%
  # Central Park
  fitBounds(-73.9, 40.75, -73.95,40.8) %>%
  #addMeasure()
  addMeasure(position = "bottomleft",
             primaryLengthUnit = "meters",
             primaryAreaUnit = "sqmeters",
             activeColor = "#3D535D",
             completedColor = "#7D4479") %>%
  addMiniMap(
    tiles = providers$Esri.WorldStreetMap,
    toggleDisplay = TRUE) %>% addScaleBar()
m 






m = leaflet() %>% addTiles()
df = data.frame(
  lat = rnorm(100),
  lng = rnorm(100),
  size = runif(100, 5, 20),
  color = sample(colors(), 100)
)
m = leaflet(df) %>% addTiles()
m %>% addCircleMarkers(radius = ~size, color = ~color, fill = FALSE)
m %>% addCircleMarkers(radius = runif(100, 4, 10), color = c('red'))











################################
md_cities <- data.frame(name = c("Baltimore", "Frederick", "Rockville", "Gaithersburg", 
                                 "Bowie", "Hagerstown", "Annapolis", "College Park", "Salisbury", "Laurel"),
                        pop = c(619493, 66169, 62334, 61045, 55232,
                                39890, 38880, 30587, 30484, 25346),
                        lat = c(39.2920592, 39.4143921, 39.0840, 39.1434, 39.0068, 39.6418, 38.9784, 38.9897, 38.3607, 39.0993),
                        lng = c(-76.6077852, -77.4204875, -77.1528, -77.2014, -76.7791, -77.7200, -76.4922, -76.9378, -75.5994, -76.8483))
md_cities %>%
  leaflet() %>%
  addTiles() %>%
  #addCircles(weight = 1, radius = sqrt(md_cities$pop) * 30)
  addRectangles(lat1 = 37.3858, lng1 = -122.0595, 
              lat2 = 37.3890, lng2 = -122.0625)




#######################
df <- data.frame(lat = runif(20, min = 39.25, max = 39.35),
                 lng = runif(20, min = -76.65, max = -76.55),
                 col = sample(c("red", "blue", "green"), 20, replace = TRUE),
                 stringsAsFactors = FALSE)
df
df %>%
  leaflet() %>%
  addTiles() %>%
  addCircleMarkers(color = df$col) %>%
  addLegend(labels = LETTERS[1:3], colors = c("blue", "red", "green"))



########################
# Combine Different Tiles
########################
my_map <- leaflet() %>%
  setView(lng = -71.0589, lat = 42.3601, zoom = 12) %>%
  addProviderTiles(providers$MtbMap) %>%
  addProviderTiles(providers$Stamen.TonerLines,
                   options = providerTileOptions(opacity = 0.35)) %>%
  addProviderTiles(providers$Stamen.TonerLabels)
my_map
