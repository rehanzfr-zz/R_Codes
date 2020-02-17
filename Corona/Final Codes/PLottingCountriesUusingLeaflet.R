library(leaflet)
library(rvest)
URL <- "https://www.cdc.gov/coronavirus/2019-ncov/locations-confirmed-cases.html#map"

# Web Scrap the URL. XPath will be copied from URL.
PAGE <- read_html(URL) %>%
  html_nodes(xpath="/html/body/div[6]/main/div[3]/div/div[3]/div/div/ul") %>%
  purrr::map(~html_nodes(.x, 'li') %>% 
               html_text() %>% 
               gsub(pattern = '\\t|\\r|\\n', replacement = ''))
countries <- PAGE[[1]]
countries
# countries_updated <- ifelse(countries  == "United States", "USA", countries)    
# Convert to Dataframe
countries <- as.data.frame(matrix(unlist(countries),nrow=length(countries),byrow=TRUE))
countries
names(countries)[1] <- "Countries"
Countriestable <- data.frame(Sr.No.=seq.int(nrow(countries)),countries)
Countriestable
#Countriestable <- ifelse(Countriestable  == "United States", "USA", Countriestable) 
#Countriestable
#Countriestable$Countries[Countriestable$Countries == "United States"] <- as.factor("USA")
library(stringr)
library(maps)
library(ggplot2)
library(sf)
library(dplyr)
Map.world<- map_data("world")

write(Map.world$region,"names.txt")

CountriesAvailable<- Map.world %>% group_by(region) %>% summarise() 
setdiff(as.character(Countriestable$Countries), CountriesAvailable$region)

# Recode the Countries Names
Countriestable$Countries <- recode(Countriestable$Countries, "United States" = "USA")
Countriestable$Countries <- recode(Countriestable$Countries, "United Kingdom" = "UK")
Countriestable$Countries <- recode(Countriestable$Countries, "The Republic of Korea" = "South Korea")


library(GADMTools)
library(raster)
library(rgeos)
adm <- getData('GADM', country='Hong Kong', level=0)
class(adm)
# Find a center point for each region
centerHK <- data.frame(gCentroid(adm, byid = TRUE))

adm2<- getData('GADM', country='macao', level=0)

centerBounds <- bounds %>%
  group_by(region) %>%
  summarise(long = mean(long), lat = mean(lat))


library(leaflet)
bounds <- maps::map("world", Countriestable$Countries, fill = TRUE, plot = FALSE)
class(bounds)
map1 <- leaflet() %>%
  addProviderTiles("OpenStreetMap.Mapnik") %>%
  addPolygons(data = bounds, group = "Countries", 
              color = "Blue", 
              weight = 2,
              smoothFactor = 0.2,
              popup = ~names,
              fillOpacity = 0.1,
              highlightOptions = highlightOptions(color = "black", 
                                                  weight = 2,
                                                  bringToFront = TRUE)) %>%
  addPolygons(data=adm, group = "id",
              color = "red", 
              weight = 2,
              smoothFactor = 0.2,
              popup = "Hong Kong",
              fillOpacity = 0.1,
              highlightOptions = highlightOptions(color = "black", 
                                                  weight = 2,
                                                  bringToFront = TRUE)) %>%
  addLabelOnlyMarkers(data = centerHK,
                      lng = ~x, lat = ~y, label = "Hong Kong",
                      labelOptions = labelOptions(noHide = TRUE, textsize = "15px", direction = 'top', textOnly = TRUE)) %>%
  addPolygons(data=adm2, group = "id",
              color = "red", 
              weight = 2,
              smoothFactor = 0.2,
              popup = "Macau",
              fillOpacity = 0.1,
              label = "Macau",
              labelOptions = labelOptions(noHide = T, textsize = "15px",direction = 'top'),
              highlightOptions = highlightOptions(color = "black", 
                                                  weight = 2,
                                                  bringToFront = TRUE))



map1 
getwd()
