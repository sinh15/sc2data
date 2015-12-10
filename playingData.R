## Loading Required Libraries
#Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_66')
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

## Play with NA columns and intersects
x <- dd[!is.na(dd$airAttack), "name"]
y <- dd[!is.na(dd$groundAttack), "name"]
z <- Reduce(intersect, list(x, y))

groundDPS <- dd$groundAttack*dd$gaMultiplier/dd$groundCD
airDPS <- dd$airAttack*dd$aaMultiplier/dd$airCD
res <- rbind(dd$name, groundDPS, airDPS)