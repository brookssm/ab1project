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
  titlePanel("Shitstorm"),
  
  tabsetPanel(
    tabPanel("About",
      p("By Seth Brooks, Sophia Thurston, Miles Goodner, Edward Wei"),
      p("Visualizations and summaries mostly centered around bus data from the Puget Sound OneBusAway. Questions we aimed to answer were"),
      ul(
        li("What is the relationship between crime rates and access to transportation?"),
        li("What is the relationship between racial demographics and access to transportation?"),
        li("What is the density of bus stops in different socioeconomic areas?"),
        li("What neighborhoods have the quickest and most frequent connections to University District?")
      )
    ),

    tabPanel("Bus Stop Visualization", fluid = TRUE,
             sidebarLayout(
               sidebarPanel(h3("Bus Stop Visualizer"),
                            p("Here you can view all the bus stops that will get you on
                              a bus to University District without a transfer. The stops can 
                              be filtered by the latitude, longitude, and transit agency. Points on the map represent different bus stops 
                              and the colors indicate the transit agency the route belongs to. The stops can be clicked to 
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
                                        value = range_lon, step = 0.001),
                 hr(),
                 p(tags$em("Sources")),
                 p(tags$em("http://api.pugetsound.onebusaway.org/", 
                           "https://github.com/seattleio/seattle-boundaries-data"))),
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
                 leafletOutput("crime_map"),
                 p("This map displays the relationship between crime rates in
                   Seattle and the bus stops that lead to University District.
                   These offenses were reported within the last three months
                   and they are represented by the red spots on the map. The
                   blue spots represent the bus stops. When clicking on the crimes,
                   the offense and the date reported appears. When clicking on
                   bus stops, the agency and route ID appears. The map can be be
                   filtered by the type of offense commited."))
             )
    )
  )
)
>>>>>>> 
