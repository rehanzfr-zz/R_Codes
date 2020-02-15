install.packages("pdftools")
install.packages("timevis")

library(dplyr)
library(timevis)
library(htmltab)
library(pdftools)
library(tidyverse)
library(rvest)
library(leaflet)
library(maps)
library(RCurl)
library(htmltab)
library(mapdata)

url3 <- "https://www.who.int/emergencies/diseases/novel-coronavirus-2019/situation-reports"


###########  PDF Links
page3 <- read_html(url3)%>%
  html_nodes('.sf-content-block') %>%
  html_nodes('a') %>%
  html_attr('href')
xls_links <- page3[str_detect(page3,"([\\w\\d\\-.]+\\.pdf)")]
U_links<- unique(xls_links)
U_links
names <- unlist(str_extract_all(U_links, "([\\w\\d\\-.]+\\.pdf)"))
names

### Situation Reports
page4 <- read_html(url3)%>%
  html_nodes('.sf-content-block') %>%
  html_text() 

SiR <- page4[str_detect(page4,"(Situation report\\s-\\s)[0-9]+")]
U_SIR<- unique(SiR)

SR <- unlist(str_extract_all(U_SIR, "(Situation report\\s-\\s)[0-9]+"))


dates <- page4[str_detect(page4,"(Situation report\\s-\\s)[0-9]+")]
U_Dates<- unique(dates)
U_Dates

dtes <- unlist(str_extract_all(U_Dates, "(\\d+\\s[[:alpha:]]+\\s2020)"))
dtes


SR
dtes
names
U_links
df<- data.frame(cbind(SR,dtes,names,U_links))
df
write.csv(df,"tree.csv")

### Make Directory if not exist
Dir <- "C:/Users/rehan/Documents"
subDir <- "WHOReports"

ifelse(!dir.exists(file.path(Dir, subDir)), 
       dir.create(file.path(Dir, subDir)), FALSE)

####################
### Download Files in the Direcotry
setwd(file.path(Dir,subDir))

files <- list.files(path=file.path(Dir,subDir))
files
filesinDir <- data.frame(files)
names(filesinDir)[1] <- "Files"
typeof(filesinDir$Files)
typeof(df$names)
diff<- data.frame(difference = setdiff(df$names,filesinDir$Files))
df[which(df$names=="20200208-sitrep-19-ncov.pdf"),]

######Downloading all files
for (row in 1:nrow(diff)) {
  #print(diff[row,"difference"])
  li <- df[which(df$names==as.character(diff[row,"difference"])),]
  print(li$U_links)
  print(li$names)
  download.file(paste0("https://www.who.int",li$U_links),as.character(li$names), mode = "wb")
}
#############

######Downloading all files
#for (row in 1:nrow(df)) {
#  #(df[row,"U_links"]) 
#  print(paste0("https://www.who.int",df[row,"U_links"]))
#  print(df[row,"names"])
#  download.file(paste0("https://www.who.int",df[row,"U_links"]),df[row,"names"], # mode = "wb")
#}
#############
## Read Pdf File and extract iformation for dates. 
library(tidytext)
library(dplyr)
library(stringr)
## Read Pdf Files and Save to txt files
getwd()

for (row in 1:nrow(df)) {
#print(file.path(Dir,subDir,df[row,"names"]))
filetoRead <- file.path(Dir,subDir,df[row,"names"])
pdfText <- pdf_text(filetoRead)

Sys.sleep(5)

txt <- pdfText %>%
     str_squish() %>%
     str_replace_all("[\r\n]","") %>%
     str_replace_all("\\.","\r\n") %>%
     str_replace_all("\\;","\r\n")

filetoWrite <- paste0(file.path(Dir,subDir,gsub(pattern = "\\.pdf$", "", df[row,"names"])),".txt")
#print(filetoWrite)
writeLines(txt,filetoWrite)

Sys.sleep(2)
}

##########
# Extracting Dates and Realted Information
##########
dfofDatesandInfo = NULL
for (row in 1:nrow(df)) {
  #print(file.path(Dir,subDir,df[row,"names"]))
  txtfiletoRead <- paste0(file.path(Dir,subDir,gsub(pattern = "\\.pdf$", "", df[row,"names"])),".txt")
  print(txtfiletoRead)
  txt<-read_file(txtfiletoRead)
  Sys.sleep(2)
  SR<- unlist(str_match(txt, "[^\\s\\•\\▪]+\\s([\\d]+\\s[\\w]+\\s\\d{4}),\\s(\\w.+)"))
  SR[,2]
  na.omit(as.Date(SR[,2], "%d %B %Y"))
  SR[,3]
  dfofDatesandInfo = rbind(dfofDatesandInfo, data.frame(start=na.omit(as.Date(SR[,2], "%d %B %Y")),content=na.omit(SR[,3])))
  dfofDatesandInfo
  SR2 <- unlist(str_match(txt, "[O|o]n\\s([\\d]+\\s[\\w]+),\\s(\\w.+)"))
  SR2
  SR2[,2]
  SR2[,3]
  dfofDatesandInfo = rbind(dfofDatesandInfo, data.frame(start=na.omit(as.Date(SR2[,2], "%d %B")),content=na.omit(SR2[,3])))
  SR3 <- unlist(str_match(txt, "As\\sof\\s([\\d]+\\s[\\w]+),\\s(\\w.+)"))
  SR3
  SR3[,2]
  SR3[,3]
  dfofDatesandInfo = rbind(dfofDatesandInfo, data.frame(start=na.omit(as.Date(SR3[,2], "%d %B")),content=na.omit(SR3[,3])))
  SR4 <- unlist(str_match(txt, "On\\s([\\d]+)\\sand\\s([\\d]+)\\s([\\w]+),\\s(\\w.+)"))
  if(!is.na(SR4[,2]) & !is.na(SR4[,4])) {
    date1<- paste0(SR4[,2]," ", SR4[,4])
    dfofDatesandInfo = rbind(dfofDatesandInfo, data.frame(start=na.omit(as.Date(date1, "%d %B")),content=na.omit(SR4[,5])))
  }
  #paste0(na.omit(SR4[,2])," and ",na.omit(SR4[,3]))
  #SR4[,3]
  #na.omit(SR4[,4])
}
dfofDatesandInfo


################
### TimeLine
timevis(dfofDatesandInfo)

###############
### 






