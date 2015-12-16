## ============================== ##
## CREATING SINGLE INFO DATAFRAME ##
## ============================== ##
createSimpleDF <- function() {
    df <- data.frame(matrix(ncol = 26, nrow = 0))
    ## Return data frame
    df
}

## ============================== ##
## Cast Date Simple DF            ##
## ============================== ##
castDateSimpleDF <- function(dd) {
    dd[, 2] <- as.Date(dd[, 2])
    ## return data frame
    dd
}

## ============================== ##
## SIMPLE DF: Adding Row          ##
## ============================== ##
addGameSimpleDF <- function (dd, gameJSON) {
    ### get data and create row
    entities <- gameJSON[["entities"]]
    gameDATA <-
        list(
            gameJSON[["id"]],
            gameJSON[["ended_at"]],
            gameJSON[["category"]],
            gameJSON[["game_type"]],
            gameJSON[["duration_seconds"]],
            round(gameJSON[["duration_seconds"]]/60, 2),
            gameJSON[["map"]][["id"]],
            gameJSON[["map"]][["name"]],
            gameJSON[["replays"]][, 1],
            gameJSON[["replays"]][, 2],
            gameJSON[["replays"]][, 3],
            computeMatchup(entities[, "race"][1], entities[, "race"][2]),
            entities[, "race"][1],
            entities[, "race"][2],
            entities[, "win"][1],
            entities[, "win"][2],
            entities[, "identity"][, "id"][1],
            entities[, "identity"][, "id"][2],
            entities[, "identity"][, "bnet_id"][1],
            entities[, "identity"][, "bnet_id"][2],
            entities[, "identity"][, "name"][1],
            entities[, "identity"][, "name"][2],
            entities[, "identity"][, "gateway"][1],
            entities[, "identity"][, "gateway"][2],
            entities[, "identity"][, "current_league_1v1"][1],
            entities[, "identity"][, "current_league_1v1"][2],
            entities[["apm"]][1],
            entities[["apm"]][2],
            entities[["spending_skill"]][1],
            entities[["spending_skill"]][2],
            entities[["spending_quotient"]][1],
            entities[["spending_quotient"]][2],
            entities[["race_macro"]][1],
            entities[["race_macro"]][2],
            entities[["max_creep_spread"]][1],
            entities[["max_creep_spread"]][2],
            entities[["summary"]][, "average_unspent_resources"][1],
            entities[["summary"]][, "average_unspent_resources"][2],
            entities[["summary"]][, "resource_collection_rate"][1],
            entities[["summary"]][, "resource_collection_rate"][2],
            entities[["summary"]][, "workers_created"][1],
            entities[["summary"]][, "workers_created"][2],
            entities[["summary"]][, "units_trained"][1],
            entities[["summary"]][, "units_trained"][2],
            entities[["summary"]][, "killed_unit_count"][1],
            entities[["summary"]][, "killed_unit_count"][2],
            entities[["summary"]][, "structures_built"][1],
            entities[["summary"]][, "structures_built"][2],
            entities[["summary"]][, "structures_razed_count"][1],
            entities[["summary"]][, "structures_razed_count"][2]
        )
    
    ### add row and return
    df <- rbind.data.frame(dd, gameDATA)
    x <- nrow(df)
    names(df) <- 
        c("gameID", "gameDate", "gameCategory", "gameType", "gameDuration", "gameDurationM", "gameMapID",
          "gameMapName", "replayID", "replayHash", "replayURL", "matchup", "p1_race", "p2_race", "p1_win", "p2_win",
          "p1_ID", "p2_ID", "p1_bnetID", "p2_bnetID", "p1_name", "p2_name", "p1_region", "p2_region", "p1_league", "p2_league",
          "p1_apm", "p2_apm", "p1_spending_skill", "p2_spending_skill", "p1_spending_quotient", "p2_spending_quotient", "p1_macro", "p2_macro",
          "p1_creep", "p2_creep", "p1_avgUnspent", "p2_avgUnspent", "p1_avg_collected", "p2_avg_collected",
          "p1_workers", "p2_workers", "p1_units", "p2_units", "p1_units_killed", "p2_units_killed", 
          "p1_buildings", "p2_buildings", "p1_buildings_razed", "p2_buildings_razed")
    
    ## return df
    df
}


## ============================== ##
## CRAETE MATCHUP                 ##
## ============================== ##
computeMatchup <- function(race1, race2) {
    if(race1 <= race2) matchup = paste0(race1, "v", race2)
    else matchup = paste0(race2, "v", race1)
    
    return(matchup)
}