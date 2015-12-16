## ================================= ##
## PLAYING WITH BASE PLOTTING SYSTEM ##
## ================================= ##

## READ DATA
library(xlsx)
library(dplyr)
dd <- read.xlsx("data.xlsx", 1)
dd[, "name"] <- as.character(dd[, "name"])
names(dd)

## global parameters for plot
?par

## base plotting
library(datasets)
hist(airquality$Ozone)

airquality <- mutate(airquality, Month = factor(Month))
boxplot(Ozone ~ Month, airquality, xlab = "Month", ylab = "Ozone (ppb)")
with(airquality, plot(Wind, Ozone))
with(filter(airquality, Month == "5"), points(Wind, Ozone, col = "blue"))

with(filter(dd, transformation == 0), plot(minerals, gas))
model <- lm(minerals ~ gas, filter(dd, transformation == 0))
abline(model, lwd = 2)

par(mfrow = c(1, 2))
with(dd, plot(buildTime, minerals+gas))
with(dd, plot(buildTime, supply))
