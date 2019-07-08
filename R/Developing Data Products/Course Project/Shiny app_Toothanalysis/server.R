#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

# Depending on user's input for x-parameter, this app calculates mean Toothlength for that parameter and plots it for various levels

shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
  
    #display plot by dosage
   if(input$parameter==1)
   { # calculate aggregate toothlength  growth for every dosage and supplement type to plot
     avg <- aggregate(len~.,data=ToothGrowth,mean)
    g <- ggplot(aes(x=dose, y = len), data =ToothGrowth) + 
      geom_point(aes(color = supp)) 
    g <- g + geom_line(data=ToothGrowth,aes(group=supp,colour=supp))+ggtitle("Plot showing Toothlength growth Vs Dosage with Regression line in Red ")+stat_smooth(method = "lm", col = "red")
    fit1<-lm(ToothGrowth$len ~ ToothGrowth$dose)
    print(summary(fit1))}
    
    #display plot by supplement type
    if(input$parameter==2)
      {g<-ggplot(aes(x = supp, y = len), data=ToothGrowth) + 
      geom_boxplot(aes(fill = supp))+ggtitle("Plot showing Toothlength growth Vs supp")
      fit2<-lm(ToothGrowth$len ~ ToothGrowth$supp)
      summary(fit2)}
    
    #display plot by supplement type and dosage
    if (input$parameter==3)
    {g<-ggplot(aes(x=supp, y=len),data = ToothGrowth) +
        geom_boxplot(aes(fill=supp))+facet_wrap(~ dose)+ggtitle("Plot showing Toothlength Vs supp for every dose ")
    fit3<-lm(ToothGrowth$len ~ ToothGrowth$supp +ToothGrowth$dose)
    print(summary(fit3))}
    print(g)
    
  
  })

})
