library(dplyr)
library(data.table)
library(ggplot2)

setwd("~/Documents/exploratory analysis_proj2")
dataFile <- "~/Documents/exploratory analysis_proj2/exdata_data_NEI_data/summarySCC_PM25.rds"
data <- readRDS(dataFile)
data1<-subset(data,data$fips=="24510")
Emission1<-aggregate(data1$Emissions,by=list(data1$year,data1$type),sum,na.rm=TRUE)
png("plot3.png",width=500,height=500)
g<-ggplot(data=Emission1,aes(x=Group.1,y=x,color=Group.2),xlab="Year",ylab="Emissions")+ geom_point(alpha=0.1)+geom_smooth(method="loess")+ggtitle("Total PM2.5 Emissions in Baltimore by source type")
print(g)

dev.off()