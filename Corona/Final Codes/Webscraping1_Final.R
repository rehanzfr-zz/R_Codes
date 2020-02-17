install.packages( "rvest")
library(rvest)

# This is the URL at which the list of affected countries is given. Copy the url within quotes and paste this in web browser to see the page. 
URL <- "https://www.cdc.gov/coronavirus/2019-ncov/locations-confirmed-cases.html#map"

# Actual Web Scraping the URL

# In this line we will read the url using 'read_html' function.
PAGE <- read_html(URL) %>%
# After reading the html we will extract the html potion by using the xpath from the original url. You can see video how I copied this xpath which is in quotes here. 
    html_nodes(xpath="/html/body/div[6]/main/div[3]/div/div[3]/div/div/ul") %>%
# Now the map function of purrr package will be used to get the 'li' node of html which actually contains all the names of the countries. 
    purrr::map(~html_nodes(.x, 'li') %>% 
# After taking the list we will convert into text form.                  
              html_text() %>% 
# gsub pattern extracts the things based on regex. Here I want to change the tabs (\\t), new lines (\\n) and returns (\\r) to nothing ('').  
              gsub(pattern = '\\t|\\r|\\n', replacement = ''))
# Now I am saving the list (PAGE[[1]]) to countries.
countries <- PAGE[[1]]
# Lets print this object. 
countries

# List of countries will be Converted to Dataframe. 
countries <- as.data.frame(matrix(unlist(countries),nrow=length(countries),byrow=TRUE))
# Now I want to change the name of column of dataframe to "Countries"
names(countries)[1] <- "Countries"
# Lets add a new column named as (Sr.No.) and add the sequence of numbers of series of numbers into it. 
Countriestable <- data.frame(Sr.No.=seq.int(nrow(countries)),countries)
# Lets print this dataframe.
Countriestable

