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
shinyUI(navbarPage("Text Prediction ...",
                   tabPanel("App",
                            fluidRow(
                              column(4,
                                     #"Input text....", background: none repeat scroll 0 0 #96a2b6;
                                     br(), br(),br(),
                                     uiOutput("word"),
                                     #br(),
                                     tags$textarea(id="text", rows=5, cols=60, ""), #width: 250px;
                                     tags$head(tags$style(type="text/css", "#text { width: 280px;margin-top:10px}"))
                              ),
                              column(7, plotOutput("cloud"))
                            )
                   ),
                   navbarMenu("About",
                              tabPanel("What is this?"),
                              tabPanel("How does it work?")
                   )
)
)