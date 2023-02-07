# Day 2

## 13 Structure of a Shiny app

```R
# Load libraries
library(leaflet)
library(data.table)
library(shiny)

# Load data
setwd("~/Documents/uni/FS23/R") # set working directory
d <- fread("demographics_plus_zip_info.csv")
zips <- as.matrix(d[1:10000, list(zip_longitude, zip_latitude)])

# ui part -----------------------------------------------------------------

# Define a map object as output
ui <-  fluidPage(
  leafletOutput(outputId = "mymap")
)
  
  
  # server part -------------------------------------------------------------
  
  server <- function(input, output, session) {
    
    # Define map and fill map with data points  
    output$mymap = renderLeaflet({
      leaflet();
      map <- addTiles(map); 
      map <- addMarkers(map, data = zips, clusterOptions = markerClusterOptions());
      map <- setView(map, lat= 43, lng= -79, zoom = 3); # North America
    })
  }  
  
  # End server
  
  shinyApp(ui = ui, server = server)
```

## 14 Build a user interface for a Shiny app

```R
# Load libraries
library(leaflet)
library(data.table)
library(shiny)

# Load data
setwd("~/Documents/uni/FS23/R") # set working directory
d <- fread("demographics_plus_zip_info.csv")
zips <- as.matrix(d[1:10000, list(zip_longitude, zip_latitude)])

# ui part -----------------------------------------------------------------

# Define a map object as output
ui <-  fluidPage(
  theme = shinytheme("darkly"), # shiny theme that changes colors etc.
  
  titlePanel("Customer map"), # Title
  
  sidebarLayout(
    sidebarPanel("Inputs"), # name of sidebar
    mainPanel(leafletOutput(outputId = "mymap")), # what is displayed in main panel
    position="left" # position of sidebar
  )
)
  
  
  # server part -------------------------------------------------------------
  
  server <- function(input, output, session) {
    
    # Define map and fill map with data points  
    # output variable can be accessed to display above in UI
    output$mymap = renderLeaflet({
      leaflet();
      map <- addTiles(map); 
      map <- addMarkers(map, data = zips, clusterOptions = markerClusterOptions());
      map <- setView(map, lat= 43, lng= -79, zoom = 3); # North America
    })
  }  
  
  # End server
  
  shinyApp(ui = ui, server = server)
```

## 15 Adding control widgets to the front and back end of a Shiny app
```R
# Load libraries
library(leaflet)
library(data.table)
library(shiny)
library(shinythemes)

# Load data
setwd("~/Documents/uni/FS23/R") # set working directory
d <- fread("demographics_plus_zip_info.csv")
zips <- as.matrix(d[1:10000, list(zip_longitude, zip_latitude)])

d[,JoinDate:=dmy(JoinDate)]

# ui part -----------------------------------------------------------------

# Define a map object as output
ui <-  fluidPage(
  theme = shinytheme("darkly"), # shiny theme that changes colors etc.
  
  titlePanel("Customer map"), # Title
  
  sidebarLayout(
    sidebarPanel("Inputs",
                 checkboxGroupInput("checkGroup", 
                                    label = h3("gender"), 
                                    choices = list("Female" = "f", "Male" = "m", "Alien" = "alien"),
                                    selected = c("m","f")),
                 
                 sliderInput("slider2", label = h3("Slider Range"), 
                             min =as.Date("1965-01-01"),  
                             max = as.Date("2011-12-31"), 
                             value = as.Date(c("2000-01-01","2010-01-01")),
                             timeFormat="%d %b %Y")),
                 
    mainPanel(leafletOutput(outputId = "mymap")), # what is displayed in main panel
    position="left" # position of sidebar
  )
)


# server part -------------------------------------------------------------

server <- function(input, output, session) {

  
  # Define map and fill map with data points  
  # output variable can be accessed to display above in UI
  output$mymap = renderLeaflet({
    # filter data
    zips = as.matrix(d[Gender %in% input$checkGroup & JoinDate %between% input$slider2,list(zip_longitude, zip_latitude)]);
    
    map = leaflet();
    map = addTiles(map); 
    map = addMarkers(map, data = zips, clusterOptions = markerClusterOptions());
    map = setView(map, lat= 43, lng= -79, zoom = 3); # North America
  })
}  

# End server

shinyApp(ui = ui, server = server)
```

## 16 Advanced features of a Shiny app
```R
# Load libraries
library(leaflet)
library(data.table)
library(shiny)
library(shinythemes)

# Load data
setwd("~/Documents/uni/FS23/R") # set working directory
d = fread("demographics_plus_zip_info.csv")
zips = as.matrix(d[1:10000, list(zip_longitude, zip_latitude)])

d[,JoinDate:=dmy(JoinDate)]

# ui part -----------------------------------------------------------------

# Define a map object as output
ui <-  fluidPage(
  theme = shinytheme("sandstone"), # shiny theme that changes colors etc.
  
  titlePanel("Customer map"), # Title
  
  sidebarLayout(
    sidebarPanel("Inputs",
                 checkboxGroupInput("checkGroup", 
                                    label = h3("gender"), 
                                    choices = list("Female" = "f", "Male" = "m", "Alien" = "alien"),
                                    selected = c("m","f")),
                 
                 sliderInput("slider2", label = h3("Slider Range"), 
                             min =as.Date("1965-01-01"),  
                             max = as.Date("2011-12-31"), 
                             value = as.Date(c("2000-01-01","2010-01-01")),
                             timeFormat = "%d %b %Y")),
                 
    mainPanel(leafletOutput(outputId = "mymap"), DTOutput("cust")), # what is displayed in main panel
    position = "left" # position of sidebar
  )
)


# server part -------------------------------------------------------------

server <- function(input, output, session) {

  
  # Define map and fill map with data points  
  # output variable can be accessed to display above in UI
  output$mymap = renderLeaflet({
    # filter data
    zips = as.matrix(d[Gender %in% input$checkGroup & JoinDate %between% input$slider2,
                       list(zip_longitude, zip_latitude)]);
    
    map = leaflet();
    map = addTiles(map); 
    map = addMarkers(map, data = zips, clusterOptions = markerClusterOptions());
    map = setView(map, lat= 43, lng= -79, zoom = 3); # North America
    })
  
  output$cust = renderDT(d[Gender %in% input$checkGroup & 
                                  JoinDate %between% input$slider2,
                                list(Customer,Gender,JoinDate)], 
                              options = list(lengthChange = FALSE))

}  

# End server

shinyApp(ui = ui, server = server)
```
