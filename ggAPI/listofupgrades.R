## =============================== ##
## FUCTIONS TO CREATE UPGRADE LIST ##
## =============================== ##
#ALL UPGRADES & UNITS => Zerg/terran/protoss
createUpgradesList <- function() {
    zergJSON <-  "https://gg2-matchblobs-prod.s3.amazonaws.com/6345542"
    terranJSON <-  "https://gg2-matchblobs-prod.s3.amazonaws.com/6345614"
    protossJSON <-  "https://gg2-matchblobs-prod.s3.amazonaws.com/6345638"
    
    zergJSON <- fromJSON(zergJSON)
    terranJSON <- fromJSON(terranJSON)
    protossJSON <- fromJSON(protossJSON)
    
    
    ## ZERG UPGRADES LIST
    zergUpgrades <-  sort(zergJSON[[8]][[1]][, 1])
    
    ## TERRAN UPGRADES LIST
    terranUpgrades <- sort(terranJSON[[8]][[1]][, 1])
    
    
    ## PROTOSS UPGRADES LIST
    protossUpgrades <- sort(protossJSON[[8]][[1]][, 1])
    
    ## FUSION UPGRADES NAMES
    upgrades <- as.data.frame(c(zergUpgrades, terranUpgrades, protossUpgrades))
    names(upgrades) <- "upgrades"
    upgrades$upgrades <- as.character(upgrades$upgrades)
    
    ## Save upgrades file
    write.csv(upgrades, file = "configFiles/upgrades.csv", row.names = FALSE)
}

## =============================== ##
## FUCTIONS TO READ UPGRADE LIST   ##
## =============================== ##
readUpgradesList <- function() {
    upgrades <- read.csv("configFiles/upgrades.csv", stringsAsFactors = FALSE)
    
    upgrades
}

