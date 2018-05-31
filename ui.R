library(shiny)
source("busstopmap.R")

ui <- fluidPage(
  tabsetPanel(
    tabPanel("Bus Stops Map", fluid = TRUE,
             sidebarLayout(
               sidebarPanel(selectInput("agency", "Select Transit Agency", 
                                        choices = all_stops$agency, selected = "")),
               mainPanel(
                 leafletOutput("stops"),
                 p(),
                 actionButton("recalc", "New points")
               )
             )
    ),
    
    tabPanel("plot", fluid = TRUE,
             sidebarLayout(
               sidebarPanel(sliderInput("year", "Year:", min = 1968, 
                                        max = 2009, value = 2009, sep='')),
               mainPanel(fluidRow(   
               )
               )
             )
    )
  )
)
