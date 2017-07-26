library(phytools)
library(readr)
library(dplyr)
# devtools::install_bioc("ggtree")
library(ggtree)

#Roderick super tree at the moment
birdies<-read.nexus("tree/976113/5.BirdSupertree.tre")

#ebird for taxonomy lookup
read_csv("taxonomy/eBird-Clements-Checklist-v2016-10-August-2016.csv") %>%
  filter(Category=="species")->lo

#syncing names
group_by(lo,Order) %>% summarize(gs=`Scientific name`[1],sp.count=n())->lo1
lo1$gs<-sub(" ","_",lo1$gs)

#dropping tips
out<-drop.tip(birdies,birdies$tip.label[!birdies$tip.label%in%lo1$gs])
out$tip.label<-lo1$Order[match(out$tip.label,lo1$gs)]

#filtering down to orders in the tree
lo1%>%select(Order,sp.count)%>%
  filter(Order%in%out$tip.label)->df

# ggtree doesn't play nicely with tibbles
df1<-data.frame(df$sp.count)
row.names(df1)<-df$Order

ggg<-ggtree(out)+geom_tiplab()+ggtitle("species richness in orders")
g <-gheatmap(ggg, df1, offset = 3, width=0.1,low = "blue",high = "red", colnames = FALSE)
print(g)


