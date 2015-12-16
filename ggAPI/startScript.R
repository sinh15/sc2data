## ============================== ##
## Enable Libraries               ##
## ============================== ##
library(googlesheets)
library(jsonlite)
library(dplyr)


## ============================== ##
## Auth Spreadsheets              ##
## ============================== ##
### sergi.porras.pages@gmail.com
gs_auth()
gs_auth(new_user = TRUE)


## ============================== ##
## Initialize Environment         ##
## ============================== ##
rm(dd)
dd <- createSimpleDF()
dd <- addGameSimpleDF(dd, gameJSON)
dd <- castDateSimpleDF(dd)

> source('~/GitHub/sc2data/ggAPI/buildingFunctions.R')


## functions to create local file and uplaod it to gmail
write.csv(dd, file = "gameDetails/temps.csv", row.names = FALSE)
gs_upload("gameDetails/temps.csv", sheet_title = x)