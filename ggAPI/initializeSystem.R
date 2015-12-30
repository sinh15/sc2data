## ============================== ##
## 1) Enable Libraries            ##
## ============================== ##
if(!require(googlesheets)) install.packages("googlesheets")
if(!require(jsonlite)) install.packages("jsonlite")
if(!require(dplyr)) install.packages("dplyr")
if(!require(ggplot2)) install.packages("ggplot2")

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
source('spreadsheetsConnection.R')
source('builderSimpleDF.R')
source('builderAdvancedDF.R')
source('upgradesAndArmy.R')
source('processGames.R')

## ============================== ##
## 4) Creating DFs                ##
## ============================== ##
dd <- createSimpleDF()
df <- createAdvancedDF()

## ============================== ##
## 5.1) Read game                 ##
## ============================== ##
gameJSON <- "http://api.ggtracker.com/api/v1/matches/6306072.json"
gameJSON <- fromJSON(gameJSON)
dd <- extractSimpleGameDetails(gameJSON)

## ============================== ##
## 5.2) Read online Simple DD     ##
## ============================== ##
dd <- readSimpleDataFrameSS()

## ============================== ##
## 6) Read config files           ##
## ============================== ##
upgrades <- readUpgradesList()
unitsList <- readUnitsLists()


## functions to create local file and uplaod it to gmail
write.csv(dd, file = "tempFiles/temps.csv", row.names = FALSE)
gs_upload("tempFiles/temps.csv", sheet_title = x)