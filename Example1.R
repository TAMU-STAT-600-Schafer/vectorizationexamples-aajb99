# Squaring elements of a given vector

square_for <- function(x){
  # [ToDo] Use the for loop
  
  # Conditions:
  #   check is.numeric(x)
  
  n <- length(x)
  y <- vector(length = n) # do not define using c() (inefficient use of memory)
  
  for (i in 1:n) { #seq_along(x) will account for if n=0
    y[i] <- x[i]^2
  }
  
  return(y)
}

#####

square_sapply <- function(x){
  # [ToDo] Use the sapply function

  sapply(x, \(x){x^2}) # \ is shortcut for function(x){x^2}
  
  # NOTE: lapply(x, \(x){x^2}) will output a list rather than a vector
  
}

#####

square_vec <- function(x){
  # [ToDo] Use power(^) function in vector form

  x^2
  
}

#####

square_vec2 <- function(x){
  # [ToDo] Use multiplication(*) function in vector form

  x*x
  
}

#####

# [ToDo] Create a vector x of size 100,000 of normal variables
x <- rnorm(100000)

# [ToDo] Verify that all functions return the same output
library(testthat)
expect_equal(square_vec(x), 
             square_sapply(x)) # if true, nothing is printed

# [ToDo] Use microbenchmark package to compare three functions in terms of speed
library(microbenchmark)
microbenchmark(
  square_for(x),
  square_sapply(x),
  square_vec(x),
  square_vec2(x),
  times = 10
)
# Output order: sapply func slowest, square_vec/square_vec2 were fastest






