library(dplyr)
library(data.table)
library(ggplot2)

setwd("~/Documents/Reproducible_search_Proj2")
dataFile<-"~/Documents/Reproducible_search_Proj2/repdata_data_StormData.csv"
data1<-read.csv(dataFile,header=TRUE,sep=",",stringsAsFactors = FALSE,na.strings=" ")
data1[is.na(data1)]<-0
#Finding out unique exponential values for Property damage exponent
print(unique(data1$PROPDMGEXP))
#Finding out unique exponential values for Crop damage exponent
print("crop")
print(unique(data1$CROPDMGEXP))

#converting lower case characters to upper for Property damage exponent
data1$PROPDMGEXP<-factor(toupper(data1$PROPDMGEXP))
data1$CROPDMGEXP<-factor(toupper(data1$CROPDMGEXP))

Weather_impact<-aggregate(data1$FATALITIES+data1$INJURIES,by=list(data1$EVTYPE),sum,na.rm=TRUE)
colnames(Weather_impact)<-c("Event","Impact")
##ggplot(aes(x=Weather_impact$Group.1,y=Weather_impact$x),data=data1)
barplot(height=Weather_impact$Impact,names.arg = Weather_impact$Event,main="Health impact(Fatalities+Injuries) due to various weather conditions",ylab="Fatalities+Injuries",las=2)

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

data1[grep("K",data1$CROPDMGEXP),"CROPDMGE"]<-1000
data1[grep("K",data1$CROPDMGEXP),"CROPDMGE"]<-1000
data1[grep("M",data1$CROPDMGEXP),"CROPDMGE"]<-1000000
data1[grep("B",data1$CROPDMGEXP),"CROPDMGE"]<-1000000000

data1$TOTALPROPDMG<-0
data1$TOTALCROPDMG<-0
data1$TOTALDMG<-0
data1$TOTALPROPDMG<-data1$PROPDMG*data1$PROPDMGE
data1$TOTALCROPDMG<-data1$CROPDMG*data1$CROPDMGE
data1$TOTALDMG<-data1$TOTALPROPDMG+data1$TOTALCROPDMG

Economy_impact<-aggregate(data1$TOTALDMG,by=list(data1$EVTYPE),sum,na.rm=TRUE)
colnames(Economy_impact)<-c("Event","EconomyImpact")
##ggplot(aes(x=Weather_impact$Group.1,y=Weather_impact$x),data=data1)
barplot(height=Economy_impact$EconomyImpact,names.arg =Economy_impact$Event,main="Economy Impact(Crop+Property damage) due to various weather conditions",ylab="Crop+Property Damage",las=2)


