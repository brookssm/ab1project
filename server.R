library(shiny)
library(dplyr)
library(leaflet)
library(geojsonio)
library(ggplot2)
ecdata <- read.csv("./data/ednalysis.csv")
ecdata <- mutate(ecdata, months_after = as.numeric(months_after))%>%
  mutate(unemployment.rate = as.numeric(unemployment.rate)) %>%
  mutate(ch_adj = as.numeric(ch_adj))%>%
  mutate(new_r = as.numeric(new_r))

server <- function(input, output) {
  topoData <- geojsonio::geojson_read("./data/geojson/neighborhoods.geojson",
                                      what = "sp")
  agencycolor <- colorFactor(c("#00ffb3", "#ff4c00", "#1300ff"), all_stops$agency)
  all_stops[1] <- NULL
  
  filtered_stops <- reactive({
    stops <- all_stops %>% 
      filter(agency == input$agency) %>% 
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
                  weight = 1, opacity = 0.5) %>% 
      addCircles(data = filtered_stops(), ~lon, ~lat, popup = paste0(all_stops$agency, ", ", 
                                                              all_stops$route_id), 
                 weight = 10, radius = 100, color = ~agencycolor(agency), 
                 stroke = FALSE, fillOpacity = 1.0) %>%
      addLegend("bottomright", pal = agencycolor, values = ~all_stops$agency,
                title = "Transit Agency",
                opacity = 0.8, data = all_stops)
  })
  
  output$stops_table <- renderDataTable({
    return(filtered_stops())
  }, options = list(columns = list(
         list(title = 'Latitude'),
         list(title = 'Longitude'),
         list(title = 'Route ID'),
         list(title = 'Agency')))
  )
  
  output$count <- renderPrint({
    summary(filtered_stops())
  })
  
  output$crime_map <- renderLeaflet({
    
    crime_map <- leaflet(crime_data) %>% setView(lng = -122.3312, lat = 47.62199, zoom = 10) %>%
      addTiles() %>%
      addCircles(data = crime_reactive(), ~Longitude, ~Latitude,
                 popup = paste0("Date Reported: ",
                                crime_data$`Date Reported`),
                 color = ~color(crime_data$Month)
      ) %>%
      addCircles(
        data = bus_stops, ~lon, ~lat,
        popup = paste0(bus_stops$route_id),
        color = "Blue"
      )
    
    crime_reactive <- reactive({
      filter <- crime_data %>%
        filter(`Offense Type` == input$Crime)
    })
    
  })
  

  
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
  

  
  
}
