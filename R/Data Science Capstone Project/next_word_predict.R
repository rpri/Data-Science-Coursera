tdm <- TermDocumentMatrix(mod_corp,control=list(
  tokenize=TrigramTokenizer,
  wordLengths=c(1,Inf)))
# combine all 
trifreq <- rowSums(as.matrix(tdm))

sptword <- strsplit(names(trifreq)," ")
df_trifreq <- data.frame(
  word1 = sapply(sptword,function(x){x[1]}),
  word2 = sapply(sptword,function(x){x[2]}),
  wpred = sapply(sptword,function(x){x[3]}),
  freq  = trifreq
)

# find words that can be selected 
selpred           <- df_trifreq$wpred %in% dic_pred
df_trifreq        <- df_trifreq[selpred,]
df_trifreq$wpred  <- as.factor(as.character(df_trifreq$wpred)) 

#when oth firs and second words known
selwd <- (! df_trifreq$word1 %in% dic_mod) & (! df_trifreq$word2 %in% dic_mod)
df_trifreq0 <- df_trifreq[selwd,]
# Sum up frequencies of as a function of predicted words
df_trifreq0 <- aggregate(df_trifreq0$freq,
                         by=list(df_trifreq0$wpred),FUN="sum")
names(df_trifreq0) <- c("wpred","freq")

##
#when only first word is known

selwd              <- df_trifreq$word1 %in% dic_mod & (! df_trifreq$word2 %in% dic_mod)
df_trifreq1        <- df_trifreq[selwd,]
df_trifreq1$word1  <- as.factor(as.character(df_trifreq1$word1))
# Sum up frequencies of as a function of predicted words and first word
df_trifreq1        <- aggregate(df_trifreq1$freq,
                                by=list(df_trifreq1$word1,df_trifreq1$wpred),FUN="sum")
names(df_trifreq1) <- c("word1","wpred","freq")

#only second word known
selwd              <- df_trifreq$word1 %in% dic_mod & (! df_trifreq$word2 %in% dic_mod)
df_trifreq1        <- df_trifreq[selwd,]
df_trifreq1$word1  <- as.factor(as.character(df_trifreq1$word1))
# Sum up frequencies of as a function of predicted words and first word
df_trifreq1        <- aggregate(df_trifreq1$freq,
                                by=list(df_trifreq1$word1,df_trifreq1$wpred),FUN="sum")
names(df_trifreq1) <- c("word1","wpred","freq")

#when both known

selwd <- df_trifreq$word1 %in% dic_mod & df_trifreq$word2 %in% dic_mod
df_trifreq3 <- df_trifreq[selwd,]
df_trifreq3$word1  <- as.factor(as.character(df_trifreq3$word1))
df_trifreq3$word2  <- as.factor(as.character(df_trifreq3$word2))


#model

predict_most_frequent <- function(gram_select){
  # returns the most frequent third word
  # from a subset of the trigram data frame 
  if(nrow(gram_select)==1) {ipredict = 1
  } else{
    tiebreak <- wfreq[gram_select$wpred]
    ipredict <- order(gram_select$freq,tiebreak,decreasing=TRUE)[1]}
  as.character(gram_select$wpred[ipredict])
}
fetch_predictions <- function(list_freq){
  # This is a conditionnal 1 gram model
  # returns a list of predicted words as a function
  # of the word used to subset part of the trigram data frame
  prd_gram    <-c()
  for(word in names(list_freq)){
    prd_gram <- c(prd_gram,predict_most_frequent(list_freq[[word]]))}
  prd_gram
}


word_prediction <- data.frame(
  "word1"="*",
  "word2"="*",
  "prediction"=predict_most_frequent(df_trifreq0))
rm(df_trifreq0)

df_trifreq1 <- split(df_trifreq1,df_trifreq1$word1)
new_prediction <- data.frame(
  "word1" = names(df_trifreq1),
  "word2" = rep("*",length(df_trifreq1)),
  "prediction" = fetch_predictions(df_trifreq1))
word_prediction <- rbind(word_prediction,new_prediction)
rm(new_prediction,df_trifreq1)


