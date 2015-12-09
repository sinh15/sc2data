## Loading Required Libraries
library(xlsx)
library(dplyr)


## READ AND TRANSFORM
dd <- read.xlsx("data.xlsx", 1)
dd[, "name"] <- as.character(dd[, "name"])
names(dd)