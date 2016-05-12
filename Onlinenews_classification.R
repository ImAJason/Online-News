##Classification
setwd ("/users/jasonwang")
setwd("desktop")
news<- read.csv("OnlineNewsPopularity.csv", header = T)
news<-news[,-c(1,2,38,39)]
dim(news)
y<-ifelse(news[,57]>1500,1,0) #categorize y
news<-cbind.data.frame(news[,1:56],y)

############################################
#Sample the training and test data sets
set.seed(1)
idx<-sample(dim(news)[1],30000)
train<-news[idx,]
test<-news[-idx,]

############################################
#logistic regression
glmfit<-glm(y~.,data=train,family=binomial)
summary(glmfit)
glmpred<-predict(glmfit,newdata=test,type="response")
glmresult<-ifelse(glmpred>0.5,1,0)
table(glmresult,test[,57])
library(caret)
confusionMatrix(glmresult,test[,57],positive="1")
print(paste("error rate of glm: ",mean(glmresult!=test[,57])))
library(ROCR)
pr<-prediction(glmpred,test[,57])
prroc<-performance(pr,measure="tpr",x.measure="fpr")
plot(prroc)
auc<- performance(pr, measure = "auc")
print(paste("auc:",auc@y.values[[1]]))

############################################
#SVM
library(e1071)
svmresult <- svm(y ~ ., data = train, kernel = "radial", cost = 10) 
svmpred = predict(svmresult,newdata=test, type="prob")
svmpr<-prediction(svmpred,test[,57]) 
svmprroc<-performance(svmpr,measure="tpr",x.measure="fpr") 
plot(svmprroc) 
auc<- performance(svmpr, measure = "auc") 
print(paste("svmauc:",auc@y.values[[1]])) 
svmresult<-ifelse(svmpred>0.5,1,0)
confusionMatrix(svmresult,test[,57],positive="1") 


############################################
#random forest
library(randomForest)
rf.news = randomForest(x = train[,1:56], y=as.factor(train[,57]),ntree=500,mtry=8,importance=TRUE)
rf.news
rf.pr = predict(rf.news,newdata=test, type="prob")[,2]
library(ROCR)
rfpr<-prediction(rf.pr,test[,57])
rfprroc<-performance(rfpr,"tpr","fpr")
plot(rfprroc)
rfauc<- performance(rfpr, measure = "auc")
print(paste("rfauc:",rfauc@y.values[[1]]))
library(caret)
rfresult<-ifelse(rf.pr>0.5,1,0) 
confusionMatrix(rfresult,test[,57],positive="1")
                 