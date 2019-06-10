library(shiny)
library(mapproj)
library(maps)
library(dplyr)
library(shinyalert)
library(plotly)

source("helpers.R")
ufos.grouped <- read.csv("groupedByState.csv", check.names = FALSE)


shinyServer(function(input, output) {
  
  output$ufos <- DT::renderDataTable(
    DT::datatable(na.omit(read.csv("ufos.csv")), options = list(pageLength = 10), rownames = FALSE)
  )
  
  output$usairports <- DT::renderDataTable(
    DT::datatable(read.csv("airport-codes.csv"), options = list(pageLength = 10), rownames = FALSE)
  )
  
  output$map <- renderPlot({
    
    data <- switch(input$var,
                   "Percent All" = ufos.grouped$all,
                   "Percent Changing" = ufos.grouped$changing,
                   "Percent Chevron" = ufos.grouped$chevron,
                   "Percent Cigar" = ufos.grouped$cigar,
                   "Percent Circle" = ufos.grouped$circle,
                   "Percent Cone" = ufos.grouped$cone,
                   "Percent Cross" = ufos.grouped$cross,
                   "Percent Cylinder" = ufos.grouped$cylinder,
                   "Percent Diamond" = ufos.grouped$diamond,
                   "Percent Disk" = ufos.grouped$disk,
                   "Percent Egg" = ufos.grouped$egg,
                   "Percent Fireball" = ufos.grouped$fireball,
                   "Percent Flash" = ufos.grouped$flash,
                   "Percent Formation" = ufos.grouped$formation,
                   "Percent Light" = ufos.grouped$light,
                   "Percent Other" = ufos.grouped$other,
                   "Percent Oval" = ufos.grouped$oval,
                   "Percent Rectangle" = ufos.grouped$rectangle,
                   "Percent Sphere" = ufos.grouped$sphere,
                   "Percent Teardrop" = ufos.grouped$teardrop,
                   "Percent Triangle" = ufos.grouped$triangle,
                   "Percent Unknown" = ufos.grouped$unknown)
    
    color <- switch(input$var,
                    "Percent All" = "blue",
                    "Percent Changing" = "darkblue",
                    "Percent Chevron" = "darkgreen",
                    "Percent Cigar" = "darkmagenta",
                    "Percent Circle" = "darkorange2",
                    "Percent Cone" = "darkorchid",
                    "Percent Cross" = "darkred",
                    "Percent Cylinder" = "darkslateblue",
                    "Percent Diamond" = "darkslategray",
                    "Percent Disk" = "deeppink3",
                    "Percent Egg" = "gray0",
                    "Percent Fireball" = "goldenrod4",
                    "Percent Flash" = "olivedrab",
                    "Percent Formation" = "palevioletred3",
                    "Percent Light" = "gold",
                    "Percent Other" = "turquoise4",
                    "Percent Oval" = "steelblue4",
                    "Percent Rectangle" = "black",
                    "Percent Sphere" = "tomato4",
                    "Percent Teardrop" = "skyblue3",
                    "Percent Triangle" = "purple3",
                    "Percent Unknown" = "lightseagreen")
    legend <- switch(input$var, 
                     "Percent All" ="% UFO Sighs",
                     "Percent Changing" = "% Changing",
                     "Percent Chevron" = "% Chevron", 
                     "Percent Cigar" = "% Cigar",
                     "Percent Circle" = "% Circle",
                     "Percent Cone" = "% Cone",
                     "Percent Cross" = "% Cross",
                     "Percent Cylinder" = "% Cylinder",
                     "Percent Diamond" = "% Diamond",
                     "Percent Disk" = "% Disk",
                     "Percent Egg" = "% Egg",
                     "Percent Fireball" = "% Fireball",
                     "Percent Flash" = "% Flash",
                     "Percent Formation" = "% Formation",
                     "Percent Light" = "% Light",
                     "Percent Other" = "% Other",
                     "Percent Oval" = "% Oval",
                     "Percent Rectangle" = "% Rectangle",
                     "Percent Sphere" = "% Sphere",
                     "Percent Teardrop" = "% Teardrop",
                     "Percent Triangle" = "% Triangle",
                     "Percent Unknown" = "% Unknown")
    
    
    percent_map(data, color, legend, input$range[1], input$range[2])
    
  })
  
  dataset.heatmap.1 <- reactive({
    
    dataset <- read.csv("ufos.csv")
    year <- format(as.POSIXct(dataset[,8]), "%Y")
    month <- format(as.POSIXct(dataset[,8]), "%m")
    day <- format(as.POSIXct(dataset[,8]), "%d")
    
    dataset <- cbind(dataset, year, month, day)
    
    temp <- dataset %>%
      group_by(year, month, day) %>%
      summarise(event_count = n())
    
    
    
    x <- input$radio1
    data <- temp[which(temp$year %in% x),]
    return(data)
    
  })
  
  output$heatmap1 <- renderPlotly({
    
    x <- list(
      title = "Day"
    )
    y <- list(
      title = "Month"
    ) 
    plot_ly(
      x = dataset.heatmap.1()$day, 
      y = dataset.heatmap.1()$month,
      z = dataset.heatmap.1()$event_count, 
      
      type = "heatmap"
    )%>% layout(title = "Heatmap of UFO Sightings in the US", xaxis = x, yaxis = y)
    
  })
  
  dataset.heatmap.2 <- reactive({
    
    dataset <- read.csv("ufos.csv")
    year <- format(as.POSIXct(dataset[,8]), "%Y")
    month <- format(as.POSIXct(dataset[,8]), "%m")
    hour <- format(as.POSIXct(dataset[,8]), "%H")
    
    dataset <- cbind(dataset, year, month, hour)
    
    temp <- dataset %>%
      group_by(year, month, hour) %>%
      summarise(event_count = n())
    
    x <- input$radio2
    data <- temp[which(temp$year %in% x),]
    
    # substitute missing values with zeros (a missing value corresponds to an event that never took place)
    for (m in c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12")){
      for (h in c("00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23")){
        row_to_find <- data.frame(year=x, month=m, hour=h)
        if(nrow(merge(row_to_find,data))==0){
          data[nrow(data) + 1,] = list(x, m, h, 0)
        }
      }
    }
    
    return(data)
    
  })
  output$heatmap2 <- renderPlotly({
    
    x <- list(
      title = "Hour"
    )
    y <- list(
      title = "Month"
    ) 
    plot_ly(
      x = dataset.heatmap.2()$hour, 
      y = dataset.heatmap.2()$month,
      z = dataset.heatmap.2()$event_count,
      
      type = "heatmap"
    )%>% layout(title = "Heatmap of UFO Sightings in the US", xaxis = x, yaxis = y)
    
    
  })
  
  dataset.bubble <- reactive({
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
      summarise(med_duration_sec = median(duration..seconds., na.rm = T))
    
    dataset <- merge(airports_per_state, sight_duration_per_state, by = "state")
    dataset <- merge(dataset, sights_per_state, by = "state")
    
    return(dataset)
  })
  
  output$bubble_chart <- renderPlotly({
    
    plot_ly(dataset.bubble(), x = ~no_sights, y = ~no_airports, text = ~state, type = 'scatter', mode = 'markers', color = ~med_duration_sec, colors = 'Reds',
            marker = list(size = ~(med_duration_sec/8), opacity = 10)) %>%
      layout(title = 'Relation between UFO sights and the number of airports per state',
             xaxis = list(showgrid = FALSE),
             yaxis = list(showgrid = FALSE))
  })
  
})

