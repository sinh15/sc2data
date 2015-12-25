## ============================== ##
## 1) Enable Libraries            ##
## ============================== ##
library(googlesheets)
library(jsonlite)
library(dplyr)

## ============================== ##
## 2) Auth Spreadsheets           ##
## ============================== ##
### sergi.porras.pages@gmail.com
gs_auth()
gs_auth(new_user = TRUE)

## ============================== ##
## 3) Initialize Environment      ##
## ============================== ##
### First, set the working directory as the one this file is.
source('buildingFunctions.R')
source('spreadsheetsConnection.R')
source('listofupgrades.R')

## ============================== ##
## 4) Creating the simple DF      ##
## ============================== ##
dd <- createSimpleDF()

## ============================== ##
## 5.1) Read game                 ##
## ============================== ##
gameJSON <- "http://api.ggtracker.com/api/v1/matches/6306072.json"
gameJSON <- fromJSON(gameJSON)
dd <- addGameSimpleDF(dd, gameJSON)
dd <- castDateSimpleDF(dd)

## ============================== ##
## 5.2) Read online DD            ##
## ============================== ##
dd <- readSimpleDataFrameSS()

## functions to create local file and uplaod it to gmail
write.csv(dd, file = "gameDetails/temps.csv", row.names = FALSE)
gs_upload("gameDetails/temps.csv", sheet_title = x)