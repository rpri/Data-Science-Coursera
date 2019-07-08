#source("scripts/globals.R")
source("~/Documents/Practical machine learning/Capstone/final_project/ml.R")

data <- list(corpus = "all.train")#cgheckkkkkkkkk
data$suffix <- "tetrag"
ngram.file <- "tetra_all.pr.975"###checkkk
tetr <- readRDS(ngram.file)
setkey(tetr, w1,w2,w3)

#filter <- c("<URL>", "<U>", "<S>", "<NN>", "<ON>", "<N>", "<T>" , "<D>", "<PN>", "<EMAIL>", "<HASH>", "<YN>", "<TW>")

#for production app, filter special words in the output
#tetr <- tetr[!w4 %in% filter]

#build models, 
k.min = 2; n.top = 3;
model = list()
model$w1w2w3 <- model.w1w2w3(tetr, k.min, n.top)
model$w2w3 <- model.w2w3(tetr, k.min, n.top)
model$w3 <- model.w3(tetr, k.min, n.top)
model$w4 <- model.w4(tetr)
#model$w1w2 <- model.w1w2(tetr, k.min, n.top)
#model$w1w3 <- model.w1w3(tetr, k.min, n.top)
#model$w1 <- model.w1(tetr, k.min, n.top)
#model$w2 <- model.w2(tetr, k.min, n.top)

model.name <- "MLE.all.ext"
model.file <- ("~/Documents/Practical machine learning/Capstone/final_project/pred_data_kmin2ntop3.rds")
saveRDS(model, model.file)