library (stringi)
library(stringi) # stats files
library(NLP)
library(openNLP)
library(tm) # Text mining
library(rJava)
library(RWeka) # tokenizer - create unigrams, bigrams, trigrams
library(RWekajars)
library(SnowballC) # Stemming
library(RColorBrewer) # Color palettes
library(qdap)

#Reading RDS files


#Loading data

blog<-readRDS("~/Documents/Practical machine learning/Capstone/final_project/blog_stored")
news<-readRDS("~/Documents/Practical machine learning/Capstone/final_project/news_stored")
twitter<-readRDS("~/Documents/Practical machine learning/Capstone/final_project/twitter_stored")


###Exploratory data analysis

#SIZE of files
#file.info("~/Documents/Practical machine learning/Capstone/final_project/en_US.blogs.txt")$size
#file.info("~/Documents/Practical machine learning/Capstone/final_project/en_US.news.txt")$size
#file.info("~/Documents/Practical machine learning/Capstone/final_project/en_US.twitter.txt")$size

#number of lines in files
length(blog)
length(news)
length(twitter)

#number of tokens(words) in files
sum(stri_count_words(blog))
sum(stri_count_words(news))
sum(stri_count_words(twitter))

#Data sample (subset) obtained for analysis
set.seed(2)
#data_blog<-sample(blog,size=5000,replace = FALSE)
#data_news<-sample(news,size=5000,replace = FALSE)
#data_twitter<-sample(twitter,size=5000,replace = FALSE)

## Data cleaning 

#drop non UTF-8 characters
data_twitter <- iconv(twitter, from = "latin1", to = "UTF-8", sub="")
data_twitter<- stri_replace_all_regex(twitter, "\u2019|`","'")
data_twitter<- stri_replace_all_regex(twitter, "\u201c|\u201d|u201f|``",'"')
###########
training <- .5
#devtesting <- .01
testing <- .01

#if( (training + devtesting + testing) > 100) {#  testing <- 100 - training - devtesting}

all.train <- c()#checkk
all.test <- c()  #checkkk
#all.devtest <- c()
#for data_blog
  
  numLines <- length(blog)
  sampleSize <- (numLines * training / 100)
  sampledIds <- sample(1:length(blog), sampleSize) #for training
  sampledLines_blog <- blog[sampledIds]
  blog1 <- blog[-sampledIds]
  sampleSize <- (numLines * testing / 100)
  sampledIds <- sample(1:length(blog1), sampleSize) #for testing
  sampledLines_blog_test <- blog1[sampledIds]
  saveRDS( sampledLines_blog_test,"~/Documents/Practical machine learning/Capstone/final_project/blogstored_train.rds")
  
  #for data_news
  numLines <- length(news)
  sampleSize <- (numLines * training / 100)
  sampledIds <- sample(1:length(news), size=sampleSize) #for training
  sampledLines_news <- news[sampledIds]
  news1 <- news[-sampledIds]
  sampleSize <- (numLines * testing / 100)
  sampledIds <- sample(1:length(news1), size=sampleSize) #for testing
  sampledLines_news_test <-news1[sampledIds]
  saveRDS( sampledLines_news_test,"~/Documents/Practical machine learning/Capstone/final_project/newsstored_train")
  
  #for data_twitter
  numLines <- length(twitter)
  sampleSize <- (numLines * training / 100)
  sampledIds <- sample(1:length(twitter), size=sampleSize) #for training
  sampledLines_twitter<-twitter[sampledIds]
  twitter1<- twitter[-sampledIds]
  sampleSize <- (numLines * testing / 100)
  sampledIds <- sample(1:length(twitter1), sampleSize) #for testing
  sampledLines_twitter_test <-twitter1[sampledIds]
  saveRDS( sampledLines_twitter_test,"~/Documents/Practical machine learning/Capstone/final_project/twitterstored_train.rds")
    
  data_all<- c(sampledLines_blog,sampledLines_news,sampledLines_twitter)
  data_test<-c(sampledLines_blog_test,sampledLines_news_test,sampledLines_twitter_test)
  
  saveRDS(data_all,"~/Documents/Practical machine learning/Capstone/final_project/allstored_train.rds")
  #save one file with sampled training data from 
  
  
  #all.devtest <- c(all.devtest, sampledLines)
  #check saveRDS(sampledLines, sprintf("%s/%s.devtest.rds", data.raw.dir, src))
  
#  txt <- txt[-sampledIds]
 # sampleSize <- round(numLines * testing / 100)
  #if (sampleSize >= length(txt)) {
   # sampledLines <- txt
  #} else {
   # sampledIds <- sample(1:length(txt), sampleSize) #  for testing
    #sampledLines <- txt[sampledIds]
  #}
  #all.test <- c(all.test, sampledLines)
  #saveRDS(sampledLines, sprintf("%s/%s.test.rds", data.raw.dir, src))
#}


#data<-c(data_blog,data_news,data_twitter)# concatenating 3 files
data1<-VCorpus(VectorSource(data_all)) #reading text as lists

#data cleaning-
#' clean_text <- function (string) {
#'                                  temp <-tolower(string)
#'                                  #remove  characters  other than letters
#'                                  temp<-stringr::str_replace_all(temp,'[^a-zA-Z\\s]','')
#'                                  #remove white spaces to just 1
#'                                  temp<-stringr::str_replace_all(temp,'[\\s]+',' ')
#'                                  #Splitting
#'                                  temp<- stringr::str_split(temp,' ')[[1]]
#'                                  index<-which(temp=='')
#'                                  if(length(index)>0){
#'                                        temp<-temp[-index]}
#'                                        return(temp)
#'                                                }
#' Clean_Text_Block <- function(text) {
#'                                  if(length(text) <= 1){
#'                                  # Check if there is any text with another condition
#'                                  if(length(text) == 0){
#'                                     cat("There was no text in this document! \n")
#'                                     to_return <- list(num_tokens = 0,  unique_tokens = 0, text = "")}
#'                                     else{
#'                                          # If there is , and only only one line of text                                              then tokenize it
#'                                         clean_text <- Clean_String(text)
#'                                         num_tok <- length(clean_text)
#'                                         num_uniq <- length(unique(clean_text))
#'                                         to_return <- list(num_tokens = num_tok, unique_tokens = num_uniq, text = clean_text)}
#' 
#'                                           }
#'                                 else{
#'                                     # Get rid of blank lines
#'                                     indexes <- which(text == "")
#'                                     if(length(indexes) > 0){
#'                                     text <- text[-indexes]
#'                                         }
#' #   Loop through the lines in the text and use the append() function to
#'     clean_text <- Clean_String(text[1])
#'     for(i in 2:length(text)){
#'       # add them to a vector
#'       clean_text <- append(clean_text,Clean_String(text[i]))
#'     }
#'     # Calculate the number of tokens and unique tokens and return them in a  named list object.
#'     num_tok <- length(clean_text)
#'     num_uniq <- length(unique(clean_text))
#'     to_return <- list(num_tokens = num_tok, unique_tokens = num_uniq, text = clean_text)
#'   }
#'   return(to_return)
#' }
#' 
#' Clean_String <- function(string){
#'   # Lowercase
#'   temp <- tolower(string)
#'   #' Remove everything that is not a number or letter (may want to keep more
#'   #' stuff in your actual analyses).
#'   temp <- stringr::str_replace_all(temp,"[^a-zA-Z\\s]", " ")
#'   # Shrink down to just one white space
#'   temp <- stringr::str_replace_all(temp,"[\\s]+", " ")
#'   # Split it
#'   temp <- stringr::str_split(temp, " ")[[1]]
#'   # Get rid of trailing "" if necessary
#'   indexes <- which(temp == "")
#'   if(length(indexes) > 0){
#'     temp <- temp[-indexes]
#'   }
#'   return(temp)
#' }
#' 
#' clean_data <- Clean_Text_Block(data1)
#' str(clean_data)
#' 
#' clean_data_test <- Clean_Text_Block(data_test)
#removing profanity
#profanityWords = readLines('profanity-words.txt')
#data1 <- tm_map(data1,removeWords, profanityWords)

data1<- tm_map(data1, content_transformer(removeNumbers)) # removing numbers

#removeURL <- function(x) gsub("http[[:alnum:]]*", "", x)
#data1 <- tm_map(data1, content_transformer(removeURL))

data1 <- tm_map(data1, removeWords, stopwords("english")) # removing stop words in English (a, as, at, so, etc.)

data1 <- tm_map(data1, stripWhitespace) ## Stripping unnecessary whitespace from document


## Convert Corpus to plain text document
data1 <- tm_map(data1, PlainTextDocument) 
##  textcorpus
#for (i in 1:10){
#  print(textCorpus[[i]]$content)
#}

##profanity filtering
#profanityWords <- read.table("./profanityfilter.txt", header = FALSE)
#data1<- tm_map(data1, removeWords, profanityWords)
## Saving the final corpus

#save files containing data samples from all corpus
#saveRDS(all.train, sprintf("%s/all.train.rds", data.raw.dir))
#saveRDS(all.devtest, sprintf("%s/all.devtest.rds", data.raw.dir))
#aveRDS(data_clean, sprintf("%s/all.test.rds", data.raw.dir))
#corpus(data1)
saveRDS(data1,"~/Documents/Practical machine learning/Capstone/final_project/data_clean.RDS")
