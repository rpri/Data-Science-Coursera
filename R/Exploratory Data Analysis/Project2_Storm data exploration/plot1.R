library(dplyr)
library(data.table)

setwd("~/Documents/exploratory analysis_proj2")

##getdata_url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
##check_url<-file(getdata_url,"r")
##if(! is.open(check_url))
##{stop((paste("There is problem with url")))}
##download.file(getdata_url,destfile="~/exdata_data_NEI_data.zip",method="auto")
##zipped_file<-"exdata_data_NEI_data.zip"
##if(!file.exists(zipped_file))
##{ unzip(zipfile = "~/exdata_data_NEI_data.zip",exdir="~/")
##}

dataFile <- "~/Documents/exploratory analysis_proj2/exdata_data_NEI_data/summarySCC_PM25.rds"
 data <- readRDS(dataFile)
Emission99<-aggregate(data$Emissions,by=list(data$year),sum,na.rm=TRUE)
png("plot1.png",width=480,height=480)
with(data,plot(x=Emission99$Group.1,y=Emission99$x,type="o",col="blue",lwd=2,ylab="Pollutant level",main="Total Emissions from 1999 to 2005 in US"),pch=21)
dev.off()