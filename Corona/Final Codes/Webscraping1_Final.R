install.packages( "rvest")
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

