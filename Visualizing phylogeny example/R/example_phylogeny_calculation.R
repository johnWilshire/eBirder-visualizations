## packages
library(dplyr)
library(ggplot2)
library(readr)

## load data
load("Data/corey_data.RData")

## first need to get the correct amount of lifers estimated
life_list <- corey_data %>%
  filter(COMMON_NAME %in% c("Muscovy Duck", "Rock Pigeon")) %>%
  bind_rows(corey_data %>%
              filter( CATEGORY %in% c("species", "issf", "form"))) %>%
  distinct(COMMON_NAME, .keep_all=TRUE) %>%
  filter(!grepl("/", COMMON_NAME))
  

## Calculate the phylogeny variables
## read in ebird clements checklists
ebird_species <- read_csv("Data/2016_taxonomy/eBird-Clements-Checklist-v2016-10-August-2016.csv")
