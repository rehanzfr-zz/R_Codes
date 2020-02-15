install.packages("tabulizer")
library(tidytext)
library(tabulizer)
library(dplyr)
library(stringr)
## Read Pdf File
getwd()
txt <- pdf_text("C:/Users/rehan/Documents/WHOReports/20200124-sitrep-4-2019-ncov.pdf")
txt <- txt %>%
  str_squish() %>%
  str_replace_all("[\r\n]","") %>%
  str_replace_all("\\.","\r\n") %>%
  str_replace_all("\\;","\r\n")

txt

writeLines(txt,"outfile.txt")
SR<- unlist(str_match(txt, "[^\\s\\.\\???]+\\s([\\d]+\\s[\\w]+\\s\\d{4}),\\s(\\w.+)"))
SR[,2]
SR[,3]
SR2 <- unlist(str_match(txt, "[O|o]n\\s([\\d]+\\s[\\w]+),\\s(\\w.+)"))
SR2
SR2[,2]
SR2[,3]
SR3 <- unlist(str_match(txt, "As\\sof\\s([\\d]+\\s[\\w]+),\\s(\\w.+)"))
SR3
SR3[,2]
SR3[,3]
SR4 <- unlist(str_match(txt, "On\\s([\\d]+)\\sand\\s([\\d]+)\\s([\\w]+),\\s(\\w.+)"))
paste0(na.omit(SR4[,2])," and ",na.omit(SR4[,3]))
SR4[,5]
na.omit(SR4[,4])

if(!is.na(SR4[,2]) & !is.na(SR4[,3])) {
  date1<- paste0(SR4[,2]," ", SR4[,4])
date1
  }

### Extract tables from PDF
tables<- extract_tables(txt)
tables
