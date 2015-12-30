## ============================== ##
## PROCESS GAME DATA FROM GAME ID ##
## ============================== ##
processGame <- function(id, upload) {
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
    gameAdvanced <- extractAdvancedGameDetails(adJSON, id, gameSimple, upload)
    df <<- rbind(df, gameAdvanced)
}

readGamesGGTracker <- function(id, upload, max = 20) {
    ##sinHID <- 1586656
    
    upToDate <- FALSE
    pageNum <- 1
    uploaded <- 0
    while(!upToDate & uploaded < max) {
        gameList <- paste0("http://api.ggtracker.com/api/v1/matches?category=Ladder&game_type=1v1&identity_id=", id, "&page=", pageNum, "&paginate=true")
        gameList <- fromJSON(gameList)
        
        gameList <- gameList[["collection"]][, 1]
        pageGames <- match(gameList, dd[, "gameID"])
        
        for(j in c(1:length(pageGames))) {
            if(is.na(pageGames[j])) {
                processGame(gameList[j], upload)
                uploaded <- uploaded + 1
            }
            else upToDate <- TRUE
        }
        
        pageNum <- pageNum + 1
    }
}



# gameJSON <- "http://api.ggtracker.com/api/v1/matches/6336526.json"
# gameJSON <- fromJSON(gameJSON)
# dd <- addGameSimpleDF(dd, gameJSON)
# 
# adJSON <- paste0("https://gg2-matchblobs-prod.s3.amazonaws.com/", id)
# adJSON <-  "https://gg2-matchblobs-prod.s3.amazonaws.com/6336526"
# adJSON <- fromJSON(adJSON)


##processGame(6336526, FALSE)
# 
# processGame(6350628, FALSE)
# processGame(6350630, FALSE)
# processGame(6350631, FALSE)
# processGame(6350629, FALSE)
# processGame(6350633, FALSE)
# processGame(6350632, FALSE)
# 
# processGame(6353026, FALSE)
# processGame(6353025, FALSE)
# processGame(6353027, FALSE)
# processGame(6353024, FALSE)
# processGame(6353023, FALSE)
# processGame(6353018, FALSE)
# processGame(6353017, FALSE)
# processGame(6353020, FALSE)
# processGame(6353019, FALSE)
# processGame(6353016, FALSE)
#
# processGame(6355861, FALSE)
# processGame(6355864, FALSE)
# processGame(6355863, FALSE)
# processGame(6355862, FALSE)
# processGame(6355865, FALSE)
# processGame(6355869, FALSE)
# processGame(6355867, FALSE)
# processGame(6355866, FALSE)
# processGame(6355868, FALSE)
# processGame(6355870, FALSE)

