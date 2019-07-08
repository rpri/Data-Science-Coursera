#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  library(dplyr)
  library(ggplot2)
  
  file<-"\repdata_data_StormData.csv"
  data1<-read.csv(file,header=TRUE,sep=',')
  data1$PROPDMGEXP<-factor(toupper(data1$PROPDMGEXP))
  data1$CROPDMGEXP<-factor(toupper(data1$CROPDMGEXP))
  
  ##Finding multiplier value for PROPDMG corresponding to PROPDMGEXP
  data1$PROPDMGE<-0
  data1$PROPDMGE<-0
  data1[grep("K",data1$PROPDMGEXP),"PROPDMGE"]<-1000
  data1[grep("B",data1$PROPDMGEXP),"PROPDMGE"]<-1000000000
  ##data1[grep("1",data1$PROPDMGEXP),"PROPDMGE"]<-10
  data1[grep("2",data1$PROPDMGEXP),"PROPDMGE"]<-100
  data1[grep("3",data1$PROPDMGEXP),"PROPDMGE"]<-1000
  data1[grep("4",data1$PROPDMGEXP),"PROPDMGE"]<-10000
  data1[grep("5",data1$PROPDMGEXP),"PROPDMGE"]<-100000
  data1[grep("6",data1$PROPDMGEXP),"PROPDMGE"]<-1000000
  data1[grep("7",data1$PROPDMGEXP),"PROPDMGE"]<-10000000
  data1[grep("8",data1$PROPDMGEXP),"PROPDMGE"]<-100000000
  data1[grep("H",data1$PROPDMGEXP),"PROPDMGE"]<-100
  data1[grep("M",data1$PROPDMGEXP),"PROPDMGE"]<-1000000
  ##data1[grep(("+|-|?|0"),data1$PROPDMGEXP),"PROPDMGE"]<-0
  ##Finding multiplier value for CROPDMG corresponding to CROPDMGEXP
  data1[grep("K",data1$CROPDMGEXP),"CROPDMGE"]<-1000
  data1[grep("K",data1$CROPDMGEXP),"CROPDMGE"]<-1000
  data1[grep("M",data1$CROPDMGEXP),"CROPDMGE"]<-1000000
  data1[grep("B",data1$CROPDMGEXP),"CROPDMGE"]<-1000000000
  ##data1[grep(("+|-|?|0"),data1$CROPDMGEXP),"CROPDMGE"]<-0
  ##Finding total economical damage in US (Property+Crop)
  data1$TOTALPROPDMG<-0
  data1$TOTALCROPDMG<-0
  data1$TOTALDMG<-0
  data1$TOTALPROPDMG<-data1$PROPDMG*data1$PROPDMGE
  data1$TOTALCROPDMG<-data1$CROPDMG*data1$CROPDMGE
  data1$TOTALDMG<-data1$TOTALPROPDMG+data1$TOTALCROPDMG
  
  Weather_impact<-aggregate(data1$FATALITIES+data1$INJURIES,by=list(data1$EVTYPE),sum,na.rm=TRUE)
  colnames(Weather_impact)<-c("Event","Impact")
  a<-arrange(Weather_impact,desc(Impact))[1:10,]
  dataF<-arrange(data1,desc(data1$FATALITIES))[1:10,]
  dataI<-arrange(datat1,desc(data1$INJURIES))[1:10,]
  
  Economy_impact<-aggregate(data1$TOTALDMG,by=list(data1$EVTYPE),sum,na.rm=TRUE)
  colnames(Economy_impact)<-c("Event","EconomyImpact")
  b<-arrange(Economy_impact,desc(EconomyImpact))[1:10,]
  dataC<-arrange(data1,desc(data1$TOTALCROPDMG))[1:10,]
  dataP<-arrange(datat1,desc(data1$TOTALPROPDMG))[1:10,]
  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    yax<-ifelse(input$Fatalities,dataF$FATALITIES,data1$FATALITIES)
    yax<-ifelse(input$Injuries,dataI$INJURIES,data1$FATALITIES)
    yax<-ifelse(input$Propertydamage,dataP$TOTALPROPDMG,data1$FATALITIES)
    yax<-ifelse(input$Cropdamage,data1$TOTALCROPDMG,data1$FATALITIES)
    
    xax<-ifelse(input$Eventtype,data1$EVTYPE,dataF$EVTYPE)
    #xax<-ifelse(input$State,data1$STATE,data1$EVTYPE)
    
   p1<ggplot(a,aes(a$Event,a$Impact))
   p1+geom_bar()+xlab("Event type")+ggtitle("Barplot ")+theme_bw()
   print(p1)
    # plot(height=yax,names.arg = xax,main="impact(Fatalities+Injuries) due to various weather conditions",beside=TRUE,col=("blue"),ylab="Fatalities+Injuries",las=2)
    #barplot(height=a$Impact,names.arg = a$Event,main="impact(Fatalities+Injuries) due to various weather conditions",beside=TRUE,col=("blue"),ylab="Fatalities+Injuries",las=2)
    ##Plotting Total damage vs Event type
    # draw the histogram with the specified number of bins
   # hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
  })
  
})
