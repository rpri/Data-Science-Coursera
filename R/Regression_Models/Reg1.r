library(dplyr)

file<-"~/res/repdata_data_StormData.csv"
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
a

##ggplot(aes(x=Weather_impact$Group.1,y=Weather_impact$x),data=data1)
barplot(height=a$Impact,names.arg = a$Event,main="Health impact(Fatalities+Injuries) due to various weather conditions",beside=TRUE,col=("blue"),ylab="Fatalities+Injuries",las=2)
##Plotting Total damage vs Event type
Economy_impact<-aggregate(data1$TOTALDMG,by=list(data1$EVTYPE),sum,na.rm=TRUE)
colnames(Economy_impact)<-c("Event","EconomyImpact")
b<-arrange(Economy_impact,desc(EconomyImpact))[1:10,]

barplot(height=b$EconomyImpact,names.arg =b$Event,main="Economy Impact(Crop+Property damage) due to various weather conditions",col=c("red","green","blue","yellow"),ylab="Crop+Property Damage",las=2)

