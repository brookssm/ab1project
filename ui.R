library(shiny)
library(dplyr)
library(leaflet)
library(geojsonio)
library(ggplot2)

source("busstopmap.R")
source("crimedata.R")
range_lat <- range(all_stops$lat)
range_lon <- range(all_stops$lon)
crime_data <- read.csv("./data/police_report_data.csv")

ecda <- read.csv("./data/ednalysis.csv")
months <- as.numeric(range(ecda$months_after))


ui <- fluidPage(
  tabsetPanel(
    tabPanel("Bus Stop Map", fluid = TRUE,
             sidebarLayout(
               sidebarPanel(h3("Bus Stop Viewer"),
                            p("Here you can view all the bus stops that will get you on
                              a bus to University District without a transfer. The stops can 
                              be filtered by the latitude, longitude, and transit agency. The 
                              spots on the map represent different bus stops and the colors indicate
                              the transit agency the route belongs to. The stops can be clicked to 
                              show the route and transit agency associated with them. Additionally, the map
                              can be clicked to show you what neighborhood you are in. "),
                            hr(),
                 checkboxGroupInput("agency", "Select Transit Agency:", 
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
