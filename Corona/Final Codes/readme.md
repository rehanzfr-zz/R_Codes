
Different files here represent the codes used in a video series. This video series will cover different geographical, epidemiological, genomic and proteomic analysis. I am doing this series to make myself helpful for our friends in China and any other countries affected by the novel coronavirus (COVID-19).

---

**Part 1**:<br/> 
Web Scraping for Affected Countries by COVID-19 in R with free Source Code <br/>
[https://www.youtube.com/watch?v=ypNCPQDvsU0](https://www.youtube.com/watch?v=ypNCPQDvsU0)<br/>
*Code Available in File* : `Webscraping1_Final.R`

---

## **Part 1** -- Web Scraping for Affected Countries by COVID-19 in R with free Source Code (Webscraping1_Final.R)

This is the URL at which the list of affected countries is given. You can visit the page at [CDC](https://www.cdc.gov/coronavirus/2019-ncov/locations-confirmed-cases.html#map).  

```R
URL <- "https://www.cdc.gov/coronavirus/2019-ncov/locations-confirmed-cases.html#map"
```

**Actual Web Scraping**

In this line we will read the url using 'read_html' function.
```R
PAGE <- read_html(URL) %>%
```

After reading the html we will extract the html object by using the xpath from the original url. You can see video how I copied this xpath (`/html/body/div[6]/main/div[3]/div/div[3]/div/div/ul`).  

```R
html_nodes(xpath="/html/body/div[6]/main/div[3]/div/div[3]/div/div/ul") %>%
```

Now, the map function of purrr package will be used to get the `li` node of html which actually contains all the names of the countries. 

```R
purrr::map(~html_nodes(.x, 'li') %>% 
```

After taking the list we will convert into text form.                  

```R
html_text() %>% 
```

**gsub**  extracts the pattern based on regex. Here I want to change the tabs (`\\t`), new lines (`\\n`) and returns (`\\r`) to nothing (`''`).  

```R
gsub(pattern = '\\t|\\r|\\n', replacement = ''))
```

Now I am saving the list (`PAGE[[1]]`) to `countries`.

```R
countries <- PAGE[[1]]
```

Lets print this object. 

```R
countries
```

List of countries can be Converted to Dataframe. 

```R
countries <- as.data.frame(matrix(unlist(countries),nrow=length(countries),byrow=TRUE))
```

Now I want to change the name of column of dataframe to `Countries`.

```R
names(countries)[1] <- "Countries"
```

Lets add a new column named as (`Sr.No.`) and add the sequence of numbers of series of numbers into it. 

```R
Countriestable <- data.frame(Sr.No.=seq.int(nrow(countries)),countries)
```

Lets print this dataframe.

```R
Countriestable
```

This object will be further used in next part of Video series.  

## **Part 2** -- Make a leaflet plot of Affected Countries by COVID-19 in R with free Source Code (PLottingCountriesUusingLeaflet.R)
In this part, I have made a leaflet plot of affected countries produced as a dataframe in previous part. That dataframe is produced by web scraping the website of CDC.gov. You can see the complete video and description of Part 1 above.

First of all, we will install the required packages. 

```R
install.packages("stringr")
install.packages("maps")
install.packages("ggplot2")
install.packages("sf")
install.packages("dplyr")
install.packages("raster")
install.packages("GADMTools")
install.packages("rgeos")
```

then we will call these libraries.

```R
library(stringr)
library(maps)
library(ggplot2)
library(sf)
library(dplyr)
library(raster)
library(GADMTools)
library(rgeos)
```

`map_data` is the function present in `ggplot2`. "Easily turn data from the maps package into a data frame suitable for plotting with `ggplot2`." We are using this to compare the list of countries told by CDC and those present in packcage.

```R
AllCountries <- map_data("world")
```

Let's check the type of `AllCountries` which will be a dataframe

```R
class(AllCountries)
```

Let's write `AllCountries` into a new txt file "`NamesOfCountries.txt`". It is only for learning how to write columns of a dataframe values as text in a text file. Here, we are saving the values from the column `region` of `AllCountries` dataframe as text in file `NamesOfCountries.txt`. 

```R
write(AllCountries$region,"NamesOfCountries.txt")
```

In the following command we will extract the values into an object `CountriesAvailable` for plotting. For that the column `region` of dataframe `AllCountries` will be grouped (`group_by()`). Later, the `summarise()` function will summarise the countries/region and make a row for each.

```R
CountriesAvailable<- AllCountries %>% group_by(region) %>% summarise()
```

Now we will calculate the differences between the names of countries present in objects `Countriestable` and `CountriesAvailable`. This is due to the differences of names of countries present in real world and coded in packages like in map. For example, USA can be written as United States.  

```R
setdiff(as.character(Countriestable$Countries), CountriesAvailable$region)
```

So the countries given on website of `CDC.gov` is United States but we would require this as USA so that map can be plotted.This is because the name of country in package is USA. There are other countries as well including Macau, The Republic of Korea and United Kingdom which will be required to change as well. Here we are changing the values in Countries column of Countriestable (`Countriestable$Countries`) for USA, UK and South Korea only. Macau and Hong Kong will not be changed due to a reason discussed further.

Before

```R
Countriestable$Countries
```

Changes

```R
Countriestable$Countries <- recode(Countriestable$Countries, "United States" = "USA")
Countriestable$Countries <- recode(Countriestable$Countries, "United Kingdom" = "UK")
Countriestable$Countries <- recode(Countriestable$Countries, "The Republic of Korea" = "South Korea")
```

After Changes

```R
Countriestable$Countries
```

Ok now it is time to let you know that Why we left Hong Kong and Macau. This is because first the Macau is not present in the mapping package but is given on CDC website. So we want to map it by some other package which can map it. Moreover, we want Hong Kong to be mapped using the same package as well. So in summary we want to map the countries using two different ways. One is the `maps` package and other is `GADMTools`.

Following command will download the simple map (level=0) of Hong Kong from gadm.org. You can see the list of countries at [https://gadm.org/maps.html](https://gadm.org/maps.html) and download the realted maps from dropdown given at [https://gadm.org/download_country_v3.html](https://gadm.org/download_country_v3.html).

```R
HKMap <- getData('GADM', country='Hong Kong', level=0)
```

```R
class(HKMap)
```

Find a center point for Hong Kong map so that later we can add label in the center of the country upon mapping it. 

```R
centerHK <- data.frame(gCentroid(HKMap, byid = TRUE))
```

Similarly, map of makao(given at GADM.org) instead of macau (given at CDC.gov) can be seen at [https://gadm.org/maps/MAC.html](https://gadm.org/maps/MAC.html). 

```R
MACMap <- getData('GADM', country='macao', level=0)
```

Find a center point for Macao/u map

```R
centerMAC <- data.frame(gCentroid(MACMap, byid = TRUE))
```

Now, we have data and maps related to all countries mentioned at CDC.gov which are affected with Coronavirus. We will map these countries using leaflet package. You can see my video about leaflet at [https://www.youtube.com/watch?v=oxMOMpL_bys](https://www.youtube.com/watch?v=oxMOMpL_bys).


First, we will find the boundries of all the countries given in `Countriestable$Countries`. 

```R
boundries <- maps::map("world", Countriestable$Countries, fill = TRUE, plot = FALSE)
```

Lets check type of boundries object.

```R
class(boundries)
```

Finally, plot all countries. Initiate leaflet()

```R
Map_AffectedCountries <- leaflet() %>%
```

Add providerTiles

```R
addProviderTiles("OpenStreetMap.Mapnik") %>%
```

Add polygons from boundries object 

```R
addPolygons(data = boundries, group = "Countries", 
              color = "Blue", 
              weight = 2,
              smoothFactor = 0.2,
              popup = ~names,
              fillOpacity = 0.1,
              highlightOptions = highlightOptions(color = "black",
                                                  weight = 2, 
                                                  bringToFront = TRUE)) %>%
```

Add polygon data for Hong Kong stored in object HKMap.  

```R
addPolygons(data=HKMap, group = "id",
              color = "red", 
              weight = 2,
              smoothFactor = 0.2,
              popup = "Hong Kong",
              fillOpacity = 0.1,
              highlightOptions = highlightOptions(color = "black", 
                                                  weight = 2,
                                                  bringToFront = TRUE)) %>%
```  

Let's add the label only marker for the name of Hong Kong in center of that country

```R
addLabelOnlyMarkers(data = centerHK, lng = ~x, lat = ~y, 
                    label = "Hong Kong", 
                    labelOptions = labelOptions(noHide = TRUE, 
                                                textsize = "15px", 
                                                direction = 'top', 
                                                textOnly = TRUE))    %>%

```

Let's add polygon data for Macao/u stored in object MACMap. 

```R
addPolygons(data=MACMap, group = "id",
              color = "red", 
              weight = 2,
              smoothFactor = 0.2,
              popup = "Macau",
              fillOpacity = 0.1,
              label = "Macau",
              labelOptions = labelOptions(noHide = T, 
                                          textsize = "15px",
                                          direction = 'top'),
              highlightOptions = highlightOptions(color = "black", 
                                                  weight = 2,
                                                  bringToFront = TRUE))
```

Generate the leaflet map

```R
Map_AffectedCountries
```

> Note: This readme is generated in hurry and may contain mistakes. If you find any, please suggest. 