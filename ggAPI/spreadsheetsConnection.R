## ============================== ##
## FORMAT: Factoring Columns      ##
## ============================== ##
factorColumnsSimpleDF <- function(dd) {
    dd[[2]] <- as.Date(dd[[2]])
    dd[[3]] <- as.factor(dd[[3]])
    dd[[4]] <- as.factor(dd[[4]])
    dd[[8]] <- as.factor(dd[[8]])
    dd[[10]] <- as.factor(dd[[10]])
    dd[[11]] <- as.factor(dd[[11]])
    dd[[12]] <- as.factor(dd[[12]])
    dd[[13]] <- gsub("TRUE", "T", dd[[13]])
    dd[[14]] <- gsub("TRUE", "T", dd[[14]])
    dd[[13]] <- as.factor(dd[[13]])
    dd[[14]] <- as.factor(dd[[14]])
    dd[[21]] <- as.factor(dd[[21]])
    dd[[22]] <- as.factor(dd[[22]])
    dd[[23]] <- as.factor(dd[[23]])
    dd[[24]] <- as.factor(dd[[24]])
    
    dd
}

## ============================== ##
## FORMAT: Cast to normal DF      ##
## ============================== ##
castNormalDF <- function(dd) {
    col <- dim(dd)[2]
    row <- dim(dd)[1]
    dataFrame <- data.frame(matrix(ncol = col, nrow = row))
    names(dataFrame) <- names(dd)
    for(i in c(1:col)) {
        dataFrame[, i] <- dd[[i]]
    }
    
    dataFrame
}

## ============================== ##
## GET: Simple DF Spreadsheet     ##
## ============================== ##
getSimpleDF <- function() {
    ssURL <- "https://docs.google.com/spreadsheets/d/1kvE8NW4cPP2zZH2IO0VTmzYDR1-fI3uQyqIHMcicB4A/edit#gid=0"
    ss <- gs_url(ssURL, lookup = NULL, visibility = NULL, verbose = TRUE)
    
    ss
}

## ============================== ##
## READ: Full Data Frame from SS  ##
## ============================== ##
readSimpleDataFrameSS <- function () {
    ## get spreadsheet
    ss <- getSimpleDF()    
    
    ## read full contents and transform
    data <- gs_read_csv(ss, "simpleDF_1", verbose = TRUE)
    data <- factorColumnsSimpleDF(data)
    data <- castNormalDF(data)
    
    #return
    data
    
}

## ============================== ##
## PRINT: Full Data Frame to SS   ##
## ============================== ##
writeSimpleDataFrameSS <- function (dd) {
    ## getSheet
    ss <- getSimpleDF()  
    
    ### create empty array to clean sheet data
    data <- gs_read_csv(ss, "simpleDF_1", verbose = TRUE)
    if(length(data) != 0) {
        x <- matrix("", nrow = dim(data)[1]+1, ncol = dim(data)[2])
        gs_edit_cells(ss, "simpleDF_1", input = x, anchor = "A1")

    }
    
    ## send new data to sheet
    gs_edit_cells(ss, "simpleDF_1", input = dd, anchor = "A1")
}

## ============================== ##
## GET/PRINT: Non saved games     ##
## ============================== ##
synchronizeSimpleDF <- function(dd, action) {
    ## getSheet
    ss <- getSimpleDF()
    
    ### get "saved" games
    data <- gs_read(ss, "simpleDF_1", range = cell_cols(1))
    
    ## Compute differences
    
    if(action == "upload") {
        missingGames <- match(dd[, 1], data[[1]])
        uploadGames(dd, missingGames, ss)
    }
    else if(action == "download") {
        missingGames <- match(data[[1]], dd[, 1])
        dd <- downloadGames(dd, missingGames, ss)
        
        dd
    }
}

## ============================== ##
## DOWNLOAD GAMES                 ##
## ============================== ##
downloadGames <- function(dd, missingGames, ss) {
    ## read full contents and transform
    data <- gs_read_csv(ss, "simpleDF_1", verbose = TRUE)
    missing <- which(is.na(missingGames))
    data <- data[missing, ]
    data <- factorColumnsSimpleDF(data)
    data <- castNormalDF(data)
    
    if(length(missing) != 0) {
        for(i in c(1:length(missing))) {
            dd <- rbind(dd, data[missing[i], ])
        }
    }
    
    dd
}

## ============================== ##
## UPLOAD GAMES                   ##
## ============================== ##
uploadGames <- function(dd, missingGames, ss) {
    ## upload games that are missing
    missing <- which(is.na(missingGames))
    for(i in c(1:length(missing))) {
        dd[, "p1_race"] <- as.character(dd[, "p1_race"])
        gs_add_row(ss, "simpleDF_1", input = dd[missing[i], ])
    }
}