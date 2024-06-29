# path conversions

setwd('~')
getwd()

path <- convertPath() 
# D:\
print(path)
setwd(path)
getwd()

if (!file.exists('demo')){
  dir.create('demo')
} 

setwd('demo')
getwd()

list.files()

# working with literature

row1 <- 'Wikipedia is a free online encyclopedia, created and edited by volunteers around the world and hosted by the Wikimedia Foundation.'
row2 <- 'Wikimedia is a global movement whose mission is to bring free educational content to the world.'

df_ <- as.data.frame(rbind(row1, row2))
is.data.frame(df_)

dim(df_)
df_[1, ]
df_[2, ]
names(df_)

absdf <- cleanCorpusAndMakeDF(df_)
names(absdf)

class(absdf)
typeof(absdf)

absdf[, 1]
summary(absdf[, 1])


           