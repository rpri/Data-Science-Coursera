library(data.table)
library(dplyr)

setwd("~/Documents/Stats_inference_project")
set.seed(2016)

lambda <-0.2
n<-40
nosim<-1000

coverage<-replicate(nosim,rexp(n,lambda))
means_exp<-apply(coverage,2,mean)
hist(means_exp,breaks=60,xlim=c(2,10),col='blue',main='Simulation of Exponential Function Means',ylab='Means')


