
#  R Bootcamp #1, Module 1    
#      University of Nevada, Reno             

#  Getting started with R: the basics  -----------------------


myname <- "batman"  # or use your real name.


# BACK TO BASICS -------------------

# functions ------------------- 

sum(1, 2, 3, 10)    # returns: 15

c(1, 2, 3, 10)   # combine four numbers into a single data object (construct a vector!)

floor(67.8)  # removes the decimal component of a number
round(67.8)  # rounds a number to the nearest integer

near(0.01,0,tol=0.2)  # returns TRUE if argument 1 is near to argument 2 within a certain tolerance level

  # load 'tidyverse'  and 'ggplot'
library(ggplot2) 
library(tidyverse)

near    # oops, forgot the parentheses!

near(1,1.1)
near(1,1.01)
near(1,1.000000001)

?near  # get some help


help(round)  # a function for getting help with functions!!
?round         # shortcut for the 'help' function



#  Create R Objects ------------------------


# scalars 


scalar1 <- 'this is a scalar'
scalar2 <- 104


# VECTORS  

vector1 <- c(1.1, 2.1, 3.1, 4)   # the "c()" function combines smaller data objects into a larger object
vector2 <- c('a', 'b', 'c')


d1 <- 1:3             # make a vector: 1,2,3
d2 <- d1+3            # add 3 to all elements of the vector "myvec"
d3 <- d1+d2           # elementwise addition

length(d1)            # number of elements in a vector
sum(d3)               # sum of all elements in a vector

d2[2]                 # extract the second element in the vector


# MATRICES 

mymat <- cbind(d1,d2)        # create a matrix by binding vectors, with vector d1 as column 1 and d2 as column 2
mymat
class(mymat)   # confirm that the new object "mymat" is a matrix using the 'class()' function

mymat <- matrix(c(1,2,3,4,5,6),nrow=3,ncol=2)        # create matrix another way (matrix constructor)
mymat


# math with matrices

mymat + 2
sum(mymat)

# extract matrix elements

mymat[3,2]    # extract the element in the 3rd row, 2nd column

mymat[,1]     # extract the entire first column

# X[a,b]       access row a, column b element of matrix/data frame X
# X[,b]        access all rows of column b of matrix/data frame X
# X[a,]        access row a of matrix/data frame X


# LISTS 

mylist <- list()        # create empty list
mylist[[1]] <- c(1,2,3)     # note the double brackets- this is one way to reference list elements. 
mylist[[2]] <- c("foo","bar")
mylist[[3]] <- matrix(1:6,nrow=2)
mylist

# do stuff with lists

mylist[[2]]    # extract the second list element

mylist[[3]][1,2]   # extract the first row, second column from the matrix that is embedded as the third element in this list !   


# DATA FRAMES 

df1 <- data.frame(col1=c(1,2,3),col2=c("A","A","B"))        # create a data frame with two columns. Each column is a vector of length 3
df1

df1[1,2]     # extract the first element in the second column
df1$col2     # extract the second column by name (alternatively, df1[["col2"]])


# MAKING UP DATA!  ----------------------------------

# Generating vector sequences  

1:10                        # sequential vector from 1 to 10

seq(0,1,length=5)          # sequence of length 5 between 0 and 1 


# Repeating vector sequences 

rep(0,times=3)                # repeat 0 three times
rep(1:3,times=2)              # repeat the vector 1:3 twice
rep(1:3,each=2)               # repeat each element of 1:3 two times


# Random numbers 

rnorm(10)                     # 10 samples from std. normal

rnorm(10,mean=-2,sd=4)        # 10 samples from Normal(-2,4^2)

rbinom(5,size=3,prob=.5)      # 5 samples from Binom(3,0.5)
rbinom(5,3,.1)                # 5 samples from Binom(3,0.1)

runif(10)                     # 10 standard uniform random numbers
runif(10,min=-1,max=1)        # 10 uniform random numbers from [-1,1]


# Make up an entire fake data frame!

my.data <- tibble(
  Obs.Id = 1:100,
  Treatment = rep(c("A","B","C","D","E"),each=20),
  Block = rep(1:20,times=5),
  Germination = rpois(100,lambda=rep(c(1,5,4,7,1),each=20)),   # random poisson variable
  AvgHeight = rnorm(100,mean=rep(c(10,30,31,25,35,7),each=20))
)
my.data
summary(my.data)    # Use the "summary()" function to summarize each column in the data frame.

mydf=my.data[21:30,]  # extract rows 21 to 30 and store as a new data frame
mydf

mydf$Treatment    # access a column of the data frame by name


# Useful data exploration/checking tools in R --------------------

length(d2)        # Obtain length (# elements) of vector d2
dim(mymat)        # Obtain dimensions of matrix or array
summary(my.data)  # summarize columns in a data frame. 
names(my.data)    # get names of variables in a data frame (or names of elements in a named vector)
nrow(my.data)     # get number of rows/observations in a data frame
ncol(my.data)     # get number of columns/variables in a data frame
str(my.data)      # look at the "internals" of an object (useful for making sense of complex objects!)


# CHALLENGE EXERCISES -------------------------


### Challenge 1: Create a 3 row by 2 column matrix equivalent to mymat. Use the "rbind()" function to bind the three rows together using the following three vectors as rows:

c(1,4) 
c(2,5) 
c(3,6)

### Challenge 2: Create a new matrix called 'mymat2' that includes all the data from columns 3 to 5 of data frame mydf. HINT: use the "as.matrix()" function to coerce a data frame into a matrix.

### Challenge 3: Create a list named 'mylist' that is composed of a vector: 1:3, a matrix: matrix(1:6,nrow=3,ncol=2), and a data frame: data.frame(x=c(1,2,3),y=c(TRUE,FALSE,TRUE),z=c("a","a","b")).

### Challenge 4: Extract the first and third observation from the 2nd column of the data frame in 'mylist' (the list created in challenge 6 above).

### Challenge 5: (optional; extra challenging!) Create a data frame named 'df_spatial' that contains 25 spatial locations, with 'long' and 'lat' as the column names (25 rows/observations, 2 columns/variables). These locations should describe a 5 by 5 regular grid with extent long: [-1,1] and lat: [-1,1]. 

###     HINT: you don't need to type each location in by hand! Use the 'rep()' and 'seq()' functions instead.

# Code for visualizing the results from challenge problem 5:

plot(x=df_spatial$long, y=df_spatial$lat, main="Regular grid",xlab="long",ylab="lat",xlim=c(-1.5,1.5),ylim=c(-1.5,1.5),pch=20,cex=2)
abline(v=c(-1,1),h=c(-1,1),col="green",lwd=1)

