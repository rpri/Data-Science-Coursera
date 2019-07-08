library(plotly)
data("presidential")
d<-data.frame(presidential)
d$t<-d$end - d$start
plot_ly(presidential,y=d$t,color=d$name,type="box")
