library(tidyverse)
library(plotly)

dataset <- read.csv("ufos.csv")

#data preprocessing
year <- format(as.POSIXct(dataset[,8]), "%Y")
month <- format(as.POSIXct(dataset[,8]), "%m")
day <- format(as.POSIXct(dataset[,8]), "%d")

dataset <- cbind(dataset, year, month, day)

temp <- dataset %>%
  group_by(year, month, day) %>%
  summarise(event_count = n())

x <- "2013"
data <- temp[which(temp$year %in% x),]

p <- plot_ly(
  x = data$day, 
  y = data$month,
  z = data$event_count, 
  type = "heatmap"
)

p
