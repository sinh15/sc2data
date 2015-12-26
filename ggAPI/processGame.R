## ============================== ##
## PROCESS GAME DATA FROM GAME ID ##
## ============================== ##
processGame <- function(id, dd) {
    ## 1) Read simple match details
    gameJSON <- paste0("http://api.ggtracker.com/api/v1/matches/", id, ".json")
    gameJSON <- "http://api.ggtracker.com/api/v1/matches/6336526.json"
    gameJSON <- fromJSON(gameJSON)
    
    ## at the moment we will rbind on the previous function, on the future we will not
    dd <- addGameSimpleDF(dd, gameJSON)
    
    ## 2) Read Advanced Match Details
    adJSON <- paste0("https://gg2-matchblobs-prod.s3.amazonaws.com/", id)
    adJSON <-  "https://gg2-matchblobs-prod.s3.amazonaws.com/6336526"
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
    names(df1)[1] <- "game"
    names(df2)[1] <- "game"
    
    
    ## COL(2): Name of the player
    df1$name <- dd[dd$gameID == 6336526, "p1_name"]
    df2$name <- dd[dd$gameID == 6336526, "p2_name"]
    
    ## COL(3): Minute of game
    df1[, 3] <- mutate(as.data.frame(int), minutes = int*30/60) %>% group_by(minutes) %>% summarize(max(minutes)) %>% select(minutes)
    df2$minutes <- df1[, 3]
    
    ## COL(4): Resources Lost x interval + position of players
    resourcesLost <- extractMaxs10SecondsBlocks(adJSON, int, 5)
    if(names(resourcesLost)[1] == pID_1) {
        p1 <- 1
        p2 <- 2

    } else {
        p1 <- 2
        p2 <- 1
    }
    
    df1$lost <- resourcesLost[[p1]]
    df2$lost <- resourcesLost[[p2]]
    
    ## COL(5): Active Workers
    activeWorkers <- extractMaxs10SecondsBlocks(adJSON, int, 9)
    df1$workers <- activeWorkers[[p1]]
    df2$workers <- activeWorkers[[p2]]
    
    ## COL(6): Current Minerals
    currentMinerals <- extractMaxs10SecondsBlocks(adJSON, int, 11)
    df1$minerals <- currentMinerals[[p1]]
    df2$minerals <- currentMinerals[[p2]]
    
    ## COL(7): Current Minerals Collection Rate
    mineralsCollectionRate <- extractMaxs10SecondsBlocks(adJSON, int, 12)
    df1$minerals_cr <- mineralsCollectionRate[[p1]]
    df2$minerals_cr <- mineralsCollectionRate[[p2]]
    
    ## COL(8): Current Vespene Gas
    currentVespene <- extractMaxs10SecondsBlocks(adJSON, int, 15)
    df1$vespene <- currentVespene[[p1]]
    df2$vespene <- currentVespene[[p2]]
    
    ## COL(9): Current Vespene Gas Collection Rate
    vespeneCollectionRate <- extractMaxs10SecondsBlocks(adJSON, int, 17)
    df1$vespene_cr <- vespeneCollectionRate[[p1]]
    df2$vespene_cr <- vespeneCollectionRate[[p2]]
    
    ## COL(10): Current Supply & Max Supply
    ## check if orther of data is crompromized
    supplyData <- supplyUsage(adJSON, int, 19)
    if(names(adJSON[[19]])[1] == pID_1) {
        df1$supply <- supplyData$v1
        df2$supply <- supplyData$v2   
    } else {
        df1$supply <- supplyData$v2
        df2$supply <- supplyData$v1
    }
    
    ## COL(11): Player Bases
    gameDuration <- dd[dd$gameID == 6336526, "gameDuration"]*16
    bInfo <- basesInfo(adJSON, int, 16, gameDuration)
    if(adJSON[[16]][[1]][[1]] == pID_1) {
        df1$bases <- bInfo$p1
        df2$bases <- bInfo$p2
    } else {
        df1$bases <- bInfo$p1
        df2$bases <- bInfo$p2
    }
    
    ## COL(12): Upgrades
    if(p1 == 1) {
        races <- c(as.character(dd[dd$gameID == 6336526, "p1_race"]), as.character(dd[dd$gameID == 6336526, "p2_race"]))
    } else races <- c(as.character(dd[dd$gameID == 6336526, "p2_race"]), as.character(dd[dd$gameID == 6336526, "p1_race"]))
    upgradesInfo <- computeUpgrades(adJSON, int, 8, races)
    df1$upgrades <- upgradesInfo[[p1]]
    df2$upgrades <- upgradesInfo[[p2]]
    
    ## COL(13): Army info
    units <- computeArmy(adJSON, int, 6, races, gameDuration)
    df1$units <- units[[p1]]
    df2$units <- units[[p2]]
    
    ## FLATTEN DFs
    df1 <- flatten(df1)
    df2 <- flatten(df2)

    ## Row of frames => frame/(16*30)
    ## 16 frames per second / 60 (seconds a minute) * 0.5 (intervals)
    ## floor() for completed integer
    ## floor(4783/(16*30)+1)
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

## ============================== ##
## CAPTURE BASES INFORMATION      ##
## ============================== ##
basesInfo <- function(adJSON, int, columnIndex, gameDuration) {
    #basesInfo: num_bases, bases_destroyed, bases_cancelled
    basesInfo <- list()
    
    # (compute created / destroyed / cancelled)
    for(i in c(1:length(adJSON[[columnIndex]]))) {
        ## XI: get player data frame
        xi <- adJSON[[columnIndex]][[i]][[2]]
        
        ## INTERVALS: bases created, destroyed, cancelled
        alive <- as.array(ifelse(!is.na(xi[, 1]), floor(xi[, 1]/(16*30)+1), NA))
        destroyed <- ifelse(!is.na(xi[, 1]) & as.numeric(xi[, 2]) <= gameDuration, floor(xi[, 2]/(16*30)+1), NA)
        cancelled <- ifelse(is.na(xi[, 1]), floor(xi[, 2]/(16*30)+1), NA)
        
        ## ADD all bases data
        len <- max(int)+1
        bAlive <- array(data = rep(0, len), dim = len)
        bDestroyed <- array(data = rep(0, len), dim = len)
        bCancelled <- array(data = rep(0, len), dim = len)
        for(j in c(1:length(alive))) {
            if(!is.na(alive[j])) bAlive[alive[j]:len] <- 1+bAlive[alive[j]:len]
            if(!is.na(destroyed[j])) {
                bAlive[destroyed[j]:len] <- bAlive[destroyed[j]:len]-1
                bDestroyed[destroyed[j]:len] <- 1+bDestroyed[destroyed[j]:len]
            }
            if(!is.na(cancelled[j])) bCancelled[cancelled[j]:len] <- 1+bCancelled[cancelled[j]:len]
        }
        
        ## Add to solution
        if(i == 1) {
            pBases <- data.frame(num_bases = bAlive, bases_destroyed = bDestroyed, bases_cancelled = bCancelled)
            basesInfo$p1 <- pBases
        } else {
            pBases <- data.frame(num_bases = bAlive, bases_destroyed = bDestroyed, bases_cancelled = bCancelled)
            basesInfo$p2 <- pBases
        }
        
    }
    
    #return statement
    basesInfo
}

## ============================== ##
## COMPUTE UPGRADES               ##
## ============================== ##
computeUpgrades <- function(adJSON, int, columnIndex, races) {
    #upgradesInfo: P1 & P2 dataframes
    upgradesInfo <- list()
    
    # check varaibles are avaiable
    if(!exists("upgrades")) upgrades <- readUpgradesList()
    len <- max(int)+1
    zergUpgrades <- upgrades[[1]][, 1]
    terranUpgrades <- upgrades[[2]][, 1]
    protossUpgrades <- upgrades[[3]][, 1]
    zLength <- length(zergUpgrades)
    tLength <- length(terranUpgrades)
    pLength <- length(protossUpgrades)
    tLength <- zLength + tLength + pLength
    
    # compute upgrades
    for(i in c(1:length(adJSON[[columnIndex]]))) {
        ## prepare environment
        xi <- adJSON[[columnIndex]][[i]]
        pUpgrades <- as.data.frame(matrix(data = rep(NA, len*tLength), ncol = tLength, nrow = len))
        names(pUpgrades) <- c(zergUpgrades, terranUpgrades, protossUpgrades)
        
        ## Create 0s depending on RACE
        if(races[i] == "Z") {
            pUpgrades[, 1:zLength] <- 0
        } else if(races[i] == "T") {
            pUpgrades[, (zLength+1):(zLength+tLength)] <- 0
        } else {
            pUpgrades[, (zLength+tLength+1):(zLength+tLength+pLength)] <- 0
        }
        
        ## add upgrades
        for(j in c(1:dim(xi)[1])) {
            pUpgrades[floor(as.numeric(xi[j, 2])/(16*30)+1), xi[j, 1]] <- 1
        }
        
        ## add uplayer upgrades to list
        if(i == 1) upgradesInfo$p1 <- pUpgrades
        else upgradesInfo$p2 <- pUpgrades
    }
    
    upgradesInfo
}

computeArmy <- function(adJSON, int, columnIndex, races, gameDuration) {
    ## Army Info
    armyInfo <- list()
    
    ## Read race units & compute variables
    if(!exists("unitsList")) unitsList <- readUnitsLists()
    len <- max(int)+1
    tUnits <- sum(length(unitsList[[1]][, 1])+length(unitsList[[2]][, 1])+length(unitsList[[3]][, 1]))
    zergNames <- sort(c(unitsList[[1]][, 1], paste0(unitsList[[1]][, 1], "D")))
    terranNames <- sort(c(unitsList[[2]][, 1], paste0(unitsList[[2]][, 1], "D")))
    protossNames <- sort(c(unitsList[[3]][, 1], paste0(unitsList[[3]][, 1], "D")))
    zLength <- length(zergNames)
    tLength <- length(terranNames)
    pLength <- length(protossNames)
    
    for(i in c(1:length(adJSON[[columnIndex]]))) {
        ## prepare environment
        xi <- adJSON[[columnIndex]][[i]]
        pUnits <- as.data.frame(matrix(data = rep(NA, len*tUnits*2), ncol = (tUnits*2), nrow = len))
        colnames(pUnits) <- c(zergNames, terranNames, protossNames)
        
        ## craetes 0s depending on race
        if(races[i] == "Z") {
            pUnits[, 1:zLength] <- 0
        } else if(races[i] == "T") {
            pUnits[, (zLength+1):(zLength+tLength)] <- 0
        } else {
            pUnits[, (zLength+tLength+1):(zLength+tLength+pLength)] <- 0
        }
        
        ## Compute CRAETED & DEFEATED by GAME INTERVAL
        for(j in c(1:dim(xi)[1])) {
            ## add unit craeted to proper row
            uColumn <- which(colnames(pUnits) == xi[j, 1])
            uRow <- floor(as.numeric(xi[j, 2])/(16*30)+1)
            pUnits[uRow, uColumn] <- pUnits[uRow, uColumn]+1
            
            ## add unit destroyed to column if required
            if(as.numeric(xi[j, 3]) <= gameDuration) {
                uRow <- floor(as.numeric(xi[j, 3])/(16*30)+1)
                pUnits[uRow, (uColumn+1)] <- pUnits[uRow, (uColumn+1)]+1
            }
        }
        
        ## Compute ARMY TOTALS by INTERVAL (crated & destroyed)
        for(j in c(2:len)) {
            pUnits[j, ] <- pUnits[j, ] + pUnits[(j-1), ]
        }
        
        ## Add to List
        if(i == 1) armyInfo$p1 <- pUnits
        else armyInfo$p2 <- pUnits
    }
    
    ## Return armyInfo
    armyInfo
}
