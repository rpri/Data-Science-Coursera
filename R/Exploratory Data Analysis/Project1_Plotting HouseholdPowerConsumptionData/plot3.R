library(dplyr)
library(data.table)

#extract file data 
dataFile <- "~/Documents/household_power_consumption.txt"
data <- read.csv(dataFile,header=TRUE,sep=";",stringsAsFactors = FALSE,na.strings="?")


#create subset of above read data with dates 1/2/2007 & 2/2/2007
subset_data <- data[data$Date %in% c("1/2/2007","2/2/2007"),]

globalActivePower <- as.numeric(subset_data$Global_active_power)
submetering1<- as.numeric(subset_data$Sub_metering_1)
submetering2<- as.numeric(subset_data$Sub_metering_2)
submetering3<- as.numeric(subset_data$Sub_metering_3)

#create object of datetime together
subset_data$d <- paste(subset_data$Date,subset_data$Time)
subset_data$timestamp <- strptime(subset_data$d,"%d/%m/%Y %H:%M:%S")
# open file plot3.png
png("plot3.png",width=480,height=480)

plot(subset_data$timestamp,submetering1,type='l',xlab='',ylab='Energy Sub metering')
lines(subset_data$timestamp,submetering2,col='red')
lines(subset_data$timestamp,submetering3,col='blue')
legend('topright',c('Sub_metering_1','Sub_metering_2','Sub_metering_3'),lty=1,lwd=2.5,col=c('black','red','blue'))



dev.off()


