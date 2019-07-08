
library(dplyr)
library(data.table)

setwd("~/Documents/exploratory analysis_proj2")
dataFile <- "~/Documents/exploratory analysis_proj2/exdata_data_NEI_data/summarySCC_PM25.rds"
data <- readRDS(dataFile)
data1<-subset(data,data$fips=="24510")
Emission<-aggregate(data1$Emissions,by=list(data1$year),sum,na.rm=TRUE)
png("plot2.png",width=480,height=480)
with(Emission,plot (x=Emission$Group.1,type="o",col="green",lwd=2,y=Emission$x,xlab="Year",ylab="Pollutant level",main="Emissions from 1999 to 2005 in Baltimore city",pch=21))
dev.off()