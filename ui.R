library(jsonlite)
library(httr)
library(knitr)
library(dplyr)
library(ggplot2)
library(ggmap)
library(mapdata)
library(geojsonio)
library(leaflet)
library(shiny)

all_stops <- read.csv("./data/bus_stops_data.csv")

ui <- fluidPage(
  tabsetPanel(
    tabPanel("Bus Stops", fluid = TRUE,
             sidebarLayout(
               sidebarPanel(selectInput("Agency", "Select Transit Agency", 
                                        choices = all_stops$agency, selected = "")),
               mainPanel(
                 leafletOutput("Stops")
               )
             )
    )
    ),
  
    tabPanel("plot", fluid = TRUE,
             sidebarLayout(
               sidebarPanel(
                 mainPanel(fluidRow(
                 column(7,  leafletOutput("")),
                 column(5, leafletOutput(""))   
               )
               )
             )
    )
  )
)