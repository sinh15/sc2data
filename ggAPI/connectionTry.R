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

## SIMPLE DETAILS: Get relevant information
gameID <- gameJSON[["id"]]
gameDate <- as.Date(gameJSON[["ended_at"]])
gameCategory <- gameJSON[["category"]]
gameType <- gameJSON[["game_type"]]
gameDuration <- gameJSON[["duration_seconds"]]
gameMapID <- gameJSON[["map"]][["id"]]
gameMapName <- gameJSON[["map"]][["name"]]
replayID <- gameJSON[["replays"]][, 1]
replayHash <- gameJSON[["replays"]][, 2]
replayURL <- gameJSON[["replays"]][, 3]

### entities fields
entities <- gameJSON[["entities"]]
id_1 <- entities[, "identity"][, "id"][1]
id_2 <- entities[, "identity"][, "id"][2]
bnet_id_1 <- entities[, "identity"][, "bnet_id"][1]
bnet_id_2 <- entities[, "identity"][, "bnet_id"][2]
p1_name <- entities[, "identity"][, "name"][1]
p2_name <- entities[, "identity"][, "name"][2]
p1_race <- entities[, "race"][1]
p2_race <- entities[, "race"][2]
p1_win <- entities[, "win"][1]
p2_win <- entities[, "win"][2]
