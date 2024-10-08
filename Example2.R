# Classification rule in discriminant analysis
require(mnormt) # for multivariate normal data generation

# Functions for classification
##############################################
# INPUT
# beta - supplied discriminant vector
# xtrain, ytrain - training data
# xtest, ytest - testing data
# ***xtrain/xtest are matrices with p columns
# ***ytrain/ytest are vectors; labels: 1 and 2
#
# OUTPUT
# ypred - predicted class membership
# error - percent of misclassified observations

classify_for <- function(beta, xtrain, ytrain, xtest, ytest){
  # [ToDo] Code discriminant analysis classifier using for loop
  
  # Calculate sample means based on training data:
    # calc sample means by pulling rows for each condition, then calc means
  x_bar1 <- colMeans(xtrain[ytrain == 1, ]) # can use drop=False
  x_bar2 <- colMeans(xtrain[ytrain == 2, ]) # can use drop=False
  
  # Calculate class assignments for xtest in a for loop
  npred <- nrow(xtest)
  ypred <- rep(1, npred) # pre-specify column of 1's
  
  for (i in 1:npred) {
    # Use h(x) rule to predict: 
    h1 <- as.numeric(crossprod((xtest[i, ] - xbar1), beta)^2) # (xtest[i, ] - xbar1).T %*% beta squared
    
    h2 <-  as.numeric(crossprod((xtest[i, ] - xbar2), beta)^2)
    
    # Classify ypred when not default case (h1 < h2):
    if(h2 < h1){
      ypred[i] <- 2
    }
    
  }
  
  # Calculate % error using ytest
  error <- 100 * mean(ypred != ytest) # mean used rather than sum() / npred
  
  
  # Return predictions and error
  return(list(ypred = ypred, error = error))
}


classify_vec <- function(beta, xtrain, ytrain, xtest, ytest){
  # [ToDo] Try to create vectorized version of classify_for
  
  # Calculate sample means based on training data
  x_bar1 <- colMeans(xtrain[ytrain == 1, ]) # can use drop=False
  x_bar2 <- colMeans(xtrain[ytrain == 2, ]) # can use drop=False
  
  # Calculate the inner product of the means with beta
  m1b <- as.numeric(crossprod(xbar1, beta))
  m2b <- as.numeric(crossprod(xbar2, beta))
  
  # Calculate product of xtest with beta
  xtestb <- xtest %*% beta
  
  # Calculate class assignments for xtest using matrix and vector algebra
  h1 <- (xtestb - m1b)^2
  h2 <- (xtestb - m2b)^2
  
  # Calculate % error using ytest
  
  # Return predictions and error
  return(list(ypred = ypred, error = error))
}

# Example 
##############################################

# Create model parameters
p <- 10 # dimension
mu1 <- rep(0, p) # mean vector for class 1
mu2 <- rep(1, p) # mean vector for class 2
# equicorrelation covariance matrix with correlation rho
rho <- 0.4
Sigma <- matrix(rho, p, p) + diag(1-rho, p)

# Create training data
n1 <- 100 # number of samples in class 1
n2 <- 100 # number of samples in class 2
ytrain <- c(rep(1, n1), rep(2, n2)) # class assignment
xtrain <- matrix(0, n1 + n2, p)
xtrain[ytrain == 1, ] <- rmnorm(n1, mean = mu1, varcov = Sigma)
xtrain[ytrain == 2, ] <- rmnorm(n2, mean = mu2, varcov = Sigma)

# Create testing data of the same size for simplicity
ytest<- c(rep(1, n1), rep(2, n2)) # class assignment
xtest <- matrix(0, n1 + n2, p)

xtest[ytest == 1, ] <- rmnorm(n1, mean = mu1, varcov = Sigma)
xtest[ytest == 2, ] <- rmnorm(n2, mean = mu2, varcov = Sigma)

# Calculate sample means and within class sample covariance on training data
xbar1 <- colMeans(xtrain[ytrain == 1, ])
xbar2 <- colMeans(xtrain[ytrain == 2, ])
W <- ((n1 - 1) * cov(xtrain[ytrain == 1, ]) + (n2 - 1) * cov(xtrain[ytrain == 2, ]))/(n1 + n2 - 2)

# Calculate the discriminant vector
beta <- solve(W, xbar1 - xbar2)

# Calculate test assignments based on each function

out1 = classify_for(beta, xtrain, ytrain, xtest, ytest)

out2 = classify_vec(beta, xtrain, ytrain, xtest, ytest)

# [ToDo] Verify the assignments agree with each other

# [ToDo] Use microbenchmark package to compare the timing

library(microbenchmark)