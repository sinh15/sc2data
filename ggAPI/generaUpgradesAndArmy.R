## ======================================= ##
## FUCTIONS TO CREATE UPGRADE & ARMY LISTs ##
## ======================================= ##
#ALL UPGRADES & UNITS => Zerg/terran/protoss
createUpgradesAndArmy <- function() {
    zergJSON <-  "https://gg2-matchblobs-prod.s3.amazonaws.com/6345542"
    terranJSON <-  "https://gg2-matchblobs-prod.s3.amazonaws.com/6345614"
    protossJSON <-  "https://gg2-matchblobs-prod.s3.amazonaws.com/6345638"
    
    zergJSON <- fromJSON(zergJSON)
    terranJSON <- fromJSON(terranJSON)
    protossJSON <- fromJSON(protossJSON)
    
    
    ## READ UPGRADES
    zergUpgrades <-  sort(zergJSON[[8]][[1]][, 1])
    terranUpgrades <- sort(terranJSON[[8]][[1]][, 1])
    protossUpgrades <- sort(protossJSON[[8]][[1]][, 1])
    
    ## FUSION UPGRADES NAMES
    upgrades <- as.data.frame(c(zergUpgrades, terranUpgrades, protossUpgrades))
    names(upgrades) <- "upgrades"
    upgrades$upgrades <- as.character(upgrades$upgrades)
    
    ## Save upgrades file
    write.csv(upgrades, file = "configFiles/upgrades.csv", row.names = FALSE)
    
    
    ## READ UNITS
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
    upgrades <- read.csv("configFiles/upgrades.csv", stringsAsFactors = FALSE)
    
    upgradesx
}

readUnitsLists <- function() {
    zergUnits <- read.csv("configFiles/zergUnits.csv", stringsAsFactors = FALSE)
    terranUnits <- read.csv("configFiles/terranUnits.csv", stringsAsFactors = FALSE)
    protossUnits <- read.csv("configFiles/protossUnits.csv", stringsAsFactors = FALSE)
    
    list(zergUnits, terranUnits, protossUnits)
}



