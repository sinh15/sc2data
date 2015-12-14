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