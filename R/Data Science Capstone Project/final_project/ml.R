library(data.table)

#4gram model, predict w4 using w1,w2,w3 as predictors
model.w1w2w3 <- function(dt, k.min = 2, n.top = 1) {
  dt <- dt[, .(w4, k, s=round(k/sum(k), 6)), by=.(w1,w2,w3)]
  dt <- dt[k >= k.min][order(-s)][,head(.SD, n.top), by=.(w1,w2,w3)]
  dt[, k:=NULL]
  setkey(dt, w1,w2,w3)
  dt
}


#3gram model, predict w4 using w2,w3 as predictors
model.w2w3 <- function(dt, k.min = 2, n.top = 1) {
  dt <- dt[, .(k=sum(k)), by=.(w2,w3,w4)]
  dt[, s:=round(k/sum(k), 6), by=.(w2,w3)]
  dt <- dt[k >= k.min][order(-s)][,head(.SD, n.top), by=.(w2,w3)]
  dt[, k:=NULL]
  setkey(dt, w2,w3)
  dt
}


#2gram model, predict w4 using w3 as predictor
model.w3 <- function(dt, k.min = 2, n.top = 1) {
  dt <- dt[, .(k=sum(k)), by=.(w3,w4)]
  dt[, s:=round(k/sum(k), 6), by=.(w3)]
  dt <- dt[k >= k.min][order(-s)][,head(.SD, n.top), by=.(w3)]
  dt[, k:=NULL]
  setkey(dt, w3)
  dt
}
#unigram model, necessary for backoff in PR calculations
model.w4 <- function(dt) {
  dt <- tetr[, .(k=sum(k)), by=.(w4)]
  dt[, s:=round(k/sum(k), 6)]
  dt[, k:=NULL]
  setkey(dt, w4)
  dt
}