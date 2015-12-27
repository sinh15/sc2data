## ============================== ##
## PROCESS GAME DATA FROM GAME ID ##
## ============================== ##
processGame <- function(id) {
    ## CHECK containers exist
    if(!exists("dd")) stop("Please Create Simple Data Frame")
    else if(!exists("df")) stop("Please Create Advanced Data Frame")
    
    ## ADD: Game to simple dd
    gameJSON <- paste0("http://api.ggtracker.com/api/v1/matches/", id, ".json")
    gameJSON <- fromJSON(gameJSON)
    gameSimple <- extractSimpleGameDetails(gameJSON)
    dd <<- rbind(dd, gameSimple)
    
    ## ADD: Game to advanced df
    adJSON <- paste0("https://gg2-matchblobs-prod.s3.amazonaws.com/", id)
    adJSON <- fromJSON(adJSON)
    gameAdvanced <- extractAdvancedGameDetails(adJSON, id, gameSimple)
    df <<- rbind(df, gameAdvanced)
}



# gameJSON <- "http://api.ggtracker.com/api/v1/matches/6336526.json"
# gameJSON <- fromJSON(gameJSON)
# dd <- addGameSimpleDF(dd, gameJSON)
# 
# adJSON <- paste0("https://gg2-matchblobs-prod.s3.amazonaws.com/", id)
# adJSON <-  "https://gg2-matchblobs-prod.s3.amazonaws.com/6336526"
# adJSON <- fromJSON(adJSON)


##processGame(6336526)