library("dplyr")
library("shiny")
library("ggplo2")

#Make dataframe for changes in bus routes since September 2015, new trips, etc. Schedule changes and new trips
#We can have schedule changes and new trips

ecdata <- read.csv("./data/econ_data.csv")
# cut off to September 2015, where it is relevant for me
ecdata <- ecdata [93:124,]

# now, bin and label the data based on bus schedules, to do that, we can rank the ecdata from 1 to 32.

ecdata <- mutate(ecdata, number = 1:32)

#Create change groups

change <- c("c1", "c2", "c3", "c4","c5")
ch_adj <- c(10, 7, 3, 17, 7)
new_r <- c(1, 6, 0, 3, 0)

cg <- data.frame(change, ch_adj, new_r)

#now we need to create a list that matches the change to relevant economic data

g1 <- rep("c1", 12)
g2 <- rep("c2", 6)
g3 <- rep("c3", 6)
g4 <- rep("c4", 6)
g5 <- rep("c5", 2)
gall <- c(g1, g2, g3, g4, g5)

#Now to join them... (add the c's to the ec data and then add in the change groups)

ecdata <- mutate(ecdata, change = gall)

ecdata <- left_join(ecdata, cg)
colnames(ecdata)[7] <- "months_after"

#Now this data set is ready for visualization, save!
#setwd("./data")
#write.csv(file="ednalysis.csv", ecdata)

ecdata <- read.csv("./data/ednalysis.csv")

#define User interface

#max and min of months
months <- range(ecdata$months_after)


ui <- fluidPage(
  
  titlePanel("Route Additions, Schedule Changes and Employment"),
  
  # Include a `sidebarLayout()`
  sidebarLayout(
    
    #control widgets for navvigating:
    sidebarPanel(
      
      sliderInput('mo_after', label="Months After September 2015", min=months[1], max=months[2], value=months)
      
    ),
    mainPanel(
      
      p("This research uses data from The Bureau of Labor Statistics and "),
      
      plotOutput('plot', dblclick = 'clickit')
      
    ) 
  )
)


server <- function(input, output) {
  
  # reactive variable for shared data
  filtered <- reactive({
    data <- ecdata %>%
      filter(months_after > input$mo_after[1] & pct.asian < input$mo_after[2]) %>%
    return(data)
  })
  
  output$plot <- renderPlot({ 
    p <- ggplot(data = filtered)+
      geom_line(mapping = aes(x = months_after, y = unemployment.rate, color = "green")) +
      geom_bar(mapping = aes(x = months_after, y = ch_adj, color = "blue")) +
      geom_bar(mapping = aes(x = months_after, y = new_r, color = "red"))
    
    return(p)
  })
  

  
}


