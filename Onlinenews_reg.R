setwd ("/users/jasonwang")
setwd("desktop")
news<- read.csv("OnlineNewsPopularity.csv", header = T)
news<-news[,-c(1,2,38,39)]
dim(news)
colnames(news)<-as.list(paste0("v",1:57))
news<-as.matrix(news)
############################################
#Sample the training and test data sets
set.seed(1)
idx<-sample(dim(news)[1],30000)
train<-news[idx,]
test<-news[-idx,]
############################################
#Mean Absolute Error: Evaluation Rule
eval<- function(x,y)
{
  tmp<- abs(y - x)
  return(sum(tmp)/length(x))
}
pdf("figures.pdf")
############################################
#OLS
news.ols<-lm(v57~.,data=as.data.frame(train))
ols.pre<-predict(news.ols,as.data.frame(test[,1:56]))
ols.eval<-eval(ols.pre, test[, 57])
ols.eval
############################################
#forward selection
set.seed(1)
news.forw<- step(news.ols, direction = "forward", k = log(30000))
forw.pre<-predict(news.forw,as.data.frame(test[,1:56]))
forw.eval<-eval(forw.pre, test[, 57])
forw.eval
############################################
#stepwise selection
set.seed(1)
news.step<- step(news.ols, direction = "both", k = log(30000))
length(news.step$coefficient)-1 #calculate # of predictors
step.name<- names(news.step$coefficients)[-1]
step.name<-sub("v","",step.name)
step.name<-as.integer(step.name)
step.pre<- cbind(1, test[, step.name]) %*% news.step$coefficient
step.eval<-eval(step.pre,test[,57])
step.eval
############################################
#Ridge
library(glmnet)
newsri<-glmnet(train[,1:56],train[,57],alpha=0)
plot(newsri,xvar="lambda",main="Ridge")
set.seed(1)
news.ridge<-cv.glmnet(train[,1:56],train[,57],alpha=0)
plot(news.ridge,main="ridge")
ridge.coef<-predict(news.ridge,type ="coefficients",s=news.ridge$lambda.min)
length(which(ridge.coef!=0))-1
ridge.pre<-predict(news.ridge,test[,1:56],s=news.ridge$lambda.min)
ridge.eval<-eval(ridge.pre,test[,57])
ridge.eval
############################################
#LASSO
library(glmnet)
newsla<-glmnet(train[,1:56],train[,57],alpha=1)
plot(newsla,xvar="lambda",main="lasso")
set.seed(1)
news.lasso<-cv.glmnet(train[,1:56],train[,57],alpha=1)
plot(news.lasso,main="lasso")
lasso.coef<-predict(news.lasso,type ="coefficients",s=news.lasso$lambda.min)
length(which(lasso.coef!=0))-1
lasso.pre<-predict(news.lasso,test[,1:56],s=news.lasso$lambda.min)
lasso.eval<-eval(lasso.pre,test[,57])
lasso.eval
############################################
#SCAD
library(ncvreg)
set.seed(1)
cv.scad<-cv.ncvreg(train[,1:56],train[,57])
news.scad<-ncvreg(train[,1:56],train[,57],lambda = cv.scad$lambda.min)
plot(news.scad)
length(which(news.scad$beta!=0))-1
scad.pre<-predict(news.scad,test[,1:56])
scad.eval<-eval(scad.pre,test[,57])
scad.eval
############################################
#Compare models
all_eval<-c(ols.eval,step.eval,ridge.eval,lasso.eval,scad.eval)
all_eval
dev.off()
