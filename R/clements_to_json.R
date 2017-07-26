# clements_to_json.R
if(!require(pacman)) install.packages('pacman')
# pac man installs then loads if not found
p_load(jsonlite, dplyr, readr)

#ebird for taxonomy lookup
read_csv("taxonomy/eBird-Clements-Checklist-v2016-10-August-2016.csv") %>%
  filter(Category=="species") -> lo

sync_names <- function (level) {
  lo %>% group_by_(level) %>%
    summarize(gs = `Scientific name`[1],
              gs = sub(" ", "_", gs),
              sp.count=n())
} 
sync_names("Family") %>% write_json("taxonomy/eBird_clements_checklist_family.json")
sync_names("Order") %>% write_json("taxonomy/eBird_clements_checklist_order.json")
