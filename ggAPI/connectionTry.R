## Load libraries
library(jsonlite)

## Load Game: Simple Details
gameJSON <- "http://api.ggtracker.com/api/v1/matches/6306072.json"

## Load Game: High Details
gameJSON <-  "https://gg2-matchblobs-prod.s3.amazonaws.com/6306072"

## Load Player Details
gameJSON <-  "http://api.ggtracker.com/api/v1/identities/1586656.json"

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
gameDurationM <- gameDuration/60
gameMapID <- gameJSON[["map"]][["id"]]
gameMapName <- gameJSON[["map"]][["name"]]
replayID <- gameJSON[["replays"]][, 1]
replayHash <- gameJSON[["replays"]][, 2]
replayURL <- gameJSON[["replays"]][, 3]

### entities fields
entities <- gameJSON[["entities"]]

p1_race <- entities[, "race"][1]
p2_race <- entities[, "race"][2]
matchup <- computeMatchup(p1_race, p2_race)
p1_win <- entities[, "win"][1]
p2_win <- entities[, "win"][2]

### entities -> identity data
p1_id <- entities[, "identity"][, "id"][1]
p2_id <- entities[, "identity"][, "id"][2]
p1_bnetID <- entities[, "identity"][, "bnet_id"][1]
p2_bnetID <- entities[, "identity"][, "bnet_id"][2]
p1_name <- entities[, "identity"][, "name"][1]
p2_name <- entities[, "identity"][, "name"][2]
p1_region <- entities[, "identity"][, "gateway"][1]
p2_region <- entities[, "identity"][, "gateway"][2]
p1_league <- entities[, "identity"][, "current_league_1v1"][1]
p2_league <- entities[, "identity"][, "current_league_1v1"][2]
