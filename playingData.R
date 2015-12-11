## Loading Required Libraries
#Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_66')
library(xlsx)
library(dplyr)


## READ AND TRANSFORM
dd <- read.xlsx("data.xlsx", 1)
dd[, "name"] <- as.character(dd[, "name"])
names(dd)

## CHECK MEAN, MIN, MAX minearls
mean(dd[dd$transformation == 0 & dd$type == "unit", "minerals"])
min(dd[dd$transformation == 0 & dd$type == "unit", "minerals"])
max(dd[dd$transformation == 0 & dd$type == "unit", "minerals"])

## Play with NA columns and intersects
x <- dd[!is.na(dd$airAttack), "name"]
y <- dd[!is.na(dd$groundAttack), "name"]
z <- Reduce(intersect, list(x, y))

groundDPS <- dd$groundAttack*dd$gaMultiplier/dd$groundCD
airDPS <- dd$airAttack*dd$aaMultiplier/dd$airCD
res <- rbind(dd$name, groundDPS, airDPS)


## Using DPLYR: Select
x <- select(dd, name, groundAttack, airAttack)
x <- select(dd, c(name, groundAttack, airAttack))
x <- c(1, 9, 17, 25, 33)
x <- selct(dd, x)

## Using DPLYR: Filter
x <- filter(dd, race == "zerg" & type == "unit" & transformation == 0)

## Using DPLYR: Arrange
x <- filter(dd, race == "zerg" & type == "unit" & transformation == 0) %>% 
     arrange(desc(groundAttack), desc(airAttack))

x <- select(dd, 1:11) %>%
     filter(race ==  "zerg" & type == "unit" & transformation == 0) %>%
     arrange(desc(minerals), desc(gas), desc(buildTime), desc(supply))

## Using DPLYR: Rename a column
x <- rename(dd, RACE = race, TYPE = type)

## Using DPLYR: Mutate
x <- mutate(dd, groundDPS = groundAttack*gaMultiplier/groundCD, 
                airDPS = airAttack*aaMultiplier/groundCD)

## Using DPLYR: Transmute (same as mutate but drops not mutated columns)
x <- transmute(dd, groundDPS = groundAttack*gaMultiplier/groundCD)


## Using DPLYR: Group By & Summarize (it drops colums not used)
x <- select(dd, 1:8) %>%
     group_by(minerals) %>%
     summarize(avgGasCost = mean(gas, na.rm = TRUE), 
               avgBuildTime = mean(buildTime, na.rm = TRUE))

