## ============================== ##
## PROCESS GAME DATA FROM GAME ID ##
## ============================== ##
processGame <- function(id) {
    ## 1) Read simple match details
    gameJSON <- paste0("http://api.ggtracker.com/api/v1/matches/", id, ".json")
    gameJSON <- fromJSON(gameJSON)
}