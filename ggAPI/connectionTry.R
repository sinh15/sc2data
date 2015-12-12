## Load libraries
library(jsonlite)

## Load Game: Simple Details
gameJSON <- "http://api.ggtracker.com/api/v1/matches/6306072.json"

## Load Game: High Details:
gameJSON <-  "https://gg2-matchblobs-prod.s3.amazonaws.com/6306072"

## Actual CALL to API
gameJSON <- fromJSON(gameJSON)

#Check Variables & Class of each one
names(gameJSON)
View(lapply(gameJSON, class))

## From simple details get playerIDs, names, race & winner
### "entities" column 16. DATA FRAME
entities <- gameJSON[["entities"]]
identity <- entities[, "identity"]

