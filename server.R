library(shiny)
library(dplyr)
library(leaflet)
library(geojsonio)
library(ggplot2)
library(magrittr)
source("censusmapping.R")
source("allbusstops.R")
source("busstopmap.R")
source("policereports.R")
source("crimedata.R")
# data for economic visual
ecdata <- read.csv("./data/ednalysis.csv", stringsAsFactors=FALSE, fileEncoding="latin1")
ecdata <- mutate(ecdata, months_after = as.numeric(months_after))%>%
  mutate(unemployment.rate = as.numeric(unemployment.rate)) %>%
  mutate(ch_adj = as.numeric(ch_adj))%>%
  mutate(new_r = as.numeric(new_r))

server <- function(input, output) {
  # geo data for neighborhoods in bus stop map
  topoData <- geojsonio::geojson_read("./data/geojson/neighborhoods.geojson",
                                      what = "sp")
  # defines palette
  agencycolor <- colorFactor(c("#ff5683", "#2bd8ff", "#ffec47"), all_stops$agency)
  all_stops[1] <- NULL
  
  # creates reactive data frame of bus stops that meets
  # input criteria
  filtered_stops <- reactive({
    stops <- all_stops %>% 
      filter(agency %in% input$agency) %>% 
      filter(lon >= input$lon_choice[1] & 
               lon <= input$lon_choice[2]) %>% 
      filter(lat >= input$lat_choice[1] & 
               lat <= input$lat_choice[2])
  })
  
  # creates leaflet map of bus stops 
  output$stops <- renderLeaflet({
    # loads in neighborhood boundaries
    leaflet(topoData) %>%
      # sets zoom and centers on uw 
      setView(-122.3035, 47.6553, zoom = 11) %>%
      # makes map black
      addTiles('http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png', 
               attribution='Map tiles by <a href="http://stamen.com">Stamen Design</a>, 
               <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy;
               <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>') %>% 
      # adds lines for neighborhood boundaries
      addPolygons(stroke = TRUE, smoothFactor = 0.1, fillOpacity = 0,
                  popup = paste0(topoData$name, ", ", topoData$city), color = "white", 
                  weight = 1, opacity = 0.4) %>% 
      # adds bus stops as points
      addCircles(data = filtered_stops(), ~lon, ~lat, popup = paste0(filtered_stops() %>% 
                                                                       use_series(agency), ", ", 
                                                                     filtered_stops() %>% 
                                                                       use_series(route_id)), 
                 weight = 10, radius = 100, color = ~agencycolor(agency), 
                 stroke = FALSE, fillOpacity = 0.8) %>%
      # adds color legend for bus stops
      addLegend("bottomright", pal = agencycolor, values = ~all_stops$agency,
                title = "Transit Agency",
                opacity = 0.8, data = all_stops)
  })
  
  # reactive text output that displays bus stop count
  output$count <- renderText({
    paste0("There are ", nrow(filtered_stops()), 
           " bus stops currently being displayed.")
  })
  
  # adds data table of bus stop info
  output$stops_table <- renderDataTable({
    return(filtered_stops())
  }, options = list(columns = list(
    # sets colnames for table
    list(title = 'Latitude'),
    list(title = 'Longitude'),
    list(title = 'Route ID'),
    list(title = 'Agency')))
  )
  
  # creates reactive df of crime info and filters for map
  crime_reactive <- reactive({
    rever <- crime_map_data %>%
      filter(Offense.Description %in% input$crime)
  })
  
  # creates reactive df of crime info and filters for table
  crime_table_reactive <- reactive({
    react <- crime_table_data %>%
      filter(Offense.Description %in% input$crime)
  })
  
  # creates map of crime and bus stops
  output$crime_map <- renderLeaflet({
    # adds neighborhood data and centers on map
    crime_map <- leaflet(topoData) %>% setView(-122.3035, 47.6553, zoom = 11) %>%
      addTiles('http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png', 
               attribution='Map tiles by <a href="http://stamen.com">Stamen Design</a>, 
               <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy;
               <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>') %>%
      # adds neighborhood boundaries
      addPolygons(stroke = TRUE, smoothFactor = 0.1, fillOpacity = 0,
                  popup = paste0(topoData$name, ", ", topoData$city), color = "white", 
                  weight = 1, opacity = 0.5) %>% 
      # adds crime on map
      addCircles(data = crime_reactive(), ~Longitude, ~Latitude,
                 popup = paste0(crime_reactive() %>% 
                                  use_series(Offense.Description), ", Date Reported: ",
                                crime_map_data %>% 
                                  use_series(Date.Reported)),
                 color = "red", stroke = FALSE, weight = 10, radius = 100,
                 fillOpacity = 0.5) %>% 
      # adds bus stops to map
      addCircles(data = bus_stops, ~lon, ~lat,
                 popup = paste0(bus_stops$agency, ", ", bus_stops$route_id),
                 color = "blue", stroke = FALSE, weight = 10, radius = 100,
                 fillOpacity = 0.8)
  })
  
  # creates data table of crime in seattle displayed on map
  output$crime_table <- renderDataTable({
    return(crime_table_reactive())
  }, options = list(columns = list(
    list(title = "Offense"),
    list(title = "Month"),
    list(title = "Year"),
    list(title = "Longitude"),
    list(title = "Latitude")))
  )
  
  
  # creates reactive df for economic visual
  ed_rv <- reactive({
    ranver <- ecdata %>%
      filter(months_after > input$mo_after[1] & months_after < input$mo_after[2])
    return(ranver)
  })
  
  # creates plot of employment rate and bus stop change info 
  output$eplot <- renderPlot({ 
    ggplot(ed_rv(), aes(x = months_after, y = unemployment.rate))+ geom_bar(stat = "identity")+
      geom_smooth(mapping = aes(x = months_after, y = ch_adj, color = "green"), method = "loess")+
      geom_smooth(mapping = aes(x = months_after, y = new_r, color = "red"), method = "loess")+
      ggtitle("Unmployment rate and bus changes/new routes")+
      guides(colour = FALSE)+
      labs(x= "Months after September 2015")+
      labs(y= "Percentage and number")
    
  })
  
  # creates map of demographic data
  output$demographics_map <- renderLeaflet({
    filtered_map <- census_map %>% 
      # filters for nonwhite percentage
      subset(`% Nonwhite` >= input$nonwhite_percent[1] &
              `% Nonwhite` <= input$nonwhite_percent[2])
    # creates labels
    labels <- lapply(seq(nrow(filtered_map@data)), function(i) {
      paste0( "<p>",
              "<p><strong>Census Tract ", filtered_map@data[i, "Census Tract"], "</strong></p>", 
              "<ul>",
              "<li>White:", filtered_map@data[i, "% White"] %>% round(2), "%</li>",
              "<li>Black:", filtered_map@data[i, "% Black"] %>% round(2), "%</li>",
              "<li>American Indian & Alaska Native:", filtered_map@data[i, "% American Indian & Alaskan Native"] %>% round(2), "%</li>",
              "<li>Asian:", filtered_map@data[i, "% Asian"] %>% round(2), "%</li>",
              "<li>Native Hawaiian & Pacific Islander:", filtered_map@data[i, "% Native Hawaiian & Pacific Islander"] %>% round(2), "%</li>",
              "<li>Other:", filtered_map@data[i, "% Other"] %>% round(2), "%</li>",
              "<li>Two or more races:", filtered_map@data[i, "% Two or more races"] %>% round(2), "%</li>",
              "</ul>", 
              "</p>" ) 
    })
    # creates leaflet map
    demographics_map <- leaflet() %>% 
      # centers and zooms
      setView(-121.74806645321303, 47.435773650409715, zoom = 9) %>% 
      # adds colored polygons based on nonwhite percentage
      addPolygons(data = filtered_map,
                  fillColor = ~pal(`% Nonwhite`),
                  color = "#b2aeae",
                  weight = 1,
                  fillOpacity = 0.6,
                  label = lapply(labels, HTML)) %>% 
      # creates legend
      addLegend(pal = pal,
                values = c(0, 100),
                position = "bottomright",
                title = "% Nonwhite in population") %>% 
      # adds tiles
      addTiles('http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png', 
               attribution= "&copy; <a href='http://www.openstreetmap.org/copyright'>OpenStreetMap</a> contributors, 
               &copy; <a href='http://cartodb.com/attributions'>CartoDB</a>") %>% 
      # adds bus stops to map 
      addCircles(data = all_bus_stops, ~lon, ~lat, popup = all_bus_stops$name,
                 color = "#222", opacity = 0.01, fillOpacity = 0.06, radius = 0.05)
    
    demographics_map
  })
  
  
}