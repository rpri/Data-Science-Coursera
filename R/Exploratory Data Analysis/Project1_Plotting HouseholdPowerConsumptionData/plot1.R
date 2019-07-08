library(dplyr)
library(data.table)

dataFile <- "~/Documents/household_power_consumption.txt";
data <- read.csv(dataFile,header=TRUE,sep=";",stringsAsFactors = FALSE,na.strings="?")
subset_data <- data[data$Date %in% c("1/2/2007","2/2/2007"),]

globalActivePower <-as.numeric(subset_data$Global_active_power)

datetime<- strptime(paste(subset_data$date,subset_data$time,sep=" "),"%d/%m/%y %H:%M:%S")
png("plot1.png",width=480,height=480)
hist(globalActivePower,col="red",main="Global Active Power",xlab="Global Active Power (Kilowatts)",ylab="Frequency")
dev.off()

