
Different files here represent the codes used in a video series. This video series will cover different geographical, epidemiological, genomic and proteomic analysis. I am doing this series to make myself helpful for our friends in China and any other countries affected by the novel coronavirus (COVID-19).

---

**Part 1**:<br/> 
Web Scraping for Affected Countries by COVID-19 in R with free Source Code <br/>
[https://www.youtube.com/watch?v=ypNCPQDvsU0](https://www.youtube.com/watch?v=ypNCPQDvsU0)<br/>
*Code Available in File* : `Webscraping1_Final.R`

---

## Web Scraping for Affected Countries by COVID-19 in R with free Source Code (Webscraping1_Final.R)

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