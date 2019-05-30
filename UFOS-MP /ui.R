# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(plotly)
library(shinycssloaders)

sidebar = dashboardSidebar(
  sidebarMenu(
    style = "position: fixed; overflow: visible;",
    menuItem("Welcome!", tabName = "welcome", icon = icon("globe")),
    menuItem("Dataset", tabName = "dataset", icon = icon("fas fa-database")),
    menuItem("Data Exploration", tabName = "data_exploration", icon = icon("fas fa-search"))
  )
  
)
body = dashboardBody(
  tags$head(includeCSS('www/style.css')),
  tags$head(tags$style(HTML('
                            .content-wrapper, .right-side {background-color: white;}
                            '))),
  tabItems( 
    tabItem(tabName = "welcome",
            includeMarkdown("www/welcome.md")
    ),
    tabItem(tabName = "dataset",
            div(
              tabsetPanel(
                type="tabs",
                tabPanel(p(icon("fas fa-table"), "ufos dataset"),
                         fluidRow(DT::dataTableOutput('ufos'))
              ),
              tabPanel(p(icon("fas fa-table"), "Airports dataset"),
                       fluidRow(DT::dataTableOutput('usairports'))
              )
            )
            )
    ),
    tabItem(tabName = "data_exploration",
            div(
              tabsetPanel(
                type="tabs",
                tabPanel(p(icon("fas fa-map-marker"), "Map Visualization"),
                         fluidRow(
                           column(12,h3("Is there any correlation between ....?"), align = "center")
                         ),
                           fluidRow(
                             column(3, box(
                               status = "primary",
                               width = "12",
                               solidHeader = T,
                               helpText("Create demographic maps with information from the 2010 US Census."),
                               selectInput("var",
                                           label= c("Choose the shape to display"),
                                           choices = list ("Percent Changing","Percent Chevron", "Percent Cigar", 
                                                           "Percent Circle", "Percent Cone", "Percent Cross", 
                                                           "Percent Cylinder", "Percent Diamond", "Percent Disk",
                                                           "Percent Egg", "Percent Fireball", "Percent Flash",
                                                           "Percent Formation", "Percent Light", "Percent Other",
                                                           "Percent Oval", "Percent Rectangle", "Percent Sphere",
                                                           "Percent Teardrop","Percent Triangle","Percent Unknown"), 
                                           selected = "Percent Cylinder"),
                               sliderInput("range", 
                                           label="Range of interest:", 
                                           min= 0, max= 100, value = c(0,100))
                             )),
                             column(9, box(
                               status = "primary",
                               width = "12",
                               solidHeader = T,
                               plotOutput("map")
                             ))
                           )
                  ),
                tabPanel(p(icon("fas fa-map"), "Heatmap Visualization"),
                         fluidRow(
                           column(12,h3("Is there any correlation between ....?"), align = "center")
                         ),
                           fluidRow(
                             box(
                               h4("bla bla bla", align = "center"),
                               column(3, radioButtons("radio1", label = h5("Year of appearance:"),
                                                      choices = list("2010" = 2010, "2011" = 2011, "2012" = 2012, "2013" = 2013, "2014" = 2014), 
                                                      selected = 2010)),
                               column(9, withSpinner(plotlyOutput("heatmap1"))),
                               status = "primary",
                               width = "12",
                               solidHeader = T
                             )
                           ),
                         fluidRow(
                           
                           box(
                             h4("bla bla bla", align = "center"),
                             column(3, radioButtons("radio2", label = h5("Year of appearance:"),
                                                    choices = list("2010" = 2010, "2011" = 2011, "2012" = 2012, "2013" = 2013, "2014" = 2014), 
                                                    selected = 2010)),
                             column(9, withSpinner(plotlyOutput("heatmap2"))),
                             status = "primary",
                             width = "12",
                             solidHeader = T
                           )
                         )
                ),
                tabPanel(p(icon("area-chart"), "Bubble Chart Visualization"),
                         fluidRow(
                           column(12,h3("Is there any correlation between ....?"), align = "center")
                         ),
                         fluidRow(
                           column(12, box(
                             status = "primary",
                             width = "12",
                             solidHeader = T,
                             withSpinner(plotlyOutput("bubble_chart"))
                           ))
                           
                         )
                         )
              )
            )
			)
  )
  
  )


header =  dashboardHeader(title = "UFO",
                tags$li(a(onclick = "openTab('welcome')",
                          href = NULL,
                          icon("home"),
                          title = "Homepage",
                          style = "cursor: pointer;"),
                        class = "dropdown",
                        tags$script(HTML("
                                         var openTab = function(tabName){
                                         $('a', $('.sidebar')).each(function() {
                                         if(this.getAttribute('data-value') == tabName) {
                                         this.click()
                                         };
                                         });
                                         }")))
)



shinyUI(
  dashboardPage(
    header,
    sidebar,
    body
  )
  
)