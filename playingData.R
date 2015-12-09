## Loading Required Libraries
library(xlsx)
library(dplyr)


## READ AND TRANSFORM
dd <- read.xlsx("data.xlsx", 1)
dd[, "name"] <- as.character(dd[, "name"])
names(dd)

## CHECK MEAN, MIN, MAX minearls
mean(dd[dd$transformation == 0 & dd$type == "unit", "minerals"])
min(dd[dd$transformation == 0 & dd$type == "unit", "minerals"])
max(dd[dd$transformation == 0 & dd$type == "unit", "minerals"])