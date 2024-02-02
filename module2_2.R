
#  R Bootcamp #1, module 2.2 ---------------------------
#    University of Nevada, Reno         
#    PROGRAMMING: FUNCTIONS AND MORE         


# Start with blank workspace -------------------

rm(list=ls())


## We can write our own functions. Useful if we have to repeat the same operations over and over with different inputs.
my.mean <- function(x){       # 'x' is the function argument- 'x' stands in for whatever numeric vector the user wants
    m <- sum(x)/length(x)
    return(m)
}

foo <- c(2, 4, 6, 8)
my.mean(foo)



## A function to square the arguments.
square <- function(x){
    x^2
}

## Square a single value (scalar).
square(2)

## Square all elements of a vector.
square(1:10)



## Often, we need to write functions that are not included in the base R package e.g., the logit function.
## Calculate the log-odds (logit).
logit <- function(x){
    log(x/(1-x))
}

## Calculate logit of 0.9.
logit(.9)

## Sequence between 0 and 1.
x <- seq(from = 0, to = 1, by = 0.01)

## Caclulate the logit of a vector.
logit.x <- logit(x)
logit.x

## Plot x on x-axis, and logit(x) on y axis.
plot(x, logit.x, type = 'l',xlab="x",ylab="logit(x)")    # View the output graphically.




#  if...else statements -----------------------

# Draw a sample from a Binomial distribution with p = 0.7 (here, p represents detection probability).
p <- 0.7            # probability of detection
x <- rbinom(n = 1, size = 1, prob = p)      # single 'coin flip' with prob success equal to p

if (x > 0) {
    print("detected")
} else {
    print("not detected")
}


#  ifelse()  --------------------------------

## Note if...else only works for running one logical (T/F) test at a time. If we have a spreadsheet with lots of data, we need something else.
n.samples <- 100

## 100 samples from a binomial distribution with detection probability p = 0.7.
y <- rbinom(n = n.samples, size = 1, prob = p)
y

## Use ifelse d
detection.history <- ifelse(y == 1, "Detected", "Not detected")
detection.history

## Going the other direction.
ifelse(detection.history == "Detected", 1, 0)

xt  <-  cbind(rbinom(10, 1, .5), rbinom(10, 1, .6))
xt
ifelse(xt[, 1] > 0 & xt[, 2] > 0, "Detected twice",
       "Not detected twice")



#  for loops  --------------------------

for(i in 1:10){
  print(i)
}

for(j in c(2,4,6,8,10)){    
  print(j)
}

n.iter <- 10                   # another alternative!
count <- 0
for(i in 1:n.iter){
  count <- count+1            # assign a new value of count equal to the old value of count plus 1
  print(count)
}



  # closer look at iteration vector:
1:n.iter


## A for-loop for dependent sequence (here, the Fibonacci sequence)
n.iter <- 10
x <- rep(0, n.iter)           # set up vector of all zeros
x[1] <- 1                     # assign x_1  <-  1
x[2] <- 1                     # assign x_2 = 0
for(i in 3:n.iter){
  x[i] <- x[i-1]+x[i-2]       # x_i = x_(i-1) + x_(i-2)
}
x



### apply (another way to iterate) ------------------

W <- matrix(rnorm(4, 10, 3), nrow = 2, ncol = 2)  # Create a 2X2 matrix using a Normal random number generator with mu=10 and sd=3
W

## For each row, calculate the mean.
apply(W, 1, mean)

## For each column, calculate the mean.
apply(W, 2, mean)

## Apply your own custom function to each row in a matrix.
MyFunc <- function(x){
    2+sum(x/5)-3/2*mean(x)^2
}
apply(W, 1, MyFunc)

# lapply: apply a function across a list or vector --------------

# apply the "exp()" function to each element in the vector 1:5 

lapply(1:5,function(x) exp(x)) 


# compute the square root of volume for the first five trees in the 'trees' dataset

lapply(1:5, function(t) sqrt(trees$Volume[t]))


# sapply: same thing as 'lapply' but simplifies the returned object (i.e., into a vector if the function returns a scalar...)

mylist <- list()
mylist[[1]] <- seq(1,5,length=10)
mylist[[2]] <- c(1,.5,-.4)
mylist[[3]] <- matrix(rnorm(12,10,3),nrow=3)
sapply(mylist,function(x) sum(x)) 



x=c(5,4,7,3,10,2,5,4,7,6)


filled.contour(volcano, color.palette = terrain.colors, asp = 1)
title(main = "volcano data: filled contour map")



# CHALLENGE EXERCISES   -------------------------------------

#1: Create a custom function to calculate the predicted value y 
#    for the equation y = beta_0 + beta_1*x for any value of 
#    beta_0, beta_1 and x. Assume that beta_0 and 
#    beta_1 are both scalar, whereas x is a numeric vector. 
#    Use this function to calculate y for the values of 
#    $x$ = 1,...,10 with $\beta_0 = 2$, and $\beta_1= -1$. 
#    Use base R plotting (`plot()` function) to plot the results.
#
#2: Write a FOR loop that takes a numeric vector as input and 
#    computes the cumulative mean (for each element of the vector, 
#    compute the mean of all previous elements of the vector, 
#    including the current element). 
#
#3: Using the built-in 'volcano' dataset (a matrix of elevation data 
#    with columns representing longitude and rows representing latitude),
#    calculate the standard deviation of elevation as an index of
#    'ruggedness' from the rows () of the volcano elevation data matrix.
#    Using the "apply()" function. Which row (latitude band) of the
#    'volcano' dataset has the most rugged terrain?

