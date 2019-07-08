#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
#This app plots Toothlength growth by calculating mean for various x-parameters selected by user 
# Define UI for application that draws a plot depending on user's input
shinyUI(fluidPage(
  
  # Tooth length growth analysis 
  titlePanel("Tooth length growth analysis for different parameters"),
  
  # Sidebar with a dropdown list input for selecting x-axis parameter to show on Toothlength growth plot
  sidebarLayout(
    sidebarPanel(
       selectInput("parameter",label=h5("Select which x-parameter you wish to Plot"),
                   ,choices=list("Dosage"=1,"Supplement"=2,"Both Supplement and dosage"=3),selected=1)),
    # Show a plot of the Toothlength growth vs parameter selected by user
    mainPanel(
       plotOutput("distPlot")
       
    )
         )
))
