## COLORS IN R
## http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf


## PLOT TRY
with(dd, plot(
    ifelse(p1_name == "sinH" & p1_win == 1, p1_workers, p2_workers), 
    ifelse(p1_name == "sinH", p1_avgUnspent, p2_avgUnspent),
    col = "blue"))
with(dd, points(
    ifelse(p1_name != "sinH", p1_workers, p2_workers),
    ifelse(p1_name != "sinH", p1_avgUnspent, p2_avgUnspent),
    col = "red"
))

##?Devices (check availble devices)
x <- filter(df, name == "sinH")
hist(x$spending_quotient)

with(x, plot(spending_quotient, minutes))



## GET WIN-RATIO BY MATCHUP GIVEN A CERTAIN USER NAME
x <- filter(dd, p1_name == "sinH" | p2_name == "sinH") %>%
     mutate(result = ifelse(p1_name == "sinH", p1_win, p2_win)) %>%
     group_by_("matchup") %>% summarize(winratio = mean(result)*100)

## GET WIN_RATIO BY MAP GIVEN A CERTAIN USER NAME
x <- filter(dd, p1_name == "sinH" | p2_name == "sinH") %>% group_by(gameMapName) %>% 
     mutate(tGames = length(gameMapName), results = ifelse(p1_name == "sinH", p1_win, p2_win)) %>%
     summarise(winratio = mean(results)*100, tGames = max(tGames)) %>%
     arrange(desc(tGames))

## GET WIN RATIO BY MATCHUP AND MAP GIVEN A CERTAIN USER NAME
x <- filter(dd, p1_name == "sinH" | p2_name == "sinH") %>% group_by(gameMapName, matchup) %>% 
     mutate(tGames = length(gameMapName), results = ifelse(p1_name == "sinH", p1_win, p2_win)) %>%
     summarise(winratio = mean(results)*100, tGames = max(tGames)) %>%
     arrange(gameMapName, matchup, desc(tGames))

## cheating the functions of dplyr
y <- as.array(c("matchup", "gameMapName"))
x <- apply(y, 1, function(elt) group_by_(x, elt, add = TRUE))
x <- x[["last position"]]
x <- "continue dplyr functions"


## minerals_cr & minerals split by win / defeat
x <- filter(dd, p1_name == "sinH" | p2_name == "sinH") %>%
     mutate(pWin = ifelse(p1_name == "sinH", p1_win, p2_win)) %>%
     filter(pWin == 1) %>% select(gameID)
y <- filter(dd, p1_name == "sinH" | p2_name == "sinH") %>%
    mutate(pWin = ifelse(p1_name == "sinH", p1_win, p2_win)) %>%
    filter(pWin == 0) %>% select(gameID)

xx <- filter(df, gameID %in% x[, 1])
yy <- filter(df, gameID %in% y[, 1])

with(xx, plot(minerals_cr, minerals, col = "green"))
with(yy, points(minerals_cr, minerals, col = "red"))


## supply.currentsupply by minutes and win/defeat
x <- filter(dd, p1_name == "sinH" | p2_name == "sinH") %>%
     mutate(pWin = ifelse(p1_name == "sinH", p1_win, p2_win)) %>%
     filter(pWin == 1) %>% select(gameID)

y <- filter(dd, p1_name == "sinH" | p2_name == "sinH") %>%
    mutate(pWin = ifelse(p1_name == "sinH", p1_win, p2_win)) %>%
    filter(pWin == 0) %>% select(gameID)

x <- filter(df, gameID %in% x[, 1])
y <- filter(df, gameID %in% y[, 1])

with(x, plot(minutes, supply.currentSupply, col = "blue"))
with(y, points(minutes, supply.currentSupply, col = "red"))


## plot winratio on interval of game
x <- mutate(dd, interval = (gameDuration%/%300)*5, pWin = ifelse(p1_name == "sinH", p1_win, p2_win)) %>%
     group_by(interval) %>% summarise(winratio = mean(pWin))
with(x, plot(interval, winratio, type="o"))
with(x, lines(interval, winratio))

## spending quotient by minute based on matchup
xTerran <- filter(dd, p1_name == "sinH" | p2_name == "sinH", matchup == "TvZ") %>%
           select(gameID)
xProtoss <- filter(dd, p1_name == "sinH" | p2_name == "sinH", matchup == "PvZ") %>%
            select(gameID)
xZerg <- filter(dd, p1_name == "sinH" | p2_name == "sinH", matchup == "ZvZ") %>%
         select(gameID)

xTerran <- filter(df, gameID %in% xTerran[, 1])
xProtoss <- filter(df, gameID %in% xProtoss[, 1])
xZerg <- filter(df, gameID %in% xZerg[, 1])

with(xTerran, plot(minutes, spending_quotient, col = "blue"))
with(xProtoss, points(minutes, spending_quotient, col = "darkgoldenrod1"))
with(xZerg, points(minutes, spending_quotient, col = "firebrick"))

## check sepnding quotient based no matchup on games lower than 15 minutes
## spending_quotient brakes: +90, 70-89, - 70
x <- filter(dd, gameDuration <= 15*60) %>% select(gameID, matchup)
xx <- filter(df, gameID %in% x[, 1]) %>%
     mutate(interval = ifelse(spending_quotient > 90, 90, ifelse(spending_quotient > 70, 70, 50))) %>%
     mutate(matchup = x[match(gameID, x[, 1]), 2]) %>% group_by(interval) %>%
     mutate(lengthInterval = length(interval)) %>% group_by(matchup, add = TRUE) %>%
     mutate(lengthMatchup = length(matchup)) %>% summarise(matchup_density = sum(lengthMatchup)/sum(lengthInterval))
with(subset(xx, matchup == "TvZ"), plot(interval, matchup_density, col = "blue", type = "l", ylim=c(0, 0.7)))
with(subset(xx, matchup == "PvZ"), points(interval, matchup_density, col = "darkgoldenrod1", type = "l", ylim=c(0, 0.7)))
with(subset(xx, matchup == "ZvZ"), points(interval, matchup_density, col = "firebrick", type = "l", ylim=c(0, 0.7)))




## PLAYING WITH GGPLOT2
## spending quotient and bases.num_bases
x <- mutate(dd, pWin = ifelse(p1_name == "sinH", p1_win, p2_win)) %>%
     select(gameID, pWin)
win <- filter(x, pWin == 1)

y <- filter(df, name == "sinH") %>% mutate(result = ifelse(gameID %in% win[, 1], 1, 0))
qplot(bases.num_bases, spending_quotient, data = y, geom = c("point", "smooth"))

## display relation workers and mienrals collection rate
x <- filter(df, name == "sinH")
qplot(workers, minerals_cr, data = x, geom = c("point", "smooth"))

## workers by mintue and relation win lose
x <- mutate(dd, pWin = ifelse(p1_name == "sinH", p1_win, p2_win)) %>%
     select(gameID, pWin)
y <- filter(df, name == "sinH") %>% mutate(result = ifelse(gameID %in% win[, 1], 1, 0))
qplot(minutes, workers, data = y, col = result)

## sspending quotient based on matchup
x <- select(dd, gameID, matchup)
xTerran <- filter(x, matchup == "TvZ") %>% select(gameID)
xProtoss <- filter(x, matchup == "PvZ") %>% select(gameID)
xZerg <- filter(x, matchup == "ZvZ") %>% select(gameID)
y <- filter(df, name == "sinH") %>% 
     mutate(matchup = ifelse(gameID %in% xTerran[, 1], "TvZ", ifelse(gameID %in% xProtoss[, 1], "PvZ", "ZvZ")))

qplot(spending_quotient, data = y, fill = matchup, binwidth = 2)

## trying qplot only one variable: FACTOR -> barplot
qplot(matchup, data = dd)

## trying qplot only one variable: NUMERIC -> histogram
qplot(supply.currentSupply, data = df)

## BOXPLOT: numerical vs categorical
x <- mutate(dd, pSpending = ifelse(p1_name=="sinH", p1_spending_quotient, p2_spending_quotient))
qplot(matchup, pSpending, data = x, geom = "boxplot")

