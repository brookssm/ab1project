library(shiny)
library(dplyr)
library(leaflet)
library(geojsonio)
library(ggplot2)
source("censusmapping.R")
ecdata <- read.csv("./data/ednalysis.csv", stringsAsFactors=FALSE, fileEncoding="latin1")
ecdata <- mutate(ecdata, months_after = as.numeric(months_after))%>%
  mutate(unemployment.rate = as.numeric(unemployment.rate)) %>%
  mutate(ch_adj = as.numeric(ch_adj))%>%
  mutate(new_r = as.numeric(new_r))

server <- function(input, output) {
  topoData <- geojsonio::geojson_read("./data/geojson/neighborhoods.geojson",
                                      what = "sp")
  agencycolor <- colorFactor(c("#ff5683", "#2bd8ff", "#ffec47"), all_stops$agency)
  all_stops[1] <- NULL
  
  filtered_stops <- reactive({
    stops <- all_stops %>% 
      filter(agency %in% input$agency) %>% 
      filter(lon >= input$lon_choice[1] & 
               lon <= input$lon_choice[2]) %>% 
      filter(lat >= input$lat_choice[1] & 
               lat <= input$lat_choice[2])
  })
  
  output$stops <- renderLeaflet({
    leaflet(topoData) %>%
      setView(-122.3035, 47.6553, zoom = 11) %>%
      addTiles('http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png', 
               attribution='Map tiles by <a href="http://stamen.com">Stamen Design</a>, 
               <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy;
               <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>') %>% 
      addPolygons(stroke = TRUE, smoothFactor = 0.1, fillOpacity = 0,
                  popup = paste0(topoData$name, ", ", topoData$city), color = "white", 
                  weight = 1, opacity = 0.4) %>% 
      addCircles(data = filtered_stops(), ~lon, ~lat, popup = paste0(all_stops$agency, ", ", 
                                                                     all_stops$route_id), 
                 weight = 10, radius = 100, color = ~agencycolor(agency), 
                 stroke = FALSE, fillOpacity = 0.8) %>%
      addLegend("bottomright", pal = agencycolor, values = ~all_stops$agency,
                title = "Transit Agency",
                opacity = 0.8, data = all_stops)
  })
  
  output$count <- renderText({
    paste0("There are ", nrow(filtered_stops()), " bus stops currently being displayed.")
  })
  
  output$stops_table <- renderDataTable({
    return(filtered_stops())
  }, options = list(columns = list(
    list(title = 'Latitude'),
    list(title = 'Longitude'),
    list(title = 'Route ID'),
    list(title = 'Agency')))
  )
  
  crime_reactive <- reactive({
    rever <- crime_map_data %>%
      filter(Offense.Description %in% input$crime)
  })
  
  crime_table_reactive <- reactive({
    react <- crime_table_data %>%
      filter(Offense.Description %in% input$crime)
  })
  
  output$crime_map <- renderLeaflet({
    crime_map <- leaflet(topoData) %>% setView(-122.3035, 47.6553, zoom = 11) %>%
      addTiles('http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png', 
               attribution='Map tiles by <a href="http://stamen.com">Stamen Design</a>, 
               <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy;
               <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>') %>%
      addPolygons(stroke = TRUE, smoothFactor = 0.1, fillOpacity = 0,
                  popup = paste0(topoData$name, ", ", topoData$city), color = "white", 
                  weight = 1, opacity = 0.5) %>% 
      addCircles(data = crime_reactive(), ~Longitude, ~Latitude,
                 popup = paste0(crime_map_data$Offense.Description, ", Date Reported: ",
                                crime_map_data$Date.Reported),
                 color = "red", stroke = FALSE, weight = 10, radius = 100,
                 fillOpacity = 0.5) %>% 
      addCircles(data = bus_stops, ~lon, ~lat,
                 popup = paste0(all_stops$agency, ", ", all_stops$route_id),
                 color = "blue", stroke = FALSE, weight = 10, radius = 100,
                 fillOpacity = 0.8)
  })
  
  output$crime_table <- renderDataTable({
    return(crime_table_reactive())
  }, options = list(columns = list(
    list(title = "Offense"),
    list(title = "Month"),
    list(title = "Year"),
    list(title = "Longitude"),
    list(title = "Latitude")))
  )
  
  
  
  ed_rv <- reactive({
    ranver <- ecdata %>%
      filter(months_after > input$mo_after[1] & months_after < input$mo_after[2])
    return(ranver)
  })
  
  output$eplot <- renderPlot({ 
    ggplot(ed_rv(), aes(x = months_after, y = unemployment.rate))+ geom_bar(stat = "identity")+
      geom_smooth(mapping = aes(x = months_after, y = ch_adj, color = "green"), method = "loess")+
      geom_smooth(mapping = aes(x = months_after, y = new_r, color = "red"), method = "loess")+
      ggtitle("Unmployment rate and bus changes/new routes")+
      guides(colour = FALSE)+
      labs(x= "Months after September 2015")+
      labs(y= "Percentage and number")
    
  })
  
  output$demographics_map <- renderLeaflet({
    nonwhite_map
  })
  
  
}