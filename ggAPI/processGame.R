## ============================== ##
## PROCESS GAME DATA FROM GAME ID ##
## ============================== ##
processGame <- function(id, dd) {
    ## 1) Read simple match details
    gameJSON <- paste0("http://api.ggtracker.com/api/v1/matches/", id, ".json")
    gameJSON <- fromJSON(gameJSON)
    
    ## at the moment we will rbind on the previous function, on the future we will not
    dd <- addGameSimpleDF(dd, gameJSON)
    
    ## 2) Read Advanced Match Details
    adJSON <- paste0("https://gg2-matchblobs-prod.s3.amazonaws.com/", id)
    adJSON <- fromJSON(adJSON)
    
    
    
    ## PREPARE INTERVALS
    int <- array(1:length(adJSON[["Lost"]][[1]]))
    int <- apply(int, 1, function(i) ((i-1)*10)%/%30)
    
    ## STORAGE DATA FRAMES
    df1 <- data.frame(matrix(nrow = max(int)+1))
    df2 <- data.frame(matrix(nrow = max(int)+1))
    
    ## COL(1): Id of the player
    pID_1 <- dd[dd$gameID == 6336526, "p1_ID"]
    pID_2 <- dd[dd$gameID == 6336526, "p2_ID"]
    df1[, 1] <- dd[dd$gameID == 6336526, "p1_ID"]
    df2[, 1] <- dd[dd$gameID == 6336526, "p2_ID"]
    names(df1)[1] <- "gameID"
    names(df2)[1] <- "gameID"
    
    
    ## COL(2): Name of the player
    df1[, 2] <- dd[dd$gameID == 6336526, "p1_name"]
    df2[, 2] <- dd[dd$gameID == 6336526, "p2_name"]
    
    ## COL(3): Minute of game
    df1[, 3] <- mutate(as.data.frame(int), minutes = int*30/60) %>% group_by(minutes) %>% summarize(max(minutes)) %>% select(minutes)
    df2[, 3] <- df1[, 3]
    
    ## COL(4): Resources Lost x interval + position of players
    resourcesLost <- extractMaxs10SecondsBlocks(adJSON, int, 5)
    if(names(resourcesLost)[1] == pID_1) {
        p1 <- 1
        p2 <- 2

    } else {
        p1 <- 2
        p2 <- 1
    }
    
    df1[, 4] <- resourcesLost[[p1]]
    df2[, 4] <- resourcesLost[[p2]]
    
    ## COL(5): Active Workers
    activeWorkers <- extractMaxs10SecondsBlocks(adJSON, int, 9)
    df1[, 5] <- activeWorkers[[p1]]
    df2[, 5] <- activeWorkers[[p2]]
    
    ## COL(6): Current Minerals
    currentMinerals <- extractMaxs10SecondsBlocks(adJSON, int, 11)
    df1[, 6] <- currentMinerals[[p1]]
    df2[, 6] <- currentMinerals[[p2]]
    
    ## COL(7): Current Minerals Collection Rate
    mineralsCollectionRate <- extractMaxs10SecondsBlocks(adJSON, int, 12)
    df1[, 7] <- mineralsCollectionRate[[p1]]
    df2[, 7] <- mineralsCollectionRate[[p2]]
    
    ## COL(8): Current Vespene Gas
    currentVespene <- extractMaxs10SecondsBlocks(adJSON, int, 15)
    df1[, 8] <- currentVespene[[p1]]
    df2[, 8] <- currentVespene[[p2]]
    
    ## COL(9): Current Vespene Gas Collection Rate
    vespeneCollectionRate <- extractMaxs10SecondsBlocks(adJSON, int, 17)
    df1[, 9] <- vespeneCollectionRate[[p1]]
    df2[, 9] <- vespeneCollectionRate[[p2]]
    
    ## COL(10): Current Supply & Max Supply
    supplyData <- supplyUsage(adJSON, int, 19)
    df1$supply <- supplyData$v1
    df2$supply <- supplyData$v2
    
    upgrades <- readUpgrades()

    
    ## Row of frames => frame/(16*30)
    ## 16 frames per second / 60 (seconds a minute) * 0.5 (intervals)
    ## floor() for completed integer
    ## floor(4783/(16*30))
}

## ============================== ##
## EXTRACT MAS BLOCKS 10 SECONDS  ##
## ============================== ##
extractMaxs10SecondsBlocks <- function(adJSON, int, columnIndex) {
    g30 <- list()
    for(i in c(1:length(adJSON[[columnIndex]]))) {
        xi <- as.data.frame(adJSON[[columnIndex]][[i]])
        names(xi) <- c("toExtract")
        g30[i] <- mutate(xi, interval = int) %>% group_by(interval) %>% 
            summarize(toExtract = max(toExtract)) %>% select(toExtract)
    }
    
    names(g30) <- names(adJSON[[columnIndex]])
    g30
}


## ============================== ##
## SUPPLY USAGE DATA EXTRACTION   ##
## ============================== ##
supplyUsage <- function(adJSON, int, columnIndex) {
    supply <- list()    
    for(i in c(1:length(adJSON[[columnIndex]]))) {
        xi <- as.data.frame(adJSON[[columnIndex]][[i]])
        names(xi) <- c("currentSupply", "maxSupply")
        xi <- mutate(xi, interval = int) %>% group_by(interval) %>% 
            summarize(currentSupply = max(currentSupply), maxSupply = max(maxSupply))
        xi <- castNormalDF(xi)
        if(i == 1) supply$v1 <- xi[, 2:3]
        else supply$v2 <- xi[, 2:3]
    }
    
    supply
}
