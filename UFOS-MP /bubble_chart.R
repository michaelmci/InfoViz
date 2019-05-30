library(plotly)
library(dplyr)

airports <- read.csv("airport-codes.csv")

airports <- airports[which(airports$iso_country %in% "US"),]
airports <- airports[which(airports$type %in% c("small_airport", "medium_airport", "large_airport")),]
airports <- airports[,c(2,3,7,12)]
airports$type <- droplevels(airports$type)
airports$iso_region <- droplevels(airports$iso_region)
airports$iso_region <- substring(airports$iso_region, 4)
airports$iso_region <- sapply(airports$iso_region, tolower)

'%ni%' <- Negate('%in%')
airports <- airports[which(airports$iso_region %ni% "u-a"),]
airports$iso_region <- as.factor(airports$iso_region)

airports_per_state <- airports %>%
  group_by(iso_region) %>%
  summarise(no_airports = n())

names(airports_per_state)[1] <- "state"

ufos <- read.csv("ufos.csv")

sights_per_state <- ufos %>%
  group_by(state) %>%
  summarise(no_sights = n())

sight_duration_per_state <- ufos %>%
  group_by(state) %>%
  summarise(avg_duration_sec = median(duration..seconds., na.rm = T))

dataset <- merge(airports_per_state, sight_duration_per_state, by = "state")
dataset <- merge(dataset, sights_per_state, by = "state")

plot_ly(dataset, x = ~no_sights, y = ~no_airports, text = ~state, type = 'scatter', mode = 'markers', color = ~avg_duration_sec, colors = 'Reds',
        marker = list(size = ~(avg_duration_sec/8), opacity = 10)) %>%
  layout(title = 'Relation between UFO sights and the number of airports per state',
         xaxis = list(showgrid = FALSE),
         yaxis = list(showgrid = FALSE))
