library(shiny)
library(dplyr)
library(leaflet)
library(geojsonio)

source("busstopmap.R")
range_lat <- range(all_stops$lat)
range_lon <- range(all_stops$lon)

ui <- fluidPage(
  tabsetPanel(
    tabPanel("Bus Stop Map", fluid = TRUE,
             sidebarLayout(
               sidebarPanel(checkboxGroupInput("agency", "Select Transit Agency:", 
                                        choices = all_stops$agency %>% unique(), 
                                        selected = "Metro Transit"),
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
