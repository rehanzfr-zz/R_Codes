[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/rehanzfr/R_Codes/issues)
[![Fundings welcome](https://img.shields.io/badge/Fundings-welcome-yellow.svg?style=flat)](https://github.com/rehanzfr)
[![Updates](https://img.shields.io/badge/Updated-25--03--2020-green.svg?style=flat)](https://github.com/rehanzfr/R_Codes/tree/master/Corona/Final%20Codes)
[![Language](https://img.shields.io/badge/Language-R-blue.svg?style=flat)](https://www.r-project.org/)

**The information is constantly updating about COVID-19. So the code given in videos is also constantly updated here. Please stay tuned on this page as well after watching the videos. Once, the information will gain stability, the code and related explanation here will also be overhauled accordingly.**



Different files here represent the codes used in a video series. This video series will cover different geographical, epidemiological, genomic and proteomic analysis. I am doing this series to make myself helpful for our friends in China and any other countries affected by the novel coronavirus (COVID-19).

---

**Part 1**:<br/> 
Web Scraping for Affected Countries by COVID-19 in R with free Source Code <br/>
[https://www.youtube.com/watch?v=ypNCPQDvsU0](https://www.youtube.com/watch?v=ypNCPQDvsU0)<br/>
*Code Available in File* : `Part1_CDCWebscraping.R`

**Part 2**:<br/> 
Plot Affected Countries by COVID-19 in R by using leaflet package <br/>
[https://youtu.be/0iM4kcVGVIw](https://youtu.be/0iM4kcVGVIw)<br/>
*Code Available in File* : `Part2_PLottingCountriesUsingLeaflet.R`

**Part 3**:<br/> 
How to Plot Values of Cases of COVID-19 on Interactive MAP in R by using leaflet package. <br/>
[https://youtu.be/a4LXFcEuRUU](https://youtu.be/a4LXFcEuRUU)<br/>
*Code Available in File* : `Part3_PlottingValuesonLeaflet.R`

**Part 4**:<br/> 
Part 4- How to make Animated Plots of COVID-19 Cases in R by using ggplot, ggplotly and plotly. <br/>
[https://youtu.be/AZ0_Zoyv1g4](https://youtu.be/AZ0_Zoyv1g4)<br/>
*Code Available in File* : `Part4_Timeseries.R`

**Part 5 | Chapter 1**:<br/> 
Part 5 - Dashboard for COVID-19 cases in R by using Flexdashboard and Shiny. (Ch#1 Layout Design) <br/>
[https://youtu.be/hcquBsMdjhU](https://youtu.be/hcquBsMdjhU)<br/>
*Code Available in File* : `SimpleLayout(Part5Chapter1).Rmd` in folder `Flexdashboard`

**Part 5 | Chapter 2**:<br/> 
Part 5 - Dashboard for COVID-19 cases in R by using Flexdashboard and Shiny. (Ch#2 Data Generation) <br/>
[https://youtu.be/7PiaXpBb-Mw](https://youtu.be/7PiaXpBb-Mw)<br/>
*Code Available in File* : `DataGenerationforDashboard(Part5Chapter2).R` in folder `Flexdashboard`
---
---

## **Part 1** -- Web Scraping for Affected Countries by COVID-19 in R with free Source Code (Part1_CDCWebscraping.R)

This is the URL at which the list of affected countries is given. You can visit the page at [CDC](https://www.cdc.gov/coronavirus/2019-ncov/locations-confirmed-cases.html#map). Youtube video is at [https://www.youtube.com/watch?v=ypNCPQDvsU0](https://www.youtube.com/watch?v=ypNCPQDvsU0).

> Updated on 19-03-2020: The url is changed from `https://www.cdc.gov/coronavirus/2019-ncov/locations-confirmed-cases.html#map` to
`https://www.cdc.gov/coronavirus/2019-ncov/cases-updates/world-map.html` to accomodate changes according to the changes in CDC website.



```R
# Previously as in video:
# URL <- "https://www.cdc.gov/coronavirus/2019-ncov/locations-confirmed-cases.html#map"
# Updated on 19-03-2020
URL <- "https://www.cdc.gov/coronavirus/2019-ncov/cases-updates/world-map.html"
```

**Actual Web Scraping**

In this line we will read the url using 'read_html' function.
```R
PAGE <- read_html(URL) %>%
```

After reading the html we will extract the html object by using the xpath from the original url. You can see video how I copied this xpath (`/html/body/div[6]/main/div[3]/div/div[3]/div/div/ul`).

> UPDATE ON THIS LINE OF CODE (*Dated: 07-March-2020*):
 
The video contains the xpath to previous version of CDC website. Previously that `xpath` was `/html/body/div[6]/main/div[3]/div/div[3]/div/div/ul` which can be seen in the video and in above lines but after the CDC has updated the website along with the list of affected countries, We now have to change the xpath in our code too. The new xpath is now `/html/body/div[6]/main/div[3]/div/div[3]/div[2]` that is updated below as well:  

> UPDATE ON THIS LINE OF CODE (Dated: 25/03/2020)
Now the xpath is again changed to `/html/body/div[7]/main/div[3]/div/div[3]/div[2]` so instead of previous one `/html/body/div[6]/main/div[3]/div/div[3]/div[2]`, we will use new one. 

```R
html_nodes(xpath="/html/body/div[7]/main/div[3]/div/div[3]/div[2]") %>%
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

---
---

## **Part 2** -- Plot Affected Countries by COVID-19 in R by using leaflet package (Part2_PLottingCountriesUsingLeaflet.R)
In this part, I have made a leaflet plot of affected countries produced as a dataframe in previous part. That dataframe is produced by web scraping the website of CDC.gov. You can see the complete video and description of Part 1 above. Youtube video is at [https://youtu.be/0iM4kcVGVIw](https://youtu.be/0iM4kcVGVIw)

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
> UPDATE (*Dated: 10-March-2020*):
> Setdiff is showing these countries:
```R
[1] "Guadalupe"               "United States"           "Czechia"                 "Gibraltar"              
 [5] "Holy See (Vatican City)" "North Macedonia"         "United Kingdom"          "Hong Kong"              
 [9] "Macau"                   "Republic of Korea"
```
So we have to change some names including that of United states to USA, United Kingdom to UK, The Republic of Korea to South Korea, North Macedonia to Macedonia, Bosnia to Bosnia and Herzegovina, Czechia to Czech Republic, Holy See (Vatican City) to Vetican and Brunei Darussalam to Brunei. This is becuase the names in map data requrie this adjustment.

> Updated on *19-March-2020*: The names of several countries or regions were defined combined. So they were first deleted from the dataframe and then these were appended seprately. Moreover, one country was defined two times on CDC by their different names such as `Congo` and `Democratic Republic of Congo`. So the later one is deleted where former is changed to `Democratic Republic of the Congo`. Now where you will see the Updated on 19-03-2020 so these are updated at this date after the video. 

> Updated on *25-March-2020*
> Setdiff is showing these countries

```R
[1] "Cabo Verde"                       "Congo"                           
 [3] "Eswatini"                         "Democratic Republic of Congo"    
 [5] "Ivory Coast (Côte d’Ivoire)"      "Antigua and Barbuda"             
 [7] "Guadalupe"                        "Saint Vincent and the Grenadines"
 [9] "Trinidad and Tobago"              "United States"                   
[11] "Czechia"                          "Gibraltar"                       
[13] "Holy See (Vatican City)"          "North Macedonia"                 
[15] "United Kingdom"                   "Brunei Darussalam"               
[17] "Hong Kong"                        "Macau"                           
[19] "Republic of Korea"               
```
among which only `Cabo Verde` that is also known as `Cape Verde` is not updated in this code until this date. `Cape Verde` is actually present in the package for mapping So we will change the name in the following code.  

Before

```R
Countriestable$Countries
```

Changes



```R
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
Countriestable$Countries <- recode(Countriestable$Countries, "Ivory Coast (Côte d’Ivoire)" = "Ivory Coast")
Countriestable$Countries <- recode(Countriestable$Countries, "Congo" = "Democratic Republic of the Congo")

# Deleted the combinations of countries and the duplicated values. Combinations will be added later on appended separately. 
#Updated on 19-03-2020
Countriestable<-Countriestable[!(Countriestable$Countries=="Antigua and Barbuda"),]
Countriestable<-Countriestable[!(Countriestable$Countries=="Democratic Republic of Congo"),]
Countriestable<-Countriestable[!(Countriestable$Countries=="Saint Vincent and the Grenadines"),]
Countriestable <- Countriestable[!(Countriestable$Countries=="Trinidad and Tobago"),]
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

> UPDATE ON THESE LINES OF CODE (*Dated: 10-March-2020*):

Similarly, gibraltar is the country which is not present in the map data. So we will also get the map of this region from GADM. 

```R
########## Updated for Gibraltar
GBMap <- getData('GADM', country='Gibraltar', level=0)
class(GBMap)
centerGB <- data.frame(gCentroid(GBMap, byid = TRUE))
centerGB


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

> UPDATE ON THESE LINES OF CODE (*Dated: 10-March-2020*):

Now, we will add the recently affected region of Guadalupe and Gibraltar

```R
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
```

---
---

## **Part 3** -- How to Plot Values of Cases of COVID-19 on Interactive MAP in R by using leaflet package (Part3_PlottingValuesonLeaflet.R)

Youtube video is at [https://youtu.be/a4LXFcEuRUU](https://youtu.be/a4LXFcEuRUU)

Install Libraries
```R
install.packages("readr")
install.packages("knitr") 
install.packages("RCurl")
install.packages("htmlwidgets")
install.packages("htmltools")
```

Call Libraries

```R
library(readr)
library(knitr) 
library(RCurl)
library(htmlwidgets)
library(htmltools)
```

For the time series data (means the status of confirmed cases, deaths and recovered cases day wise) we will go the link of github i.e. [https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_time_series](https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_time_series). This data has been provided by Johns Hopkins CSSEJHU CSSE [https://systems.jhu.edu/research/public-health/ncov/](https://systems.jhu.edu/research/public-health/ncov/). For more information, please visit [https://github.com/CSSEGISandData/COVID-19](https://github.com/CSSEGISandData/COVID-19). 

Now on the page [https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_time_series](https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_time_series), you can see three categories i.e. [time_series_19-covid-Confirmed.csv](https://github.com/CSSEGISandData/COVID-19/blob/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv), [time_series_19-covid-Deaths.csv](https://github.com/CSSEGISandData/COVID-19/blob/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Deaths.csv), [time_series_19-covid-Recovered.csv](https://github.com/CSSEGISandData/COVID-19/blob/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Recovered.csv). These CSV files (CSV is the extension of files) can be opened on github but are not suitable for fetching data in python or R. So click each link to the files and go the `raw` button. This will open a new page. Copy the links to each raw data of these files and paste somewhere with you. The links to the raw data looks like:

> Update (Dated: *25-03-2020*)
> The data files currently in use below are deprecated. The new files on the same github repo are changed. Following message can be seen on [https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_time_series](https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_time_series)
> *---DEPRICATED WARNING---
The files below will no longer be updated. With the release of the new data structure, we are updating our time series tables to reflect these changes. Please reference time_series_covid19_confirmed_global.csv and time_series_covid19_deaths_global.csv for the latest time series data.*


```R
# Confirmed Cases
# Old Link https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv
# Updated link (25-03-2020)
https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv
# Deaths
# Deprecated old link: https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Deaths.csv
# Updated link (25-03-2020)
https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv

# Recovered Cases
# Deprecated old link: https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Recovered.csv
# Updated link (25-03-2020)
# It is still not available and last three rows are showing something recovered in above links which may be due to any problem in data transformation. Issue has been submitted on github #1519.


```

If you observer then there is a common path in all these links which is ` https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/`. So first of all grab it  as `Main`:

```R
Main <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series"
```

Here, `file.path` is used to join the `Main` with names of the CSV files in each case. It is just like adding ` https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/` with `time_series_19-covid-Confirmed.csv` to make `https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv`

```R
# Updated on 25-03-2020
# confirmed <-  file.path(Main,"time_series_19-covid-Confirmed.csv")
confirmed <-  file.path(Main,"time_series_covid19_confirmed_global.csv")
# 
confirmed
# Updated on 25-03-2020
# Deaths <- file.path(Main,"time_series_19-covid-Deaths.csv")
Deaths <- file.path(Main,"time_series_covid19_deaths_global.csv")
Deaths
# Updated on 25-03-2020
# The updated file on the recovered data is still awaited, for tutorial we are taking the deprecated file which will be updated later.
Recoverd<- file.path(Main,"time_series_19-covid-Recovered.csv")
Recoverd
```

In the following code, we will read the data present in CSVs by using their links made above:

```R
ConfirmedData <- read.csv(confirmed)
DeathData <- read.csv(Deaths)
RecoveredData <-  read.csv(Recoverd)
```

`DateColumn` represents which column or date we are interested in for plotting. At the time of video, the latest date in all the CSVs was `X29.2.20` (*This has been updated: See below*).  You can check the last column heading of all CSVs to get the current and latest date for which the values have been reported. After it, the `cleanDateColumn` is saving `2.29.20` by removing `X` in the initial. `gsub` is used to do that kind of stuff. This cleanDateColumn will be further used in labeling but fetching of the data will be done using `DateColumn` object.

> UPDATED on *19-03-2020* for getting the last column header of the `ConfirmedData` automatically to stay updated. Rest of the code will remain same. 
> 
```R
# Previous One
# DateColumn<- "X2.29.20"
# UPDATED on 19-03-2020 for getting the last column header of the ConfirmedData automatically to stay updated. Rest of the code will remain same. 
DateColumn <- colnames(ConfirmedData)[ncol(ConfirmedData)]
cleanDateColumn <- gsub('X','',DateColumn)
```

In the following code, different popups for Confirmed, Deaths and Recovered Cases are designed to be shown on the map. These popups will popup when we click the circles used for showing the number of cases in each category. For example, `popupConfirmed` is an html syntax used in R to make a popup. This html looks like `<strong>County: </strong> US <br><strong>Province/State: </strong> Snohomish County, WA <br><strong>Confirmed: </strong> 1`. If you copy this code in html editor than you can find its format. I have shown it in video. Similarly, `popupdeath` is used to define the popup when deaths are shown in circles and `popupRecovered` show the recovered cases.  

```R
popupConfirmed <- paste("
                        <strong>County: </strong>", 
                        ConfirmedData$Country.Region, 
                        "<br><strong>Province/State: </strong>", 
                        ConfirmedData$Province.State, 
                        "<br><strong>Confirmed: </strong>", 
                        ConfirmedData[,DateColumn]
                        )

popupdeath <- paste("
                    <strong>County: </strong>", 
                    DeathData$Country.Region, 
                    "<br><strong>Province/State: </strong>", 
                    DeathData$Province.State, 
                    "<br><strong>Deaths: </strong>", 
                    DeathData[,DateColumn] 
                    )

popupRecovered <- paste("
                        <strong>County: </strong>", 
                        RecoveredData$Country.Region, 
                        "<br><strong>Province/State: </strong>", 
                        RecoveredData$Province.State, 
                        "<br><strong>Recovered: </strong>", 
                        RecoveredData[,DateColumn]
                        )

```
The code above will look like this. **Do not copy as this is not the part of actual coding.**

```html
<strong>County: </strong> US <br><strong>Province/State: </strong> Snohomish County, WA <br><strong>Confirmed: </strong> 1

<strong>County: </strong> US <br><strong>Province/State: </strong> Snohomish County, WA <br><strong>Deaths: </strong> 0

<strong>County: </strong> US <br><strong>Province/State: </strong> Snohomish County, WA <br><strong>Recovered: </strong> 0
```

In the following code, different Color Pallets for Confirmed, Deaths and Recovered Cases are devised. Here `colorBin` is used to devise the range of values in each category with different levels of colors. I mean light color for less and strong color for more cases. Moreover, three different categories are represented with three different colors. aahh, you are welcome my sweet beginners. 

```R
palConfirmed <- colorBin(palette = "GnBu", domain = ConfirmedData[,DateColumn] , bins = 3 , reverse = FALSE)

paldeath     <- colorBin(palette = "OrRd", domain = DeathData[,DateColumn]     , bins = 3 , reverse = FALSE)

palrecovered <- colorBin(palette = "BuGn", domain = RecoveredData[,DateColumn] , bins = 3 ,  reverse = FALSE)
```

Now, we want to add text on the map which represent Title, Subtitle and number of cases. For this we will use CSS styles  for each. 
What is CSS? You are right. I will make a video on it separately or search YouTube for now.

```R
title <- tags$style(HTML("
                         .map-title {
                         font-family: 'Cool Linked Font', fantasy; 
                         transform: translate(-10%,20%); 
                         position: fixed !important; 
                         left: 10%; 
                         text-align: left; 
                         padding-left: 10px; 
                         padding-right: 10px; 
                         background: rgba(255,255,255,0.75); 
                         font-weight: bold; 
                         font-size: 25px}")
                        )


subtitle <- tags$style(HTML("
                            .map-subtitle {
                            transform: translate(-10%,150%);
                            position: fixed !important;
                            left: 10%;
                            text-align: left;
                            padding-left: 10px;
                            padding-right: 10px;
                            font-size: 18px}")
                            )

CasesLabel<- tags$style(HTML("
                             .cases-label{
                             position: absolute; 
                             bottom: 8px; 
                             left: 16px; 
                             font-size: 18px}")
                            )
```

Here we will write what we want to show as Title, Subtitle and Cases in HTML format over Map. As you remember from above, `DateColumn` has a value of `X29.2.20` that is the column header of the last/latest column at the time of coding this code. Now, if I want to extract the values of that column from data object of confirmed cases that is `ConfirmedData` then I have to issue  `ConfirmedData[,DateColumn]` which means get the values of column with header `X29.2.20` from data file `ConfirmedData`. Please remember the place of comma. Before it are rows and after it are columns. 

```R
leaflettitle <- tags$div(title, HTML("Status of COVID-19"))  

leafletsubtitle <- tags$div(subtitle, HTML("YouTube: Dr Rehan Zafar"))  

CasesLabelonMap <- tags$div(CasesLabel, HTML(paste(
  "<strong>Date: </strong>", 
  cleanDateColumn, 
  "<strong>Confirmed: </strong>",
  sum(as.numeric(ConfirmedData[,DateColumn])), 
  "<strong>Deaths: </strong>",
  sum(as.numeric(DeathData[,DateColumn])),
  "<strong>Recovered: </strong>",
  sum(as.numeric(RecoveredData[,DateColumn]))))
                          )
```

The code above will look like this and if you copy this and paste in HTML editor, you can see the format. **Do not copy as this is not the part of actual coding.**

```html
<div>
  <style>.map-title {font-family: 'Cool Linked Font', fantasy; transform: translate(-10%,20%); position: fixed !important; left: 10%; text-align: left; padding-left: 10px; padding-right: 10px; background: rgba(255,255,255,0.75); font-weight: bold; font-size: 25px}</style>
  Status of COVID-19
</div>


<div>
  <style>.map-subtitle {transform: translate(-10%,150%);position: fixed !important;left: 10%;text-align: left;padding-left: 10px;padding-right: 10px;font-size: 18px}</style>
  YouTube: Dr Rehan Zafar
</div>


<div>
  <style>.cases-label{position: absolute; bottom: 8px; left: 16px; font-size: 18px}</style>
  <strong>Date: </strong> 2.29.20 <strong>Confirmed: </strong> 86013 <strong>Deaths: </strong> 2941 <strong>Recovered: </strong> 39782
</div>
```

Now, we will add the information back into the leaflet map. For this we will use the object of `Map_AffectedCountries` which was used to make the map in previous part. 

```R
Mapwithvalues <- Map_AffectedCountries %>% 
```

In the following code we will plot Confirmed cases and add the legend for it along with the control to show or hide this data. 

```R
addCircleMarkers(data= ConfirmedData, 
                 lng = ~Long, 
                 lat = ~Lat, 
                 radius = ~log(ConfirmedData[,DateColumn])*5, 
                 stroke = FALSE, 
                 fillOpacity = 1, 
                 popup = popupConfirmed, 
                 color = ~palConfirmed(ConfirmedData[,DateColumn]), 
                 group = "Circles(Confirmed)") %>%

  
addLabelOnlyMarkers(data= ConfirmedData, 
                      lng = ~Long, 
                      lat = ~Lat, 
                      label  = ~as.character(ConfirmedData[,DateColumn]), 
                      group="Values(Confirmed)", 
                      labelOptions = labelOptions(noHide = T, 
                                                  direction = 'center', 
                                                  textOnly = T, 
                                                  style=list('color'='blue', 
                                                             'font-family'= 'sans',
                                                             'font-style'= 'bold', 
                                                             'font-size' = '20px', 
                                                             'border-color' = 'rgba(0,0,0,0.5)'))) %>%
  
addLegend("bottomright", 
          pal = palConfirmed, 
          values = ConfirmedData[,DateColumn], 
          title = "Confirmed", 
          opacity = 1) %>%
```

In the following code we will plot Recovered cases and add the legend for it along with the control to show or hide this data.

```R
addCircleMarkers(data= RecoveredData, 
                 lng = ~Long, 
                 lat = ~Lat, 
                 radius = ~log(X2.27.20)*5, 
                 stroke = FALSE, 
                 fillOpacity = 1, 
                 popup = popupRecovered, 
                 color = ~palrecovered(RecoveredData$X2.27.20), 
                 group = "Circles(Recovered)") %>%

  
addLabelOnlyMarkers(data= RecoveredData, 
                    lng = ~Long, 
                    lat = ~Lat, 
                    label  = ~as.character(RecoveredData[,DateColumn]), 
                    group="Values(Recovered)", 
                    labelOptions = labelOptions(noHide = T, 
                                                direction = 'center', 
                                                textOnly = T, 
                                                style=list('color'='green', 
                                                           'font-family'= 'sans', 
                                                           'font-style'= 'bold', 
                                                           'font-size' = '20px',
                                                           'border-color' = 'rgba(0,0,0,0.5)'))) %>%
  
addLegend("bottomright", 
          pal = palrecovered, 
          values = RecoveredData[,DateColumn], 
          title = "Recovered", 
          opacity = 1) %>%
```

In the following code we will plot Deaths and add the legend for it along with the control to show or hide this data.

```R
addCircleMarkers(data= DeathData, 
                 lng = ~Long, 
                 lat = ~Lat, 
                 radius = ~log(DeathData[,DateColumn])*5, 
                 stroke = FALSE, 
                 fillOpacity = 1, 
                 popup = popupdeath, 
                 color = ~paldeath(DeathData[,DateColumn]), 
                 group = "Circles(Death)") %>%
  
addLabelOnlyMarkers(data= DeathData, 
                      lng = ~Long, 
                      lat = ~Lat, 
                      label  = ~as.character(DeathData[,DateColumn]), 
                      group="Values(Death)", 
                      labelOptions = labelOptions(noHide = T, 
                                                  direction = 'center', 
                                                  textOnly = T, 
                                                  style=list('color'='red', 
                                                             'font-family'= 'sans', 
                                                             'font-style'= 'bold',
                                                             'font-size' = '20px',
                                                             'border-color' = 'rgba(0,0,0,0.5)'))) %>%
  
  
addLegend("bottomright", 
          pal=paldeath, 
          values=DeathData[,DateColumn], 
          title = "Deaths", 
          opacity = 1) %>%
```

In the following code, we are actually showing the check boxes for showing or hiding the circles and values for cases. 

```R
addLayersControl(overlayGroups = c("Circles(Confirmed)","Values(Confirmed)" ,"Circles(Recovered)","Values(Recovered)", "Circles(Death)","Values(Death)"), options = layersControlOptions(collapsed = FALSE)) %>%
```

In the following code, we will add title, subtitle, and number of cases over the map.

```R
addControl(leaflettitle, position = "topleft", className="map-title") %>%
    
addControl(leafletsubtitle, position = "topleft", className="map-subtitle") %>%
  
addControl(CasesLabelonMap, position = "bottomleft", className="cases-label")
```

Show the map

```R
Mapwithvalues
```

Save this map as html file for presenting it later. 

```R
saveWidget(Mapwithvalues, file="map1.html", selfcontained=FALSE)
```

You can search the path where it is stored by `getwd()` or `setwd()` before saving. 


---
---

## **Part 4** -- How to make Animated Plots of COVID-19 Cases in R by using ggplot, ggplotly and plotly (Part4_Timeseries.R)

Link of the video is [https://youtu.be/AZ0_Zoyv1g4](https://youtu.be/AZ0_Zoyv1g4). The description of the code is either in comments or will be updated here after a short interval.



---
Shield: [![CC BY 4.0][cc-by-shield]][cc-by]

This work is licensed under a [Creative Commons Attribution 4.0 International
License][cc-by].

[![CC BY 4.0][cc-by-image]][cc-by]

[cc-by]: http://creativecommons.org/licenses/by/4.0/
[cc-by-image]: https://i.creativecommons.org/l/by/4.0/88x31.png
[cc-by-shield]: https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg

> Note: This readme is generated in hurry and may contain mistakes. If you find any, please suggest. 
