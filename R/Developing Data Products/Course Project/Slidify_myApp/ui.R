#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Storm data analysis"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       #sliderInput("bins",
           #        "Number of bins:",
            ##       min = 1,
               #    max = 50,
               #    value = 30)
      
   checkboxInput("Fatalities","Fatalities",value=TRUE),
   checkboxInput("Injuries","Injuries",value=FALSE),
   checkboxInput("Propertydamage","Property damage",value=FALSE),
   checkboxInput("Cropdamage","Crop damage",value=FALSE),
   checkboxInput("Eventtype","Eventtype",value=TRUE),
   checkboxInput("State","State",value=FALSE)
       ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot")
    )
  )
))
