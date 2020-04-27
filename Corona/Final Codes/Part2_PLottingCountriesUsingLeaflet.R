install.packages("stringr")
install.packages("maps")
install.packages("ggplot2")
install.packages("sf")
install.packages("dplyr")
install.packages("raster")
install.packages("GADMTools")
install.packages("rgeos")
install.packages("leaflet")

library(stringr)
library(maps)
library(ggplot2)
library(sf)
library(dplyr)
library(raster)

# `map_data` is the function present in `ggplot2`. "Easily turn data from the maps package into a data frame suitable for plotting with `ggplot2`." We are using this to compare the list of countries told by CDC and those present in packcage.  

AllCountries <- map_data("world")

# Lets check the type of AllCountries which will be data.frame
class(AllCountries)

# Lets write AllCountries into a new txt file "NamesOfCountries.txt". It is only for learning how to write columns of a dataframe values as text in a text file. Here we are saving the values from the column `region` of `AllCountries` dataframe. 
write(AllCountries$region,"NamesOfCountries.txt")

# In the following command we will extract the values into an object `CountriesAvailable` for plotting. For that the column `region` of dataframe `AllCountries` will be grouped (`group_by()`). Later the `summarise()` function will summarise the countries/region and make a row for each.
CountriesAvailable<- AllCountries %>% group_by(region) %>% summarise()

# Now we will calculate the differences between the names of countries present in objects `Countriestable` and `CountriesAvailable`. This is due to the differences of names of countries present in real world and coded in packages like in map. For example, USA can be written as United States.  
setdiff(as.character(Countriestable$Countries), CountriesAvailable$region)

# So the countries given on website of CDC.gov is United States but we would require this as USA so that map can be plotted.This is because the name of country in package is USA. There are other countries as well including Macau, The Republic of Korea and United Kingdom which will be required to change as well. Here we are changing the values in Countries column of Countriestable (`Countriestable$Countries`) for USA, UK and South Korea only. Macau and Hong Kong will not be changed due to a reason discussed further. 

# Before
Countriestable$Countries

# Changes reqruied in the names of the countries
Countriestable$Countries <- recode(Countriestable$Countries, "United States" = "USA")
Countriestable$Countries <- recode(Countriestable$Countries, "United Kingdom" = "UK")
# Updated on 19-03-20: Change of Republic of Korea to South Korea
Countriestable$Countries <- recode(Countriestable$Countries, "Republic of Korea" = "South Korea")
#Update
Countriestable$Countries <- recode(Countriestable$Countries, "North Macedonia" = "Macedonia")
Countriestable$Countries <- recode(Countriestable$Countries, "Bosnia" = "Bosnia and Herzegovina")
Countriestable$Countries <- recode(Countriestable$Countries, "Holy See (Vatican City)" = "Vatican")
Countriestable$Countries <- recode(Countriestable$Countries, "Czechia" = "Czech Republic")
# Update Dated 12-03-2020
Countriestable$Countries <- recode(Countriestable$Countries, "Brunei Darussalam" = "Brunei")
#Updated on 19-03-2020
Countriestable$Countries <- recode(Countriestable$Countries, "Eswatini" = "Swaziland")
Countriestable$Countries <- recode(Countriestable$Countries, "Ivory Coast (Côte d'Ivoire)" = "Ivory Coast")
Countriestable$Countries <- recode(Countriestable$Countries, "Congo" = "Democratic Republic of the Congo")

# Deleted the combinations of countries and the duplicated values. Combinations will be added later on appended separately. 
#Updated on 19-03-2020
Countriestable<-Countriestable[!(Countriestable$Countries=="Antigua and Barbuda"),]
Countriestable<-Countriestable[!(Countriestable$Countries=="Democratic Republic of Congo"),]
Countriestable<-Countriestable[!(Countriestable$Countries=="Saint Vincent and the Grenadines"),]
Countriestable <- Countriestable[!(Countriestable$Countries=="Trinidad and Tobago"),]
# Updated on 28-04-2020
Countriestable <- Countriestable[!(Countriestable$Countries=="Saint Kitts and Nevis"),]

#Updated on 19-03-2020
Country_Antigua <- data.frame(Sr.No.=nrow(Countriestable)+1,Countries="Antigua")
Countriestable <-  rbind(Countriestable, Country_Antigua)
Country_Barbuda <- data.frame(Sr.No.=nrow(Countriestable)+1,Countries="Barbuda")
Countriestable <-  rbind(Countriestable, Country_Barbuda)
# Added two new names and deleted their combination
#Updated on 19-03-2020
Country_SaintVincent <- data.frame(Sr.No.=nrow(Countriestable)+1,Countries="Saint Vincent")
Countriestable <-  rbind(Countriestable, Country_SaintVincent)
Country_Grenadines <- data.frame(Sr.No.=nrow(Countriestable)+1,Countries="Grenadines")
Countriestable <-  rbind(Countriestable, Country_Grenadines)
# Added two new names and deleted their combination above
#Updated on 19-03-2020
Country_Trinidad <- data.frame(Sr.No.=nrow(Countriestable)+1,Countries="Trinidad")
Countriestable <-  rbind(Countriestable, Country_Trinidad)
Country_Tobago <- data.frame(Sr.No.=nrow(Countriestable)+1,Countries="Tobago")
Countriestable <-  rbind(Countriestable, Country_Tobago)

# Updated on 25-03-2020
Countriestable$Countries <- recode(Countriestable$Countries, "Cabo Verde" = "Cape Verde")

# Updated on 28-04-2020

Countriestable$Countries <- recode(Countriestable$Countries, "São Tomé and Príncipe" = "Sao Tome and Principe")
Countriestable$Countries <- recode(Countriestable$Countries, "United Republic of Tanzania" = "Tanzania")
Countriestable$Countries <- recode(Countriestable$Countries, "Syrian Arab Republic" = "Syria")
Countriestable$Countries <- recode(Countriestable$Countries, "Republic of Moldova" = "Moldova")
Countriestable$Countries <- recode(Countriestable$Countries, "Russian Federation" = "Russia")
Countriestable$Countries <- recode(Countriestable$Countries, "Lao People's Democratic Republic" = "Laos")
Countriestable$Countries <- recode(Countriestable$Countries, "Viet Nam" = "Vietnam")

# Updated on 28-04-2020: Added two new names after deleting their combination as Saint Kitts and Nevis
Country_SaintKitts <- data.frame(Sr.No.=nrow(Countriestable)+1,Countries="Saint Kitts")
Countriestable <-  rbind(Countriestable, Country_SaintKitts)
Country_Nevis <- data.frame(Sr.No.=nrow(Countriestable)+1,Countries="Nevis")
Countriestable <-  rbind(Countriestable, Country_Nevis)


# After Changes
Countriestable$Countries

# Ok now it is time to let you know that Why we left Hong Kong and Macau. This is because first the Macau is not present in the mapping package but is given on CDC website. So we want to map it by some other package which can map it. Moreover, we want Hong Kong to be mapped using the same package as well. So in summary we want to map the countries using two different ways. One is the `maps` package and other is `GADMTools`.   

library(GADMTools)
library(rgeos)

# Following command will download the simple map (level=0) of Hong Kong from gadm.org. You can see the list of countries at https://gadm.org/maps.html and download the realted maps from dropdown given at https://gadm.org/download_country_v3.html. 
HKMap <- getData('GADM', country='Hong Kong', level=0)
class(HKMap)
# Find a center point for Hong Kong map so that later we can add label in the center of the country upon mapping it. 
centerHK <- data.frame(gCentroid(HKMap, byid = TRUE))

# Similarly, map of makao(given at GADM.org) instead of macau (given at CDC.gov) can be seen at https://gadm.org/maps/MAC.html. 
MACMap <- getData('GADM', country='macao', level=0)
# Find a center point for Macao/u map
centerMAC <- data.frame(gCentroid(MACMap, byid = TRUE))

########## Updated for Gibraltar
GBMap <- getData('GADM', country='Gibraltar', level=0)
class(GBMap)
centerGB <- data.frame(gCentroid(GBMap, byid = TRUE))
centerGB

# Now we have data and maps related to all countries mentioned at CDC.gov which are affected with Coronavirus. We will map these countries using leaflet package. You can see my video about leaflet at https://www.youtube.com/watch?v=oxMOMpL_bys.

library(leaflet)

# Fist we will find the boundries of all the countries given in `Countriestable$Countries`. 
boundries <- maps::map("world", Countriestable$Countries, fill = TRUE, plot = FALSE)
# Lets check type of boundries object.
class(boundries)

# Finally plot all countries. Initiate leaflet()
Map_AffectedCountries <- leaflet() %>%

# Add providerTiles
addProviderTiles("OpenStreetMap.Mapnik") %>%

# Add polygons from boundries object 
addPolygons(data = boundries, group = "Countries", 
              color = "Blue", 
              weight = 2,
              smoothFactor = 0.2,
              popup = ~names,
              fillOpacity = 0.1,
              highlightOptions = highlightOptions(color = "black",
                                                  weight = 2, 
                                                  bringToFront = FALSE)) %>%

# Add polygon data for Hong Kong stored in object HKMap.  
addPolygons(data=HKMap, group = "id",
              color = "red", 
              weight = 2,
              smoothFactor = 0.2,
              popup = "Hong Kong",
              fillOpacity = 0.1,
              highlightOptions = highlightOptions(color = "black", 
                                                  weight = 2,
                                                  bringToFront = FALSE)) %>%
  
# Let's add the label only marker for the name of Hong Kong in center of that country
addLabelOnlyMarkers(data = centerHK, lng = ~x, lat = ~y, 
                    label = "Hong Kong", 
                    labelOptions = labelOptions(noHide = F, 
                                                textsize = "15px", 
                                                direction = 'top', 
                                                textOnly = TRUE))    %>%

# Let's add polygon data for Macao/u stored in object MACMap. 
addPolygons(data=MACMap, group = "id",
              color = "red", 
              weight = 2,
              smoothFactor = 0.2,
              popup = "Macau",
              fillOpacity = 0.1,
              label = "Macau",
              labelOptions = labelOptions(noHide = F, 
                                          textsize = "15px",
                                          direction = 'top'),
              highlightOptions = highlightOptions(color = "black", 
                                                  weight = 2,
                                                  bringToFront = FALSE))



# Generate the leaflet map
Map_AffectedCountries

########## Updated for Guadalupe 
boundryGuadalupe <- maps::map("world", "Mexico:Guadalupe Island", fill = TRUE, plot = FALSE)

Map_AffectedCountries <- Map_AffectedCountries %>%
  addProviderTiles("OpenStreetMap.Mapnik") %>%
  addPolygons(data = boundryGuadalupe, group = "Countries", 
              color = "red", 
              weight = 2,
              smoothFactor = 0.2,
              #popup = ~names,
              fillOpacity = 0.1,
              highlightOptions = highlightOptions(color = "black",
                                                  weight = 2,bringToFront = FALSE)) %>%
  ########## Updated for Gibraltar
  
  addPolygons(data=GBMap,group='id',
              color = "red", 
              weight = 2,
              smoothFactor = 0.2,
              popup = "Gibraltar",
              fillOpacity = 0.1,
              label = "Gibraltar",
              labelOptions = labelOptions(noHide = F, textsize = "15px",                                         direction = 'top'),
              highlightOptions = highlightOptions(color = "black", weight = 2,
                                                  bringToFront = F))
Map_AffectedCountries
