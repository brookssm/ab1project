library(shiny)
library(dplyr)
library(leaflet)
library(geojsonio)
library(ggplot2)

source("busstopmap.R")
source("crimedata.R")
# defines range for long and lat
range_lat <- range(all_stops$lat)
range_lon <- range(all_stops$lon)
crime_data <- read.csv("./data/police_report_data.csv", stringsAsFactors=FALSE, fileEncoding="latin1")
ecda <- read.csv("./data/ednalysis.csv", stringsAsFactors=FALSE, fileEncoding="latin1")
mo_s <- as.numeric(range(ecda$months_after))


ui <- fluidPage(
  titlePanel("Public Transportation in Seattle"),
  # creates about page
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
    # creates bus stop map page 
    tabPanel("Bus Stops to U-District", fluid = TRUE,
             sidebarLayout(
               sidebarPanel(h3("Bus Stops to U-District"),
                            p("Here you can view all the bus stops that will get you to University District without a transfer. The stops can 
                              be filtered by the latitude, longitude, and transit agency. Points on the map represent different bus stops 
                              and the colors indicate the transit agency the route belongs to. The stops can be clicked to 
                              show the route and transit agency associated with them. Additionally, the map
                              can be clicked to show you what neighborhood you are in. "),
                            # allows user to select agency
                            checkboxGroupInput("agency", "Select Transit Agency:", 
                                               choices = all_stops$agency %>% unique(), 
                                               selected = c("Metro Transit",
                                                            "Sound Transit",
                                                            "Community Transit")),
                            # allows user to adjust latitude
                            sliderInput('lat_choice', label = "Adjust Latitude:", 
                                        min=range_lat[1], max = range_lat[2], 
                                        value = range_lat, step = 0.001),
                            # allows user to adjust latitude
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
                 verbatimTextOutput("count"),
                 h3("Map Summary"),
                 p("Above you will notice a few things. Of all the agencies serving
                   Seattle, Metro Transit is certainly the most extensive in terms of 
                   access to University District. You will also notice that West Seattle, 
                   South Seattle, and some of North Seattle/Shoreline are barely serviced
                   with good access to University District. The areas with the most direct connections
                   to University District are the neighborhoods immediately surrounding University
                   District and also Downtown Seattle."),
                 hr(),
                 h3("Table"),
                 p("Here you will find the exact coordinates, route number, and agency
                   associated with all the stops displayed above."),
                 dataTableOutput("stops_table")
                 )
               )
               ),
    # crime data page
    tabPanel("Crime Data and Buses",
             sidebarLayout(
               sidebarPanel(
                 h3("Crime Data"),
                 p("This map displays the relationship between crime rates in
                   Seattle and the bus stops that lead to University District.
                   These offenses were reported within the last three months
                   and they are represented by the red spots on the map. The
                   blue spots represent the bus stops. When clicking on the crimes,
                   the offense and the date reported appears. When clicking on
                   bus stops, the agency and route ID appears. Neighborhoods are also
                   displayed when clicking on different areas on the map. The map can
                   be filtered by the type of offense commited."),
                 # allows user to select crime type
                 selectInput(inputId = "crime", label = "Choose a Crime:",
                             choices = crime_data$Offense.Description,
                             selected = "Theft", multiple = TRUE)
                 
                 ),
               mainPanel(
                 h3("Map"),
                 leafletOutput("crime_map"),
                 h4("Summary"),
                 p("When specifying the crime of interest, you can see that a large majority
                   of crimes in Seattle occur in the downtown area. This is where several
                   routes that lead to University District begin. Crimes in other areas seem
                   to be more spread out. The map also shows that many crimes occur in 
                   areas close to bus stops."),
                 hr(),
                 h3("Table"),
                 p("First choose one or more crimes then a table will display the crime commited,
                   the month and year it occured, and where it occured using longitude and latitude"),
                 dataTableOutput("crime_table")
               )
             )),
    # employment and buses info page
    tabPanel("Employment and Buses",
             sidebarLayout(
               sidebarPanel(
                 # allows user to select by month after 09/2015
                 sliderInput('mo_after', label="Months After September 2015", min=mo_s[1], max=mo_s[2], value=mo_s)
               ),
               mainPanel(
                 
                 p("This research uses data from The Bureau of Labor Statistics and the Ride the Wave Transit Guide from 
                   Sound Transit."),
                 
                 plotOutput("eplot"),
                 
                 p("The greenish blue line represents changes in trip times and the red line represents added trips for bus routes. 
                   The bar graph represents the unemployment rate. It is important to know that major changes to the bus 
                   schedules change once every six months. As you can see, the employment rates in Seattle slightly creeped
                   down over time. This chart would be much more interesting if we went back to the 2008 financial crisis. 
                   However, the data for the changes in the bus schedules were not available online with the latest going back
                   to only September 2015. That is why the chart has an x-axis of months after that date. Since it is the
                   beginning of the analysis.")
                 
               ))
    ),
    # demographic page
    tabPanel("King County Demographics and Buses",
             sidebarLayout(
               sidebarPanel(
                 p("This is a demographic map showing the percentage of people in each census tract of King county who are not white.
                 Hover on a census tract to see what its number is and the exact percentages of each group in the population.
                 Transit stops are also displayed and the name of the stop can be obtained by clicking on the point."),
                 p("Important things to keep in mind: The demographic data is from the American Community Survey. It is averaged from
                   2011 to 2016 to give fair impressions of the general breakdown of an area, and should not be used for exact measurements
                   or to receive accurate information on a quickly changing area. Also, the demographic data is only for King County, and
                   transit stops will be displayed outside of this range on the map, and displayed everywhere regardless of how you filter
                   down the map."),
                 tags$hr(),
                 # allows user to filter based on nonwhite percent
                 sliderInput("nonwhite_percent", label = "Only display census tracts with a nonwhite population between",
                             min = 0, max = 100, value = c(0, 100), post = "%")
               ),
               mainPanel(
                 leafletOutput("demographics_map")
               )
             )
             )
    ))