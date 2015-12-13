## ============================== ##
## Enable Libraries               ##
## ============================== ##
library(googleSheets)
library(jsonlite)
library(dplyr)


## ============================== ##
## Auth Spreadsheets              ##
## ============================== ##
### sergi.porras.pages@gmail.com
gs_auth()


## ============================== ##
## Initialize Environment         ##
## ============================== ##
rm(dd)
dd <- createSimpleDF()
dd <- addGameSimpleDF(dd, gameJSON)
dd <- castDateSimpleDF(dd)