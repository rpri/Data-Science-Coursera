library(dplyr)
library(data.table)

#extract file data 
dataFile <- "~/Documents/household_power_consumption.txt"
data <- read.csv(dataFile,header=TRUE,sep=";",stringsAsFactors = FALSE,na.strings="?")

#create subset of above read data with dates 1/2/2007 & 2/2/2007
subset_data <- data[data$Date %in% c("1/2/2007","2/2/2007"),]

globalactivepower <- as.numeric(subset_data$Global_active_power)
globalreactivepower <- as.numeric(subset_data$Global_reactive_power)
voltage <- as.numeric (subset_data$Voltage)
submetering1<- as.numeric(subset_data$Sub_metering_1)
submetering2<- as.numeric(subset_data$Sub_metering_2)
submetering3<- as.numeric(subset_data$Sub_metering_3)

#create object of datetime together
subset_data$d <- paste(subset_data$Date,subset_data$Time)
subset_data$timestamp <- strptime(subset_data$d,"%d/%m/%Y %H:%M:%S")

# open file plot4.png
png("plot4.png",width=480,height=480)
par(mfrow=c(2,2))

#plot 1
plot(subset_data$timestamp,globalactivepower,type='l',xlab='',ylab='Global Active Power')

#plot2 (1st column 2nd row)
plot(subset_data$timestamp,voltage,type='l',xlab='',ylab='Voltage')


#plot 3(2nd ow 2nd column)

plot(subset_data$timestamp,submetering1,type='l',xlab='',ylab='Energy Sub metering')
##plot(subset_data$timestamp,submetering2,type='l',col='red',xlab='',ylab='Energy Sub metering')
##plot(subset_data$timestamp,submetering3,type='l',col='blue',xlab='',ylab='Energy Sub metering')
lines(subset_data$timestamp,submetering2,col='red')
lines(subset_data$timestamp,submetering3,col='blue')
legend('topright',c('Sub_metering_1','Sub_metering_2','Sub_metering_3'),lty=1,lwd=2.5,col=c('black','red','blue'))

legend('topright',c('Sub_metering_1','Sub_metering_2','Sub_metering_3'),lty=1,lwd=2.5,col=c('black','red','blue',bty='0'))


#plot 4(2nd row,2nd columnn)
plot(subset_data$timestamp,globalreactivepower,type='l',xlab='',ylab='Global_Reactive_Power')



dev.off()