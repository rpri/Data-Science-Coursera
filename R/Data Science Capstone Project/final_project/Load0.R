library (stringi)
library(stringi) # stats files

library(qdap)
#Load data

#destination_file <- "Coursera-SwiftKey.zip"
#source_file <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"

# execute the download
#download.file(source_file, destination_file)

# extract the files from the zip file
#unzip(destination_file)

#Reading files


#Loading data

#blogsURL <- file("en_US.blogs.txt", open="rb") # open for reading in binary mode

#blogs <- readLines(blogsURL, encoding = "UTF-8", skipNul=TRUE)
con <- file("~/Documents/Practical machine learning/Capstone/final_project/en_US.blogs.txt", "r") 
blog<-readLines(con, skipNul = TRUE) 
close(con)
# ewsURL <-file("en_US.news.txt",open= "rb") # open for reading in binary mode
#news <- readLines(newsURL, encoding = "UTF-8", skipNul=TRUE)
con <- file("~/Documents/Practical machine learning/Capstone/final_project/en_US.news.txt", "r") 
news<-readLines(con, skipNul = TRUE)
close(con)
# open file("en_US.twitter.txt"for reading in binary mode
con <- file("~/Documents/Practical machine learning/Capstone/final_project/en_US.twitter.txt", open = "rb") 
#twitter <- readLines(twitterURL, encoding = "UTF-8", skipNul=TRUE)
twitter<-readLines(con , skipNul = TRUE)
close(con)

#save files

saveRDS(blog,"~/Documents/Practical machine learning/Capstone/final_project/blog_stored.rds")
saveRDS(news,"~/Documents/Practical machine learning/Capstone/final_project/news_stored.rds")
saveRDS(twitter,"~/Documents/Practical machine learning/Capstone/final_project/twitter_stored.rds")

