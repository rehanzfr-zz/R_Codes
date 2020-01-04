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
  setView(lng = -71.0589, lat = 42.3601, zoom = 12) %>%
  addTiles() 
my_map

########################
# Dfferent formats of World Map. Visit following link for third-party tiles
# http://leaflet-extras.github.io/leaflet-providers/preview/
########################
# Stamen.Watercolor
# OpenTopoMap
my_map <- leaflet() %>%
  setView(lng = -71.0589, lat = 42.3601, zoom = 12) %>%
  addProviderTiles(providers$Stamen.TonerLines)
my_map

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


