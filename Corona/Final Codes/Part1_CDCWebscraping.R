install.packages( "rvest")
library(rvest)

# This is the URL at which the list of affected countries is given. Copy the url within quotes and paste this in web browser to see the page. 

# Updated on 19-03-2020: The url is changed from 
# URL <- "https://www.cdc.gov/coronavirus/2019-ncov/locations-confirmed-cases.html#map"
# to
URL <- "https://www.cdc.gov/coronavirus/2019-ncov/cases-updates/world-map.html"
# Actual Web Scraping the URL

# In this line we will read the url using 'read_html' function.

PAGE <- read_html(URL) %>%
  
# After reading the html we will extract the html potion by using the xpath from the original url. You can see video how I copied this xpath which is in quotes here. 

# UPDATE ON THIS LINE OF CODE (*Dated: 07-March-2020*): 
# The video contains the xpath to previous version of CDC website. Previously that `xpath` was `/html/body/div[6]/main/div[3]/div/div[3]/div/div/ul` which can be seen in the video and in above lines but after the CDC has updated the website along with the list of affected countries, We now have to change the xpath in our code too. The new xpath is now `/html/body/div[6]/main/div[3]/div/div[3]/div[2]` that is updated below as well:
# UPDATE (Dated: 25/03/2020)
# Now the xpath is again changed to "/html/body/div[7]/main/div[3]/div/div[3]/div[2]" so instead of previous one "/html/body/div[6]/main/div[3]/div/div[3]/div[2]" we will use new one. 
  
    html_nodes(xpath="/html/body/div[7]/main/div[3]/div/div[3]/div[2]") %>%
  
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
# Total number of affected countries on date 07-03-2020 = 89

Countriestable

