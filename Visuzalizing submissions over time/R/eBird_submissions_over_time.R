## packages
library(dplyr)
library(ggplot2)
library(lubridate)
library(tidyr)
library(gganimate)

## load data
load("Data/corey_data.RData")

###########################
## submissions over time ##
###########################

# format date
corey_data$OBSERVATION_DATE <- as.Date(corey_data$OBSERVATION_DATE, format="%Y-%m-%d")
corey_data$Year_mon <- format(as.Date(corey_data$OBSERVATION_DATE), "%Y-%m")


# plot checklists per time
corey_data %>% 
  group_by(Year_mon) %>%
  summarise(checklists=length(unique(SAMPLING_EVENT_IDENTIFIER))) %>%
  mutate(cumulative=cumsum(checklists)) %>%
  ggplot(., aes(x=Year_mon, y=cumulative)) +
  geom_point()+
  geom_line()