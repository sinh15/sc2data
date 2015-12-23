gameJSON <- "http://api.ggtracker.com/api/v1/matches/6341740.json"
gameJSON <- fromJSON(gameJSON)

adJSON <-  "https://gg2-matchblobs-prod.s3.amazonaws.com/6341740"
adJSON <- fromJSON(adJSON)

int <- array(1:length(adJSON[["Lost"]][[1]]))
int <- apply(int, 1, function(i) ((i-1)*10))


## WORKERS
names(adJSON[[9]])
View(mutate(as.data.frame(adJSON[[9]][[1]]), time = int) %>% filter(time == 60 | time == 300 | time == 600))
View(mutate(as.data.frame(adJSON[[9]][[2]]), time = int) %>% filter(time == 60 | time == 300 | time == 600))

## MINERALS COLLECTION RATE
names(adJSON[[12]])
View(mutate(as.data.frame(adJSON[[12]][[1]]), time = int) %>% filter(time == 60 | time == 300 | time == 600))
View(mutate(as.data.frame(adJSON[[12]][[2]]), time = int) %>% filter(time == 60 | time == 300 | time == 600))

## VESPENE COLLECTION RATE
names(adJSON[[17]])
View(mutate(as.data.frame(adJSON[[17]][[1]]), time = int) %>% filter(time == 60 | time == 300 | time == 600))
View(mutate(as.data.frame(adJSON[[17]][[2]]), time = int) %>% filter(time == 60 | time == 300 | time == 600))

## CURRENT MINERALS
names(adJSON[[11]])
View(mutate(as.data.frame(adJSON[[11]][[1]]), time = int) %>% filter(time == 60 | time == 300 | time == 600))
View(mutate(as.data.frame(adJSON[[11]][[2]]), time = int) %>% filter(time == 60 | time == 300 | time == 600))

## CURRENT GAS
names(adJSON[[15]])
View(mutate(as.data.frame(adJSON[[15]][[1]]), time = int) %>% filter(time == 60 | time == 300 | time == 600))
View(mutate(as.data.frame(adJSON[[15]][[2]]), time = int) %>% filter(time == 60 | time == 300 | time == 600))

## SUPPLY
names(adJSON[[19]])
View(mutate(as.data.frame(adJSON[[19]][[1]]), time = int) %>% filter(time == 60 | time == 300 | time == 600))
View(mutate(as.data.frame(adJSON[[19]][[2]]), time = int) %>% filter(time == 60 | time == 300 | time == 600))

## APM
paste(gameJSON[["entities"]][, "identity"][, "id"][1], gameJSON[["entities"]][, "identity"][, "id"][2])
x <- as.data.frame(gameJSON[["entities"]][, "data"][, 1])
View(x[c(1,5,10), ])




## TIME APPROXIMATIONS
214.29%/%60
214.29%%60

428.57%/%60
428.57%%60

