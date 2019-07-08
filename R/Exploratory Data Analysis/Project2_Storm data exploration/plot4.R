library(dplyr)
library(data.table)

setwd("~/Documents/exploratory analysis_proj2")
dataFile <- "~/Documents/exploratory analysis_proj2/exdata_data_NEI_data/summarySCC_PM25.rds"
dataFile2 <- "~/Documents/exploratory analysis_proj2/exdata_data_NEI_data/Source_Classification_Code.rds"
data <- readRDS(dataFile)
data2 <-readRDS(dataFile2)
data2[grep("Coal",data2$EI.Sector),"coaltest"] <- "1"
#Coal_id<-uniqueN(data2coal,by=list(data2coal$SCC))
Coal_id<-subset(data2,coaltest=="1")
merged_set<-merge(data,Coal_id[,c("SCC","coaltest")],by.x ="SCC",by.y="SCC")
Emission<-aggregate(merged_set$Emissions,by=list(merged_set$year),sum,na.rm=TRUE)
png("plot4.png",width=480,height=480)
with(Emission,plot (x=Emission$Group.1,type="o",col="green",lwd=2,y=Emission$x,xlab="Year",ylab="Pollutant level",main="Emissions from coal combustion related sources from 1999 to 2008 in US",pch=21))
dev.off()