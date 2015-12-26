## ======================================= ##
## FUCTIONS TO CREATE UPGRADE & ARMY LISTs ##
## ======================================= ##
#ALL UPGRADES & UNITS => Zerg/terran/protoss
createUpgradesAndArmy <- function() {
    ## READ UPGRADES
    zergJSON <-  "https://gg2-matchblobs-prod.s3.amazonaws.com/6345542"
    terranJSON <-  "https://gg2-matchblobs-prod.s3.amazonaws.com/6345614"
    protossJSON <-  "https://gg2-matchblobs-prod.s3.amazonaws.com/6345638"
    zergJSON <- fromJSON(zergJSON)
    terranJSON <- fromJSON(terranJSON)
    protossJSON <- fromJSON(protossJSON)
    
    ### UPGRADES by RACE, SORT and CRAETE FILE
    zergUpgrades <-  as.data.frame(sort(zergJSON[[8]][[1]][, 1]))
    names(zergUpgrades) <- "zergUpgrades"
    write.csv(zergUpgrades, file = "configFiles/zergUpgrades.csv", row.names = FALSE)
    
    terranUpgrades <- as.data.frame(sort(terranJSON[[8]][[1]][, 1]))
    names(terranUpgrades) <- "terranUpgrades"
    write.csv(terranUpgrades, file = "configFiles/terranUpgrades.csv", row.names = FALSE)
    
    
    protossUpgrades <- as.data.frame(sort(protossJSON[[8]][[1]][, 1]))
    names(protossUpgrades) <- "protossUpgrades"
    write.csv(protossUpgrades, file = "configFiles/protossUpgrades.csv", row.names = FALSE)
    
    
    ### UNITS by RACE, SORT and CRAETE FILE
    zergArmy <- zergJSON[[6]][[1]]
    zergUnits <- as.data.frame(sort(unique(zergArmy[, 1])))
    names(zergUnits) <- "zergUnits"
    write.csv(zergUnits, file = "configFiles/zergUnits.csv", row.names = FALSE)
    
    terranArmy <- terranJSON[[6]][[1]]
    terranUnits <- as.data.frame(sort(unique(terranArmy[, 1])))
    names(terranUnits) <- "terranUnits"
    write.csv(terranUnits, file = "configFiles/terranUnits.csv", row.names = FALSE)
    
    protossArmy <- protossJSON[[6]][[1]]
    protossUnits <- as.data.frame(sort(unique(protossArmy[, 1])))
    names(protossUnits) <- "protossUnits"
    write.csv(protossUnits, file = "configFiles/protossUnits.csv", row.names = FALSE)
}  
    
## ======================================= ##
## FUCTIONS TO READ UPGRADE & ARMY LISTs   ##
## ======================================= ##
readUpgradesList <- function() {
    zergUpgrades <- read.csv("configFiles/zergUpgrades.csv", stringsAsFactors = FALSE)
    terranUpgrades <- read.csv("configFiles/terranUpgrades.csv", stringsAsFactors = FALSE)
    protossUpgrades <- read.csv("configFiles/protossUpgrades.csv", stringsAsFactors = FALSE)    
    
    list(zergUpgrades, terranUpgrades, protossUpgrades)
}

readUnitsLists <- function() {
    zergUnits <- read.csv("configFiles/zergUnits.csv", stringsAsFactors = FALSE)
    terranUnits <- read.csv("configFiles/terranUnits.csv", stringsAsFactors = FALSE)
    protossUnits <- read.csv("configFiles/protossUnits.csv", stringsAsFactors = FALSE)
    
    list(zergUnits, terranUnits, protossUnits)
}
