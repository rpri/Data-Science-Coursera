library(dplyr)
library(data.table)

#extract file data 
dataFile <- "~/Documents/household_power_consumption.txt"
data <- read.table(dataFile,header=TRUE,sep=";",stringsAsFactors = FALSE,na.strings="?",dec='.')

#create subset of above read data with dates 1/2/2007 & 2/2/2007
subset <- data[data$Date %in% c("1/2/2007","2/2/2007"),]

##subset_data<-subset[complete.cases(subset),]

subset_data$globalactivepower <- as.numeric(as.character(subset_data$Global_active_power))

#create object of datetime together
##subset_data$Date <-as.Date(subset_data$Date,format="%d,%m,%y")
##subset_data$datetime <-as.POSIXct(paste(subset_data$Date,subset_data$Time))
subset_data$d <- paste(subset_data$Date,subset_data$Time)
subset_data$timestamp <- strptime(subset_data$d,"%d/%m/%Y %H:%M:%S")

##lot(subset_data$datetime,subset_data$globalactivepower)
# open file plot2.png
png("plot2.png",width=480,height=480)

plot(subset_data$ti,subset_data$globalactivepower,type='l',xlab='',ylab='Global Active Power (Kilowatts)')
     
     dev.off()
     