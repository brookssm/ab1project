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

ui <- fluidPage(
  titlePanel("Public Transportation in Seattle"),
  
  tabsetPanel(
    tabPanel("About",
             sidebarLayout(
               sidebarPanel(
                 h3("Public Transportation in Seattle"),
                 h5(tags$em("by Seth Brooks, Sophia Thurston, Miles Goodner, and Edward Wei")),
                 p(tags$em("To get started, "), "click on one of the tabs or stay on this tab to learn more about
                         what motivated this project.")
                 ),
               mainPanel(
                 h3("What is it?"),
                 p("We asked ourselves a series of questions when starting this project, which
                   included:"),
                 tags$ul(
                   tags$li("What is the relationship between crime rates and access to transportation?"),
                   tags$li("What is the relationship between racial demographics and access to transportation?"),
                   tags$li("What is the density of bus stops in different socioeconomic areas?"),
                   tags$li("What neighborhoods have the quickest and most frequent connections to University District?")),
                   
                 p("In order to answer these questions, we decided to create a series of visualizations
                   that could be flipped through by the user in order to see which variables correlate
                   with density of bus stops. In this version of the app, we created a visualization that allows
                   users to see all of the bus stops in Seattle that will get someone to University District
                   in one ride (i.e. without having to make a transfer). We also created a map that shows these
                   bus stops but with crime data on top, so that the user can see the relationship between crime
                   and density of bus stops."),
               
                 h3("Why?"),
                 p("We created this app because we use public transporation all the time and originally
                   wanted to know more about how UW students get to campus everyday. We wanted to know who 
                   has the most immediate access to UW if they are using public transportation, and then
                   we wanted to see what other factors are related to someone's access to public transportation."),
                
                 h3("How?"),
                 p("We used Leaflet to create high-resolution, interactive maps that can be 
                   zoomed and manipulated. We also used Shiny to create our application. The data we used
                   came from a variety of sources, including OneBusAway, Seattle.gov, and the U.S. Census website."),
                 h3("Sources"),
                 tags$ul(
                   tags$li(a("OneBusAway API",
                             href = "http://developer.onebusaway.org/modules/onebusaway-application-modules/current/api/where/index.html")),
                   tags$li(a("Seattle.io boundary data",
                             href = "https://github.com/seattleio/seattle-boundaries-data")),
                   tags$li(a("Seattle Government Data",
                             href = "https://data.seattle.gov/")),
                   tags$li(a("American Factfinder Census Data",
                             href = "https://factfinder.census.gov/faces/nav/jsf/pages/index.xhtml")),
                   tags$li(a("Sound Transit Open Transit Data GTFS Files",
                             href = "https://www.soundtransit.org/Developer-resources/Data-downloads")),
                   tags$li(a("US Census Cartographic Boundary Shapefiles",
                             href = "https://www.census.gov/geo/maps-data/data/cbf/cbf_tracts.html"))
                 ))
             )
             ),
    
    tabPanel("Bus Stop Visualizer", fluid = TRUE,
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
                 h3("Map"),
                 leafletOutput("stops"),
                 h4("Map Summary"),
                 p("Above you will notice a few things. Of all the agencies serving
                   Seattle, Metro Transit is certainly the most extensive in terms of 
                   access to University District. You will also notice that West Seattle, 
                   South Seattle, and some of North Seattle/Shoreline are barely serviced
                   with good access to University District. The areas with the most direct connections
                   to University District are the neighborhoods immediately surrounding University
                   District and also Downtown Seattle."),
                 hr(),
                 h4("Table"),
                 p("Here you will find the exact coordinates, route number, and agency
                   associated with all the stops displayed above."),
                 dataTableOutput("stops_table")
               )
             )
    ),
    
    tabPanel("Crime Data",
             sidebarLayout(
               sidebarPanel(
                 h3("Crime Data"),
                 p("This map displays the relationship between crime rates in
                   Seattle and the bus stops that lead to University District.
                   These offenses were reported within the last three months
                   and they are represented by the red spots on the map. The
                   blue spots represent the bus stops. When clicking on the crimes,
                   the offense and the date reported appears. When clicking on
                   bus stops, the agency and route ID appears. The map can be be
                   filtered by the type of offense commited."),
                 #selectInput("Crime", "Select a Crime",
                             #choices = crime_data$`Offense Type`)
                 checkboxGroupInput("Month", "Select a Month",
                                    choices = crime_data$Month)
                 
               ),
               mainPanel(
                 leafletOutput("crime_map")
               )
             )
    )
  )
)

