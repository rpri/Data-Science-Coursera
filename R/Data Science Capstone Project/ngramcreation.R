library(plyr);
library(dplyr)
library(knitr)
library(tm)
library(stringi)
library(RWeka)
library(ggplot2)
library(slam)

#n-tokeniser
ngramer<- function (n) {
                  t<- function (x) 
                           RWeka :: NGramTokenizer(x, RWeka::Weka_control(min = n, max = n, delimiters = " \\r\\n\\t"))
}

#build table of ngrams

ngram_table <-function(data){
                  if (is.null(data$txt)) {data$txt <- readRDS(sprintf("%s/%s.rds", data.clean.dir, data$corpus))}
                  if(is.null(data$ids)) {if (!is.null(data$chunkNumber) & (data$chunkSize * data$chunkNumber) < data$lines) {data$ids <- sampleIds(data)}
                    else {data$ids <- initIds(data)  }
  
data$ngramer <- ngramer(data$ng) ##check variable
data$maxLength <-25+15*(data$ng-1)
  if (data$ng > 1) {if(is.null(data$dict.name)) {  data$dict.name <- "pr.975"  }
  data$dict <- readRDS(sprintf("%s/dict.%s.rds", model.data.dir, data$dict.name))
                     }
#t <- system.time(buildNGramChunks(data))
#printf("%d chunks built in %.3f sec.\n", nrow(data$ids), t[3])
#t <- system.time(data <- mergeFileChunks(data))
#printf("%d chunks merged in %.3f \n\n\n", nrow(data$ids), t[3])
data
}

#' split data in Ngram chunks, save 1 file per chunk
split_in_ngchunks <- function(data) {
                                    ids <- data$ids
                                    txt <- data$txt
                                    ngramer <- data$ngramer
                                    maxLength <- data$maxLength
                                    dict <- data$dict
                                    ng <- data$ng
    chunk.file <- sprintf("%s/%s.%s.%%d.rds", model.data.dir, data$corpus, data$suffix)#check variable names
    for(i in 1:nrow(ids)) {
      #t0 = Sys.time()
      ngrams.tmp <- nGramizeChunk(txt[ids[i,]], ngramer, maxLength, ng, dict)
      saveRDS(ngrams.tmp, sprintf(chunk.file, i))
      rm(ngrams.tmp)
      #printf("chunk %d built in %.3f \n", n, Sys.time() - t0)
    }
}

#merging of chunks into 1 table
merge_Chunks <- function(data) {
  chunk.file <- sprintf("%s/%s.%s.%%d.rds", model.data.dir, data$corpus, data$suffix)
  tmp.file <- sprintf(chunk.file, 1)
  ngrams <- readRDS(tmp.file)
  file.remove(tmp.file)
  for(n in 2:nrow(data$ids)) {
    #t0 = Sys.time()
    tmp.file <- sprintf(chunk.file, n)
    ngrams.tmp <- readRDS(tmp.file)
    ngrams <- merge_Chunks(ngrams, ngrams.tmp)
    rm(ngrams.tmp)
    file.remove(tmp.file)
    #printf("chunk %d merged in %.3f \n", n, Sys.time() - t0)
  }
  if (data$ng > 1) {    ngrams[,w:=NULL]  }
  ngram.file <- sprintf("%s/%s.%s.rds", model.data.dir, data$corpus, data$suffix)
  saveRDS(ngrams, ngram.file)
  data$ngrams <- ngrams
  data
}

#create data table from chunks 
ng_table <- function(lines, ngramer, maxLength, ng, dict = NULL) {
  ngrams <- ngramer(lines)
  ngrams <- ngrams[nchar(ngrams) <= maxLength]
  dt <- data.table(w=ngrams, k=1)
  setkey(dt, w)
  dt <- dt[, list(k=sum(k)), by=w]
  rm(ngrams)
  if (ng > 1) {  dt <- ng_split(dt, ng, dict)
          if(ng == 2) { dt <- dt[, list(k=sum(k)), by=list(w1, w2)] }}
          else if (ng == 3) { dt <- dt[, list(k=sum(k)), by=list(w1, w2, w3)]}}
          else if (ng == 4) { dt <- dt[, list(k=sum(k)), by=list(w1, w2, w3, w4)]}}
dt$w <- do.call(paste,  subset(dt, select = !colnames(dt) %in% c("k", "w")))}
dt}
    
  
# Prepare n-gram frequencies
getFreq <- function(tdm) {
  freq <- sort(rowSums(as.matrix(rollup(tdm, 2, FUN = sum)), na.rm = T), decreasing = TRUE)
  return(data.frame(word = names(freq), freq = freq))
}

#split ngram-storing 1 value in 1 column
splitNGrams <- function(dt, ng, dict) { tmp <- strsplit(as.character(dt$w), " ")
                                        dt[, w1:=sapply(tmp, "[", 1)]
                                       if (ng == 2) { dt[, w2:=sapply(tmp, "[", 2)]
                                                      dt[!w2 %in% dict, w2:="<U>"]}
                                       else if (ng == 3) {dt[, w2:=sapply(tmp, "[", 2)]
                                                          dt[, w3:=sapply(tmp, "[", 3)]
                                                          #replace words not in dictionary with special mark
                                                          dt[!w2 %in% dict, w2:="<U>"]
                                                          dt[!w3 %in% dict, w3:="<U>"]  } 
                                       else if (ng == 4) { dt[, w2:=sapply(tmp, "[", 2)]
                                                           dt[, w3:=sapply(tmp, "[", 3)]
                                                           dt[, w4:=sapply(tmp, "[", 4)]
                                                           #replace words not in dictionary with special mark
                                                           dt[!w2 %in% dict, w2:="<U>"]
                                                           dt[!w3 %in% dict, w3:="<U>"]
                                                           dt[!w4 %in% dict, w4:="<U>"]
                                                           }
                                                  #replace words not in dictionary with special mark
                                                  dt[!w1 %in% dict, w1:="<U>"]
                                                  dt
                                                  }


#merge 2 ngrams tables in one
merge_Chunk <- function(a, b) {
                              setkey(a, w);setkey(b, w)
                              a$k[a$w %in% b$w] <-  a$k[a$w %in% b$w] + b$k[b$w %in% a$w]
                              a <- rbindlist(list(a, b[!w %in% a$w]))
                              rm(b)
                              setkey(a,w)
                              a
                              }


sampleIds <- function(data) {if (is.null(data$seed)) {data$seed = 123456  }
set.seed(data$seed)
sampled <- sample(1:data$lines, data$chunkNumber * data$chunkSize, replace = F)
matrix(sampled, nrow = data$sampleSize, ncol = data$chunkSize, byrow = T)
}


#return ids of lines to be used in testing, ie, lines excluded from the training set
testIds <- function(data) {  if (is.null(data$ids)) { data$ids <- sampleIds(data)}
matrix(setdiff(1:data$lines, c(data$ids)), nrow = data$sampleSize, ncol = data$chunkSize, byrow = T)
 }

#sort ngram table in decreasing order of frequency
orderNGrams <- function(dt) {  dt[order(dt$k, decreasing = T),]}

##order ngram 
  

#bigram <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
#trigram <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
#quadgram <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))
#pentagram <- function(x) NGramTokenizer(x, Weka_control(min = 5, max = 5))
#hexagram <- function(x) NGramTokenizer(x, Weka_control(min = 6, max = 6))

# Get frequencies of most common n-grams in data sample
#freq1 <- getFreq(removeSparseTerms(TermDocumentMatrix(unicorpus), 0.999))
#save(freq1, file="nfreq.f1.RData")
#freq2 <- getFreq(TermDocumentMatrix(unicorpus, control = list(tokenize = bigram, bounds = list(global = c(5, Inf)))))
#save(freq2, file="nfreq.f2.RData")
#freq3 <- getFreq(TermDocumentMatrix(corpus, control = list(tokenize = trigram, bounds = list(global = c(3, Inf)))))
#save(freq3, file="nfreq.f3.RData")
#freq4 <- getFreq(TermDocumentMatrix(corpus, control = list(tokenize = quadgram, bounds = list(global = c(2, Inf)))))
#save(freq4, file="nfreq.f4.RData")
#freq5 <- getFreq(TermDocumentMatrix(corpus, control = list(tokenize = pentagram, bounds = list(global = c(2, Inf)))))
#save(freq5, file="nfreq.f5.RData")
#freq6 <- getFreq(TermDocumentMatrix(corpus, control = list(tokenize = hexagram, bounds = list(global = c(2, Inf)))))
#save(freq6, file="nfreq.f6.RData")
#nf <- list("f1" = freq1, "f2" = freq2, "f3" = freq3, "f4" = freq4, "f5" = freq5, "f6" = freq6)
#save(nf, file="nfreq.v5.RData")


