### Description
---
Code for analysis and predictive modeling approaches to understand the popularity of online news. The data set was obtained from the [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/Online+News+Popularity)

### Objective
---
The objective was to test whether or not the popularity of news could be accurately predicted from features including title words, content, publication time, etc.

### Process
---
Applied different linear regression and variable selection methods of supervised learning on online news popularity prediction to find  the best fit.
  * Methods used: Linear regression, Ordinary least square(OLS), Foward selection, Backward selection, Stepwise selection, Best subset selection, Ridge regression, Least Absolute Shrinkage and Selection Operator(LASSO), Smooth Clipped Absolute Deviation(SCAD)


Applied different classification methods on the separation of popular online news from less-popular ones, and identified the method with the lowest classification error.
  * Methods used: Logistic regression, Support vector machines(SVM), Random Forest

### Result
---
Found LASSO to return the smallest mean absolute error among all the methods for linear regression and variable selection.

Achieved a 71.77% AUC with the random forest algorithm.

The popularity of online news is predictable! However, the accuracy could be higher. Future work can still be done to hopefully increase it.
