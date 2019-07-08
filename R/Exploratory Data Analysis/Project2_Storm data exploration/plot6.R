library(dplyr)
library(data.table)

setwd("~/Documents/exploratory analysis_proj2")
dataFile <- "~/Documents/exploratory analysis_proj2/exdata_data_NEI_data/summarySCC_PM25.rds"
dataFile2 <- "~/Documents/exploratory analysis_proj2/exdata_data_NEI_data/Source_Classification_Code.rds"
data <- readRDS(dataFile)
data2 <-readRDS(dataFile2)

data_final<-subset(data,data$type=="ON-ROAD" & (data$fips=="24510"| data$fips=="06037"))

Emission<-aggregate(data_final$Emissions,by=list(data_final$year,data_final$fips),sum,na.rm=TRUE)
png("plot6.png",width=480,height=480)
g<-ggplot(data=Emission,aes(x=Emission$Group.1,y=Emission$x,color=Emission$Group.2))+geom_point(alpha=0.1)+geom_smooth(method="loess")+ggtitle("Emissions from coal combustion related sources from 1999 to 2008 by city")
print(g)          
dev.off()