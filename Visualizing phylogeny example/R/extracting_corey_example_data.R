# packages
library(dplyr)
library(RSQLite)
library(dbplyr)

# connect to ebird db (stored on my D drive)
ebird_db <- src_sqlite("D:/All eBird Data/ebird.sqlite", create=FALSE)
all_ebird <- tbl(ebird_db, "ebird")

# extract data for myself - need to know your userid in order for this to work
corey_data <- all_ebird %>%
  filter(OBSERVER_ID == "obsr290336") %>%
  collect(n=Inf)

# save my data as example .RData file
### remove all but my data
rm(list=setdiff(ls(), c("corey_data")))

### save study site data as RData file
save.image("Data/corey_data.RData")
