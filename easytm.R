# convert path
# D:\Research\PAPERS\finance\cryptocurrency

pcks <- c('tm', 'caret', 'Boruta', 'TH.data')

for (i in pcks){
  if (!i %in% installed.packages()){
    install.packages(i)
  } else{
    print('the package is already installed!')
  }
}

for ( i in pcks){
  eval(bquote(library(.(i))))
}

preps <- c('.', ',', ':', ';', 'upon', 'Upon', 'under', 'Under', 'less', 'Less', 'more', 'More', 'our', 'Our', 'Over', 'over', 'an', 'by', 'There', 'there', 'We', 'or', 'these', 'that', 'we', 'find', 'finds', 'finding', 'found', 'but', 'by', '\n', '\t', 'in', 'on', 'the', 'The', 'this', 'This', 'with', 'and', 'And', 'be', 'Be', 'of', 'would', 'could', 'under', 'Under', 'above', 'Above', 'Below', 'below', 'is', 'was', 'being', 'Being', 'to', 'To', 'With', 'which', 'Which', 'shall', 'Shall', 'On', 'not', 'Not', 'None', 'none', 'made', 'Made', 'Make', 'make', 'it', 'its', 'It', 'has', 'Has', 'from', 'From', 'For', 'for', 'been', 'Been', 'Being', 'being', 'a', 'A', 'as', 'As', 'can', 'could', 'Can', 'Could', 'using', 'Using', 'many', 'Many', 'also', 'Also', 'use', 'Use', 'used', 'Used')
# length(preps)

convertPath <- function(){
  path <- readline() # paste the path
  pathch <- gsub('\\\\', '/', path)
  return(pathch)
}

plotWordVec <- function(v1, lbls){
  plot(v1)
  text(v1, labels = lbls)
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
cleanData <- function(data_){
  return(subset(data_, !data_$Var1 %in% preps))  
}

searchWord <- function(trm=NA, v1=NA){
  n_ <- grep(as.character(trm), v1[, 1])
  return(v1[n_, ])
}


# cdata <- cleanData(dvector, th=1)

plotDataSet <- function(dset){
  plot(dset); text(dset, labels = dset[, 1])
} 

# plotDataSet(cdata)


# abscorp <- VCorpus((VectorSource(t(abs))))

# dont use
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

# n <- grep('ability', names(df_)[1:200])
# litdf <- df_[, -c(1:n)]
# dim(df_)
# head(names(df_))

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
    n <- grep('ability', names(dataframe)[1:200])
    dataframe <- dataframe[, -c(1:n)]
    return(dataframe)
    print(dim(dataframe))
  } else {
    dataframe <- data.frame(as.matrix(adtm))
    n <- grep('ability', names(dataframe)[1:200])
    dataframe <- dataframe[, -c(1:n)]
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

searchPattern <- function(trm=NA, dataf){
  n <- grep(as.character(trm), names(dataf))
  for (i in n){
    print(names(dataf)[i])
  }
  return(n)
}

searchVariable <- function(trm, df_, output = FALSE){
  n <- grep(as.character(trm), names(df_))
  out <- df_[, n]
  if (output == TRUE){
    return(out)  
  } else {
    print(list(pattern = names(out), indices = n))
  }
}

simdf <- function(r=NA){
  x <- matrix(runif(100), 10, 10)
  x <- as.data.frame(x)
  if(is.na(r)){
    return(x)  
  } else {
    return(round(x, r))
  }
}

makeDfFromWord <- function(trm=NA, df1, df2){
  r1 <- searchWord('fake', df1)
  r2 <- searchWord('fake', df2)
  df_ <- rbind(r1, r2)
  rownames(df_) <- c('d1', 'd2')
  return(df_)
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

# feature selection

selectFeatures <- function(dataset, target = NA){
  boruta_output <- Boruta(eval(as.name(target)) ~ ., data=na.omit(dataset), doTrace=0)  
  
  roughFixMod <- TentativeRoughFix(boruta_output)
  boruta_signif <- getSelectedAttributes(roughFixMod)
  
  imps <- attStats(roughFixMod)
  imps2 = imps[imps$decision != 'Rejected', c('meanImp', 'decision')]
  orig_names_len <- length(names(dataset))
  final_names_len <- length(names(imps2))
  
  out <- list(onl = orig_names_len, final_nlen =  final_names_len, features = imps2, bo = boruta_output)
  return(out)  
}

# plot(boruta_output, cex.axis=.7, las=2, xlab="", main="Variable Importance")

# selectFeatures <- function(dataset, target = NA, tentative = TRUE, decision = 'rejected'){
#   boruta_output <- Boruta(eval(as.name(target)) ~ ., data=na.omit(dataset), doTrace=0)  
#   boruta_signif <- getSelectedAttributes(boruta_output, withTentative = TRUE) 
#   
#   plot(boruta_output, cex.axis=.7, las=2, xlab="", main="Variable Importance") 
#   
#   if (tentative==TRUE){
#     if (decision == 'rejected'){
#       imps <- attStats(boruta_signif)
#       imps2 = imps[imps, c('meanImp', 'decision')]
#       return(imps2[order(-imps2$meanImp), ])   
#     } else {
#       imps <- attStats(boruta_signif)
#       imps2 = imps[imps$decision != 'Rejected', c('meanImp', 'decision')]
#       return(imps2[order(-imps2$meanImp), ]) 
#     }
#   } else {
#     roughFixMod <- TentativeRoughFix(boruta_output)
#     boruta_signif <- getSelectedAttributes(roughFixMod)
#     
#     if (decision == 'rejected'){
#       imps <- attStats(roughFixMod)
#       imps2 = imps[imps$decision != 'Rejected', c('meanImp', 'decision')]
#       return(imps2[order(-imps2$meanImp), ])  
#     } else {
#        imps <- attStats(roughFixMod)
#       imps2 = imps[c('meanImp', 'decision')]
#       return(imps2[order(-imps2$meanImp), ])
#   }
#   }
# }

factanalPlot <- function(ds, nf = NA, l1=NA, l2=NA, tl = NA, xlim = c(-10, 10), ylim = c(-10, 10), cex = NA, pch = NA){
  if (nf == 2){
    plot(l1,
         l2,
         xlab = "Factor 1",
         ylab = "Factor 2",
         ylim = ylim,
         xlim = xlim, cex =cex,
         main = tl, pch=pch)
    abline(h = 0, v = 0)
    text(l1 - 0.08,
         l2 + 0.08,
         colnames(ds), cex = cex,
         col = "blue")
    abline(h = 0, v = 0)  
  } else {
    plot(l1,
         ylim = ylim,
         xlim = xlim, cex =cex,
         main = tl, pch = pch)
    abline(h = 0, v = 0)
    text(l1, 
         colnames(ds), cex = cex,
         col = "blue", pos= 3)
    abline(h = 0, v = 0)    
  }
}

selectFeaturesAndMakeOutputs <- function(ds, term = NA, nc = NA, outputs = TRUE, outputpaths = NA){
  trm_ <- selectFeatures(ds, term)
  
  df_ <- ds[rownames(trm_$features)]
  sums <- sapply(digitaldf, function(x) c(summary(x), type = class(x)))
  fafit <- factanal(df_, nc)
  
  if (outputs == TRUE){
    write.csv(sums, outputpath[1])
    write.csv(fafit$loadings, outputpath[2])
  } else {
    return(trm_$features)
  }
  
}

# factanalSingleFactorPlot <- function(ds, l1=NA, tl = NA, xlim = c(-10, 10), ylim = c(-10, 10), cex = NA){
#   
#   plot(l1,
#        ylim = ylim,
#        xlim = xlim, cex =cex,
#        main = tl)
#   abline(h = 0, v = 0)
#   text(l1, 
#        colnames(ds), cex = cex,
#        col = "blue", pos= 3)
#   abline(h = 0, v = 0)  
#   
# }

# dissimilar records

m1 <- data.frame(matrix(1:16, 4, 4), row.names = c('r1', 'r2', 'r3', 'r4'))
m2 <- data.frame(matrix(1:16, 4, 4), row.names = c('r1', 'r2', 'r5', 'r6'))

dis

mergeDataFrames <- function(df1, df2){
  df3 <- rbind(df1, df2)
  
  common_ <- intersect(df1$authors, df2$authors)
  commondf <- subset(df1, authors %in% common_) 
  differentdf <- subset(df3, !authors %in% common_)
  
  final_ <- rbind(commondf, differentdf)
  finaldf <- final_[order(final_$authors), ]
  return(finaldf)
}