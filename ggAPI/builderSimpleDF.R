## ============================== ##
## CREATING SINGLE INFO DATAFRAME ##
## ============================== ##
createSimpleDF <- function() {
    df <- data.frame()
    ## Return data frame
    df
}

## ============================== ##
## SIMPLE DF: Adding Row          ##
## ============================== ##
extractSimpleGameDetails <- function (gameJSON) {
    ## Create Game DF (single row)
    gameDF <- data.frame(matrix(ncol = 0, nrow = 1), row.names = NULL)
    entities <- gameJSON[["entities"]]
    
    ## ADD: Game parameters to df
    gameDF$gameID <- gameJSON[["id"]]
    gameDF$gameDate <- as.Date(gameJSON[["ended_at"]])
    gameDF$gameCategory <- as.factor(gameJSON[["category"]])
    gameDF$gameType <- as.factor(gameJSON[["game_type"]])
    gameDF$gameDuration <- gameJSON[["duration_seconds"]]
    gameDF$gameDurationM <- round(gameJSON[["duration_seconds"]]/1.4/60, 2)
    gameDF$gameMapID <- gameJSON[["map"]][["id"]]
    gameDF$gameMapName <- as.factor(gameJSON[["map"]][["name"]])
    gameDF$replayID <- gameJSON[["replays"]][, 1]
    gameDF$replayHash <- gameJSON[["replays"]][, 2]
    gameDF$replayURL <- gameJSON[["replays"]][, 3]
    gameDF$matchup <- as.factor(computeMatchup(entities[, "race"][1], entities[, "race"][2]))
    gameDF$p1_race <- as.factor(entities[, "race"][1])
    gameDF$p2_race <- as.factor(entities[, "race"][2])
    gameDF$p1_win <- ifelse(entities[, "win"][1], 1, 0)
    gameDF$p2_win <- ifelse(entities[, "win"][2], 1, 0)
    gameDF$p1_ID <- entities[, "identity"][, "id"][1]
    gameDF$p2_ID <- entities[, "identity"][, "id"][2]
    gameDF$p1_bnetID <- entities[, "identity"][, "bnet_id"][1]
    gameDF$p2_bnetID <- entities[, "identity"][, "bnet_id"][2]
    gameDF$p1_name <- as.factor(entities[, "identity"][, "name"][1])
    gameDF$p2_name <- as.factor(entities[, "identity"][, "name"][2])
    gameDF$p1_region <- as.factor(entities[, "identity"][, "gateway"][1])
    gameDF$p2_region <- as.factor(entities[, "identity"][, "gateway"][2])
    gameDF$p1_league <- entities[, "identity"][, "current_league_1v1"][1]
    gameDF$p2_league <- entities[, "identity"][, "current_league_1v1"][2]
    gameDF$p1_apm <- entities[["apm"]][1]
    gameDF$p2_apm <- entities[["apm"]][2]
    gameDF$p1_spending_skill <- entities[["spending_skill"]][1]
    gameDF$p2_spending_skill <- entities[["spending_skill"]][2]
    gameDF$p1_spending_quotient <- entities[["spending_quotient"]][1]
    gameDF$p2_spending_quotient <- entities[["spending_quotient"]][2]
    gameDF$p1_macro <- entities[["race_macro"]][1]
    gameDF$p2_macro <- entities[["race_macro"]][2]
    gameDF$p1_creep <- entities[["max_creep_spread"]][1]
    gameDF$p2_creep <- entities[["max_creep_spread"]][2]
    gameDF$p1_avgUnspent <- entities[["summary"]][, "average_unspent_resources"][1]
    gameDF$p2_avgUnspent <- entities[["summary"]][, "average_unspent_resources"][2]
    gameDF$p1_avg_collected <- entities[["summary"]][, "resource_collection_rate"][1]
    gameDF$p2_avg_collected <- entities[["summary"]][, "resource_collection_rate"][2]
    gameDF$p1_workers <- entities[["summary"]][, "workers_created"][1]
    gameDF$p2_workers <- entities[["summary"]][, "workers_created"][2]
    gameDF$p1_units <- entities[["summary"]][, "units_trained"][1]
    gameDF$p2_units <- entities[["summary"]][, "units_trained"][2]
    gameDF$p1_units_killed <- entities[["summary"]][, "killed_unit_count"][1]
    gameDF$p2_units_killed <- entities[["summary"]][, "killed_unit_count"][2]
    gameDF$p1_buildings <- entities[["summary"]][, "structures_built"][1]
    gameDF$p2_buildings <- entities[["summary"]][, "structures_built"][2]
    gameDF$p1_buildings_razed <- entities[["summary"]][, "structures_razed_count"][1]
    gameDF$p2_buildings_razed <- entities[["summary"]][, "structures_razed_count"][2]
    
    ## RETURN: gameDF
    gameDF
}

## ============================== ##
## CRAETE MATCHUP                 ##
## ============================== ##
computeMatchup <- function(race1, race2) {
    if(race1 <= race2) matchup = paste0(race1, "v", race2)
    else matchup = paste0(race2, "v", race1)
    
    return(matchup)
}