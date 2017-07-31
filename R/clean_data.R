
## packages
library(readr)
library(dplyr)
library(lubridate)
library(stringr)
library(countrycode)
library(tidyr)
library(anytime)

## Read in eBird data
corey_data <- read_csv("data/eBird data/corey_data.csv")
colnames(corey_data) <- gsub(" ", "_", colnames(corey_data))
colnames(corey_data) <- gsub("/", "_", colnames(corey_data))

corey_data <- corey_data %>%
  # remove hybrids and domestics
  filter(!grepl("hybrid|Domestic", Common_Name)) %>%
  # remove spuhs
  filter(!grepl(" sp\\.", Common_Name)) %>%
  filter(!grepl("\\/", Common_Name)) %>%
  mutate(sciName = stringr::word(Scientific_Name, 1, 2),
         # removing text between parenthesis in common name to compare uniques
         comName = gsub("\\s*\\([^\\)]+\\)", "", Common_Name),
         # changing state/province into a country factor
         Country = countrycode::countrycode(substr(State_Province, 1, 2), "iso2c", "country.name")) %>%
  mutate(Date = as.Date(Date, format="%m-%d-%Y"),
         Year = year(Date),
         Month = month(Date)) %>%
  unite(., Year_mon, Year, Month, sep="-") %>%
  mutate(Year_mon = anydate(Year_mon))



### remove all but my data
rm(list=setdiff(ls(), c("corey_data")))

### save study site data as RData file
save.image("data/corey_data.RData")
