# convert path
# D:\Research\PAPERS\finance\cryptocurrency

if (!"tm" %in% installed.packages()){
  install.packages("tm")
} else{
  print('the package is already installed!')
}

library(tm)
print("loaded 'tm' package")

preps <- c('in', 'on', 'the', 'The', 'this', 'This', 'with', 'and', 'And', 'be', 'Be', 'of', 'would', 'could', 'under', 'Under', 'above', 'Above', 'Below', 'below', 'is', 'was', 'being', 'Being', 'to', 'To', 'With', 'which', 'Which', 'shall', 'Shall', 'On', 'not', 'Not', 'None', 'none', 'made', 'Made', 'Make', 'make', 'it', 'its', 'It', 'has', 'Has', 'from', 'From', 'For', 'for', 'been', 'Been', 'Being', 'being', 'a', 'A', 'as', 'As', 'can', 'could', 'Can', 'Could', 'using', 'Using', 'many', 'Many', 'also', 'Also', 'use', 'Use', 'used', 'Used')

convertPath <- function(){
  path <- readline() # paste the path
  pathch <- gsub('\\\\', '/', path)
  return(pathch)
}

# convertPath()

filePath <- function(path, filename){
  return(file.path(path, filename))
}

# filepath <- filePath(getwd(), "cryptocurrency-and-healthcare-scopus.csv")

importDataFile <- function(filepath){
  dfile <- read.csv(filepath)
  print(names(dfile))
  return(dfile)
}

# datafile <- importDataFile(filepath)

# class(datafile)
# names(datafile)

makeAbstracts <- function(datafile){
  abs <- datafile['Abstract']
  cat(class(abs), 'with', dim(abs)[1], 'rows and', dim(abs)[2], 'columns were',  'created')
  return(abs)
}

# abs <- makeAbstracts(datafile)
# class(abs) # first abstract
# dim(abs)
# abs[1, ]
# strsplit(abs[1, ], ' ')
# table(abs[1, ])

convertAbstractToDataSet <- function(abstract){
  return(data.frame(table(strsplit(abstract, ' '))))  
}

# dvector <- convertAbstractToDataSet(abs[1, ])
# names(dvector)

# subset(dvector, Freq > 1)
cleanData <- function(data_, th=NULL){
  return(subset(data_, Freq > th & !data_$Var1 %in% preps))  
}

# cdata <- cleanData(dvector, th=1)

plotDataSet <- function(dset){
  plot(dset); text(dset, labels = dset[, 1])
} 

# plotDataSet(cdata)


# abscorp <- VCorpus((VectorSource(t(abs))))

makeCorpus <- function(abs){
  corp_ <- VCorpus((VectorSource(t(abs))))
  print(corp_)
  return(corp_)
}

# corpusout <- makeCorpus(abs)
# 
# corp_ <- tm_map(abscorp, stripWhitespace)
# corp_ <- tm_map(corp_, content_transformer(tolower))
# corp_ <- tm_map(corp_, removeWords, stopwords("english"))
# corp_ <- tm_map(corp_, removeNumbers)
# corp_ <- tm_map(corp_, removePunctuation)
# adtm <- DocumentTermMatrix(corp_)
# dim(adtm)
# tm::inspect(adtm[210:215, ])
# 
# adf <- data.frame(as.matrix(adtm))
# class(adf)
# dim(adf)
# names(adf)
# head(adf)[, 1:3]
# adf[, 'context']

cleanCorpusAndMakeDF <- function(abs, DF=FALSE, sparcity = NULL){
  abscorp <- VCorpus((VectorSource(t(abs))))
  corp_ <- tm_map(abscorp, stripWhitespace)
  corp_ <- tm_map(corp_, content_transformer(tolower))
  corp_ <- tm_map(corp_, removeWords, stopwords("english"))
  corp_ <- tm_map(corp_, removeNumbers)
  corp_ <- tm_map(corp_, removePunctuation)
  adtm <- DocumentTermMatrix(corp_)
  
  if (DF & !is.null(sparcity)){
    dataframe <- data.frame(as.matrix(removeSparseTerms(adtm, sparcity)))
    return(dataframe)
    print(dim(dataframe))
  } else {
    dataframe <- data.frame(as.matrix(adtm))
    return(dataframe)
  }
}

# dataframe <- cleanCorpusAndMakeDF(abs, DF=T)
# dim(dataframe)
# names(dataframe[, 71:75])
# dataframe_ <- dataframe[, 71:dim(dataframe)[2]]
# dim(dataframe_)
# head(dataframe_[, 4820:4824])

# https://stackoverflow.com/questions/9856632/subset-rows-with-1-all-and-2-any-columns-larger-than-a-specific-value
# subset(dataframe_, )

removePreps <- function(dataframe, preps){
  names_ <- !names(dataframe) %in% preps
  dataframe_ <- dataframe[, names_]
  return(dataframe_)
}

# dataframe_new <- removePreps(dataframe, c('can', 'many', 'also', 'used', 'using'))
# head(dataframe_new)
# names(dataframe_new)

simdf <- function(r=NA){
  x <- matrix(runif(100), 10, 10)
  x <- as.data.frame(x)
  if(is.na(r)){
    return(x)  
  } else {
    return(round(x, r))
  }
}

appendDf <- function(xdf, grcrs, ydf=NA){
  cols_ <- grep(as.character(grcrs), names(xdf))
  ydf <- cbind(ydf, xdf[names(xdf)[cols_]])
  if ('ydf' %in% names(ydf)){
    return(subset(ydf, select = -c(ydf)))  
  } else {
    return(ydf)
  }
}

