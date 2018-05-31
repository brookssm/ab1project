library(shiny)
library(dplyr)
library(leaflet)
library(geojsonio)

source("busstopmap.R")
source("crimedata.R")
range_lat <- range(all_stops$lat)
range_lon <- range(all_stops$lon)
crime_data <- read.csv("./data/police_report_data.csv")

ui <- fluidPage(
  tabsetPanel(
    tabPanel("Bus Stop Map", fluid = TRUE,
             sidebarLayout(
               sidebarPanel(checkboxGroupInput("agency", "Select Transit Agency:", 
                                        choices = all_stops$agency %>% unique(), 
                                        selected = c("Metro Transit",
                                                     "Sound Transit",
                                                     "Community Transit")),
                            sliderInput('lat_choice', label = "Adjust Latitude:", 
                                        min=range_lat[1], max = range_lat[2], 
                                        value = range_lat, step = 0.001),
                            sliderInput('lon_choice', label = "Adjust Longitude:", 
                                        min=range_lon[1], max = range_lon[2], 
                                        value = range_lon, step = 0.001)),
               mainPanel(
                 leafletOutput("stops"),
                 hr(),
                 dataTableOutput("stops_table")
               )
             )
    ),
    
    tabPanel("Crime Data",
             sidebarLayout(
               sidebarPanel(
                 unique(selectInput("Crime", "Select a Crime",
                                    choices = crime_data$`Offense Type`))
               ),
               mainPanel(
                 leafletOutput("crime_map"))
             )
    )
  )
)
