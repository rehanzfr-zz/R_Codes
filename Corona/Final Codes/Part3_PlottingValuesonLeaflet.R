#########################################                        
# Part 3
#########################################

# Install Libraries
install.packages("readr")
install.packages("knitr") 
install.packages("RCurl")
install.packages("htmlwidgets")
install.packages("htmltools")

# Call Libraries
library(readr)
library(knitr) 
library(RCurl)
library(htmlwidgets)
library(htmltools)
#------------------------------------------
# Copy the raw path of CSVs

Main <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series"
confirmed <-  file.path(Main,"time_series_19-covid-Confirmed.csv")
confirmed
Deaths <- file.path(Main,"time_series_19-covid-Deaths.csv")
Deaths
Recoverd<- file.path(Main,"time_series_19-covid-Recovered.csv")
Recoverd
ConfirmedData <- read.csv(confirmed)
DeathData <- read.csv(Deaths)
RecoveredData <-  read.csv(Recoverd)


#------------------------------------------
# DateColumn represents which column or date we are interested in for plotting. 
# Previous One
#DateColumn<- "X2.29.20"
# UPDATED on 19-03-2020 for getting the last column header of the ConfirmedData automatically to stay updated. Rest of the code will remain same. 
DateColumn <- colnames(ConfirmedData)[ncol(ConfirmedData)]
cleanDateColumn <- gsub('X','',DateColumn)
#------------------------------------------
# Different popups for Confirmed, Deaths and Recovered Cases. These popups will popup when we click the circles.

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

#------------------------------------------
# Different Color Pallets for Confirmed, Deaths and Recovered Cases

palConfirmed <- colorBin(palette = "GnBu", domain = ConfirmedData[,DateColumn] , bins = 3 , reverse = FALSE)

paldeath     <- colorBin(palette = "OrRd", domain = DeathData[,DateColumn]     , bins = 3 , reverse = FALSE)

palrecovered <- colorBin(palette = "BuGn", domain = RecoveredData[,DateColumn] , bins = 3 ,  reverse = FALSE)

#------------------------------------------
# We want to add text on the map which represent Title, Subtitle and number of cases. For this we will use CSS styles and HTML. 

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
#------------------------------------------
# Here we will write what we want to show as Title, Subtitle and Cases in HTML format over Map. 


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
CasesLabelonMap
#------------------------------------------
# Now we will add the information back into the leaflet map. For this we will use the object of `Map_AffectedCountries` which was used to make the map in previous part. 



Mapwithvalues <- Map_AffectedCountries %>% 
    
#------------------
# In the following code we will plot Confirmed cases and add the legend for it along with the control to show or hide this data. 

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
  

#------------------
# In the following code we will plot Recovered cases and add the legend for it along with the control to show or hide this data.

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
  
#------------------
# In the following code we will plot Deaths and add the legend for it along with the control to show or hide this data.

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
  
#------------------
# In the following code, we are actually showing the check boxes for showing or hiding the circles and values for cases. 

addLayersControl(overlayGroups = c("Circles(Confirmed)","Values(Confirmed)" ,"Circles(Recovered)","Values(Recovered)", "Circles(Death)","Values(Death)"), options = layersControlOptions(collapsed = FALSE)) %>%

  
#------------------
# In the following code, we will add title, subtitle, and number of cases over the map.

addControl(leaflettitle, position = "topleft", className="map-title") %>%
    
addControl(leafletsubtitle, position = "topleft", className="map-subtitle") %>%
  
addControl(CasesLabelonMap, position = "bottomleft", className="cases-label")

#------------------------------------------
# Show the map 
Mapwithvalues

#------------------------------------------
# Save this map as html file for presenting it later
saveWidget(Mapwithvalues, file="map1.html", selfcontained=FALSE)
  
  
  
  































