library(dplyr)
library(data.table)
library(ggplot2)
data <- read.csv("~/Documents/activity.csv")
str(data)
head (data)
data$date<-as.Date(data$date)
data_WoNA <- data[complete.cases(data),]

## Loading and preprocessing the data




## What is mean total number of steps taken per day?

mean1 <-tapply(data_WoNA$steps,data_WoNA$date,mean)
head(mean1)
steps_day <- aggregate(steps~date,data_WoNA,sum)
hist(steps_day$steps,xlab='Days',ylab='Total no of Steps each day',main='Histogram representing total no of steps each day')

median1 <- tapply(data_WoNA$steps,data_WoNA$date,median)
head(median1)



## What is the average daily activity pattern?

steps_interval<-aggregate(steps~interval,data_WoNA,mean)
plot(steps_interval$interval,steps_interval$steps,type='l',xlab ='Interval',ylab='Steps',col='blue',main='Average number of steps by Interval')
max <-steps_interval[which.max(steps_interval$steps),1]

## Inputing missing values

miss<- nrow(data)-nrow(data_WoNA)
miss

colnames(steps_interval)[2]<-"Meansteps"
data_imputed <- merge (data, steps_interval)

avg_interval <- aggregate(steps~interval,data_imputed,mean)
data_imputed$steps[is.na(data_imputed$steps)] <- data_imputed$Meansteps
data_avgstepsday <- aggregate(steps~date,data_imputed,sum)
hist(data_avgstepsday$steps,xlab='Days',main='Total number of steps each day (after fillling missing values',ylab='Total no of Steps each day')
m <- tapply(data_imputed$steps,data_imputed$date,mean)
sprintf("Mean is ",m)
med <- tapply(data_imputed$steps,data_imputed$date,median)
sprintf ("Median is",med)

## Are there differences in activity patterns between weekdays and weekends?



data_imputed$day <-weekdays (as.Date(data_imputed$date))

data_imputed$weekend <-factor(data_imputed$day,levels = c('weekday','weekend'))

data_imputed$weekend = ifelse(data_imputed$day %in% c("Saturday", "Sunday"), "Weekend", "Weekday")

a <- aggregate(steps~interval + weekend,data_imputed ,mean)

s <- ggplot(a,aes(x=interval,y=steps,color=weekend))+geom_line()+facet_wrap(~weekend,ncol=1,nrow=2)
print(s)
