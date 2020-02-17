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

# Convert to Dataframe
countries <- as.data.frame(matrix(unlist(countries),nrow=length(countries),byrow=TRUE))
names(countries)[1] <- "Countries"
Countriestable <- data.frame(Sr.No.=seq.int(nrow(countries)),countries)
Countriestable


########### Part2
# Install the requried packages
install.packages("ggplot2")
install.packages("GADMTools")
install.packages("raster")

# Call the libraries
library(ggplot2)
library(GADMTools)
library(raster)

# Download the map of Hong Kong from GADM.org using this command. Here level 0 is the most simple form of map.
# GADM provides maps and spatial data for all countries and their sub-divisions. You can browse our maps or download the data to make your own maps.
HKmap <- getData('GADM', country='Hong Kong', level=0)
# What is the type of HKmap?
class(HKmap)

# Similarly download the map of MACAO from GADM.org. 
MACAOmap<- getData('GADM', country='macao', level=0)

# fortify of ggplot2 (ggplot2::fortify) converts "sp/SpatialPolygonsDataFrame" object to data.frame
df_HKmap = ggplot2::fortify(HKmap) 
df_MACAOmap = ggplot2::fortify(MACAOmap)

boundforggplot<- map_data("world", region = Countriestable$Countries)

# Compute the centroid as the mean longitude and lattitude
# Used as label coordinate for country's names
regionLabels <- boundforggplot %>%
  group_by(region) %>%
  summarise(long = mean(long), lat = mean(lat))

regionLabelsHK <- hkmapdf %>%
  group_by(id) %>%
  summarise(long = mean(long), lat = mean(lat))

regionLabelsMacau <- hkmapdf2 %>%
  group_by(id) %>%
  summarise(long = mean(long), lat = mean(lat))

ggplot(boundforggplot, aes(x = long, y = lat)) +
  geom_polygon(aes( group = group, fill = region))+
  geom_polygon(data=hkmapdf,aes(x = long, y = lat, group = group), fill="blue", colour="gray") +
  geom_polygon(data=hkmapdf2, fill="red", colour="gray") +
  geom_text(aes(label = region), data = regionLabels,  size = 3, hjust = 0.5)+
  geom_text(aes(label = "HK"), data = regionLabelsHK,  size = 3, hjust = 0.5)+
  geom_text(aes(label = "Macau"), data = regionLabelsMacau,  size = 3, hjust = 0.5)+
  scale_fill_viridis_d()+
  annotate(geom = 'text'
           ,label = 'Source: U.S. Energy Information Administration\nhttps://en.wikipedia.org/wiki/List_of_countries_by_oil_production'
           ,x = 18, y = -55
           ,size = 3
           ,family = 'Gill Sans'
           ,color = '#CCCCCC'
           ,hjust = 'left'
  )+
  theme(text = element_text(family = 'Gill Sans', color = '#EEEEEE')
        ,plot.title = element_text(size = 28)
        ,plot.subtitle = element_text(size = 14)
        ,axis.ticks = element_blank()
        ,axis.text = element_blank()
        ,panel.grid = element_blank()
        ,panel.background = element_rect(fill = '#333333')
        ,plot.background = element_rect(fill = '#333333')
        ,legend.position = c(.18,.36)
        ,legend.background = element_blank()
        ,legend.key = element_blank()
  )+
  guides(fill = guide_legend(reverse = T)) +
  labs(fill = 'bbl/day'
       ,title = 'Oil Production by Country'
       ,subtitle = 'Barrels per day, 2016'
       ,x = NULL
       ,y = NULL) 



ggplot(hkmapdf, aes(x = long, y = lat, group = group)) +
  geom_polygon(fill="blue", colour="gray") +
  geom_polygon(data=hkmapdf2, fill="red", colour="gray")


ggplot(world_map, aes(x = long, y = lat, group = group)) +
  geom_polygon(fill="gray", colour="gray") +
  geom_polygon(data=hkmapdf,aes(x = long, y = lat, group = group), fill="blue", colour="gray") +
  geom_polygon(data=hkmapdf2, fill="red", colour="gray") +
  geom_polygon(data=bounds, fill="red", colour="gray")




world_map <- map_data("world")
some.eu.countries <- c(
  "Portugal", "Spain", "France", "Switzerland", "Germany",
  "Austria", "Belgium", "UK", "Netherlands",
  "Denmark", "Poland", "Italy", 
  "Croatia", "Slovenia", "Hungary", "Slovakia",
  "Czech republic","Hong Kong"
)
some.eu.maps <- map_data("world", region = some.eu.countries)
region.lab.data <- some.eu.maps %>%
  group_by(region) %>%
  summarise(long = mean(long), lat = mean(lat))


ggplot(some.eu.maps, aes(x = long, y = lat)) +
  geom_polygon(aes( group = group, fill = region))+
  geom_text(aes(label = region), data = region.lab.data,  size = 3, hjust = 0.5)+
  scale_fill_viridis_d()+
  theme_void()+
  theme(legend.position = "none")

ggsave("map.pdf")
ggsave("map_web.png", width = 6, height = 6, dpi = "screen")


getwd()



library(leaflet)

hkmapdf %>% leaflet() %>% addTiles()
bounds <- maps::map("world", adm, fill = TRUE, plot = FALSE)
map1 <- hkmapdf %>% leaflet() %>%
  addProviderTiles("OpenStreetMap.Mapnik") %>%
  addPolygons(lat = ~lat,lng=~long, group = ~id, 
              color = "red", 
              weight = 2,
              popup = hkmapdf$id,
              fillOpacity = 0.1,
              highlightOptions = highlightOptions(color = "black", 
                                                  weight = 2,
                                                  bringToFront = TRUE))
map1

library(sf)
ggplot(data=hkmapdf)+geom_sf()
ggplot(hkmapdf, aes( x = long, y = lat, group = group)) +
  geom_polygon(aes(fill="red")) +
  scale_color_manual(values = c('1' = 'red', '0' = NA)) 
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("World map", subtitle = paste0("(", length(unique(world$NAME)), " countries)"))



mar<-(adm[adm$NAME_1=="Marinduque",])
plot(adm, bg="dodgerblue", axes=T)
##Plot downloaded data
plot(mar, lwd=10, border="skyblue", add=T)
plot(mar,col="green4", add=T)
grid()
box()
invisible(text(getSpPPolygonsLabptSlots(mar), labels=as.character(mar$NAME_2), cex=1.1, col="white", font=2))
mtext(side=3, line=1, "Provincial Map of Marinduque", cex=2)
mtext(side=1, "Longitude", line=2.5, cex=1.1)
mtext(side=2, "Latitude", line=2.5, cex=1.1)
text(122.08,13.22, "Projection: Geographic\nCoordinate System: WGS 1984\nData Source: GADM.org\nCreated by: ARSsalvacion", adj=c(0,0), cex=0.7, col="grey20")
