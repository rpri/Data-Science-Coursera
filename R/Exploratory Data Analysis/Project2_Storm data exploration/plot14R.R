library(dplyr)
library(data.table)

setwd("~/Documents/exploratory analysis_proj2")
dataFile <- "~/Documents/exploratory analysis_proj2/exdata_data_NEI_data/summarySCC_PM25.rds"
dataFile2 <- "~/Documents/exploratory analysis_proj2/exdata_data_NEI_data/Source_Classification_Code.rds"
data <- readRDS(dataFile)
data2 <-readRDS(dataFile2)
data1<-subset(data,data$fips=="24510")
Emission<-aggregate(data1$Emissions,by=list(data1$year,data1$type),sum,na.rm=TRUE)
#png("plot3.png",width=500,height=500)
#qplot(Emission$x,Emission$Group.1,data=data1,facets=.~type,ylab="Pollutant level")
#dev.off()