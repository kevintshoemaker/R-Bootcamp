
##################################################
####                                          ####  
####  R Bootcamp #1, Module 1                 ####
####                                          #### 
####   University of Nevada, Reno             ####
####                                          #### 
##################################################

## NOTE: this module borrows heavily from an R short course developed by a team at Colorado State University. 
   # Thanks to Perry Williams at UNR for allowing us to use these materials!!

##################################################
####  Getting started with R: the basics      ####
##################################################


myname <- 'Alfred' 


###############
# R DEMO: 
###############

#  don't worry if you don't understand this just yet- this is just a taste of where we are going!

#########
# load a built-in dataset

data(trees)


#########
# explore the data object

summary(trees)    # summary statistics for all variables in data frame
str(trees)        # summary of the data structure


#########
# visualize the data

   # histograms:
layout(matrix(1:3,nrow=1,byrow = T))    # set up a multi-panel graphics device (three plots side by side)
hist(trees$Height)                       # visualize the distribution of height data
hist(trees$Girth)                        # visualize the distribution of girth data
hist(trees$Volume)                       # visualize the distribution of volume data

   # bivariate scatterplots:

layout(matrix(1:2,nrow=1,byrow = T))      # set graphics device with 2 plots side by side
plot(trees$Volume~trees$Girth)            # scatterplot of volume against girth
plot(trees$Volume~trees$Height)           # scatterplot of volume against height

pairs(trees)    # plots all scatterplots together as a scatterplot matrix!



##########
# perform linear regression analysis

model1 <- lm(Volume~Girth,data=trees)        # regress Volume on Girth

summary(model1)    # examine the results


######
# test key assumptions visually

layout(matrix(1:4,nrow=2,byrow=T))  # set up graphics window
plot(model1)  # run diagnostic plots for our regression


#########
# visualize the results!

xvals <- seq(5,30,0.5)            # set the range of "Girth" values over which you want to make predictions about "Volume"
pred <- predict(model1,newdata=data.frame(Girth=xvals),interval = "confidence",level = 0.99)   # use the linear model to make predictions about "Volume"

plot(trees$Volume~trees$Girth,xlab="Girth (inches)",ylab="Volume (cubic feet)",main="Black Cherry",
     xlim=range(xvals),ylim=c(0,100))         # Make a pretty scatterplot

abline(model1,lwd=2,col="brown")              # Add the regression line
lines(xvals,pred[,"upr"],col="brown",lty=2)       # Add the upper bound of the confidence interval
lines(xvals,pred[,"lwr"],col="brown",lty=2)       #      ... and the lower bound
text(10,80,sprintf("Volume = %s + %s*Girth",round(coefficients(model1)[1],1),round(coefficients(model1)[2],1)))       # Add the regression coefficients
text(10,65,sprintf("p = %s",round(summary(model1)$coefficients[,"Pr(>|t|)"][2],3)))     # Add the p-value


#############
### functions
#############

sum(1, 2, 3, 10)    # returns: 15

c(1, 2, 3, 10)   # combine four numbers into a single data object (a vector!)

floor(67.8)  # removes the decimal component of a number
round(67.8)  # rounds a number

round     # oops, we forgot to add parenthesis!

help(round)  # a function for getting help with functions!!
?round         # shortcut for the 'help' function



########
# basic mathematical operations

2+3              # addition 
'+'(2,3)                 # see, this is really a function in disguise!
          
6-10             # subtraction
          
2.5*33           # multiplication
      
4/5              # division
      
2^3              # exponentiation
        
sqrt(9)          # square root 
      
8^(1/3)          # cube root      
       
exp(3)           # antilog     

log(20.08554)    # natural logarithm (but it's possible to change the base)

log10(147.9108)  # common logarithm 

log(147.9108, base=10) 

factorial(5)     # factorial


##################
####  Create R Objects 
##################

#############
### scalars
#############

scalar1 <- 'this is a scalar'
scalar2 <- 104
scalar3 <- 5 + 6.5    # evaluates to the single value 11.5
scalar4 <- '4'


typeof(scalar4)    # returns: character

## what is this type?
scalar5 <- TRUE
typeof(scalar5)    # returns: logical


## what happens when we run this line of code? Think about the types.
scalar2 + scalar4


#############
### VECTORS
#############

vector1 <- c(1.1, 2.1, 3.1, 4)   # the "c()" function combines smaller data objects into a larger object
vector2 <- c('a', 'b', 'c')
vector3 <- c(TRUE, 'a', 1)


a <- 1
b <- 2
c <- c(3,4)

myvec <- c(a, b, c)   # create a vector from existing data objects
myvec


length(myvec)    # the "length()" function returns the number of elements in a vector

d1 <- myvec           # copy the vector "myvec"
d2 <- myvec+3         # add 3 to all elements of the vector "myvec"
d3 <- d1+d2           # elementwise addition
d4 <- d1+c(1,2)       # what does this do?

## inspect the objects by calling them in the console (or script window)
d1    # returns: 1 2 3
d2    # returns: 4 5 6
d3    # returns: 5 7 9
d4    # returns: 2 4 4


#############
### MATRICES
#############

mymat <- cbind(d1,d2)        # create a matrix by binding vectors, with vector d1 as column 1 and d2 as column 2
mymat
class(mymat)   # confirm that the new object "mymat" is a matrix using the 'class()' function


mymat <- matrix(c(1,2,3,4,5,6),nrow=3,ncol=2)        # create matrix another way (stack columns together)
mymat

mymat <- matrix(c(1,2,3,4,5,6),nrow=3,ncol=2,byrow=T)        # create matrix another way (stack rows together)
mymat

mymat <- rbind(c(1,4),c(2,5),c(3,6))        # create matrix another way (stacking three vectors on top of one another)
mymat


# math with matrices

mymat + 2
mymat/sum(mymat)


#############
### LISTS
#############

mylist <- list()        # create empty list
mylist[[1]] <- c(1,2,3)     # note the double brackets- this is one way to reference list elements. 
mylist[[2]] <- c(4,5)
mylist[[3]] <- "Alfred"
mylist


#############
### DATA FRAMES
#############
mydf <- data.frame(col1=c(1,2,3),colW2=c(4,5,6))        # create a ‘data frame’ with two columns. Each column is a vector of length 3
mydf


names(mydf)          # view or change column names
names(mydf)=c("meas_1","meas_2")        # provide new names for columns
mydf


rownames(mydf) <- c("obs1","obs2","obs3")
mydf


#############
### MAKING UP DATA!
#############

#######
# Generating vector sequences

1:10                        # sequential vector from 1 to 10
10:1                        # reverse the order

seq(from=1,to=10,by=1)      # equivalent to 1:10
seq(10,1,-1)                # equivalent to 10:1
seq(1,10,length=10)         # equivalent to 1:10
seq(0,1,length=5)          # sequence of length 10 between 0 and 1 



##############
# Repeating vector sequences

rep(0,times=3)                # repeat 0 three times
rep(1:3,times=2)              # repeat 1:3 two times
rep(1:3,each=2)               # repeat each element of 1:3 two times


###########
# Random numbers

z <- rnorm(10)                # 10 realizations from std. normal
z
y <- rnorm(10,mean=-2,sd=4)           # 10 realizations from N(-2,4^2)
y

rbinom(5,size=3,prob=.5)                # 5 realizations from Binom(3,0.5)
rbinom(5,3,.1)                # 5 realizations from Binom(3,0.1)

runif(10)                # 10 standard uniform random numbers
runif(10,min=-1,max=1)        # 10 uniform random variates on [-1,1]


############
# Make up an entire fake data frame!

my.data <- data.frame(
  Obs.Id = 1:100,
  Treatment = rep(c("A","B","C","D","E"),each=20),
  Block = rep(1:20,times=5),
  Germination = rpois(100,lambda=rep(c(1,5,4,7,1),each=20)),   # random poisson variable
  AvgHeight = rnorm(100,mean=rep(c(10,30,31,25,35,7),each=20))
)
head(my.data)

summary(my.data)    # Use the "summary()" function to summarize each column in the data frame.


############
### Accessing, indexing and subsetting data
############

# X[i]         access the ith element of vector X

myvec <- 2:10
myvec
myvec[3]
myvec[c(1,5)]
myvec[-3]


myvec <- 1:4
names(myvec) <- c("fred","sally","mimi","terrence")
myvec
myvec["terrence"]
myvec[c("sally","fred")]


# X[a,b]       access row a, column b element of matrix/data frame X
# X[,b]        access all rows of column b of matrix/data frame X
# X[a,]        access row a of matrix/data frame X

d <- matrix(1:6,nrow=3,ncol=2)
d
d[,2]                # 2nd column of d
d[2,]                # 2nd row of d
d[2:3,]        # 2nd and 3rd rows of d in a matrix


# $            access component of an object (data frame or list)
# Z_list[[i]]  access the ith element of list Z

mydf=my.data[21:30,]  # only keep 10 rows
mydf

## many ways of accessing a particular column of a data frame
mydf$Germination           # Subsetting a data frame
mydf[["Germination"]]      # same thing!
mydf[,4]                   # same thing!
mydf[[4]]                  # same thing!
mydf[,"Germination"]       # same thing!

# Data frame can also be indexed just like a matrix
mydf[,2]
mydf[2,]
mydf[,2:3]
mydf[2,2:3]



###############
# Other data exploration tricks in R

length(d2)        # Obtain length (# elements) of vector d2
dim(mymat)        # Obtain dimensions of matrix or array
summary(my.data)  # summarize columns in a data frame. 
names(my.data)    # get names of variables in a data frame (or names of elements in a named vector)
nrow(my.data)     # get number of rows/observations in a data frame
ncol(my.data)     # get number of columns/variables in a data frame
str(my.data)      # look at the "internals" of an object (useful for making sense of complex objects!)


############
### CHALLENGE EXERCISES
############

### Challenge 1: Create a 3 by 2 matrix equivalent to mymat by binding rows 

# (HINT: use the "rbind()" function), using the following as rows:

c(1,4) 
c(2,5) 
c(3,6)

### Challenge 2: Is mymat[-c(1,2),] a matrix or a vector? HINT: you can use the "class()" function to help out.

### Challenge 3: Create a new matrix 'mymat2' that represents only columns 3 to 5 of data frame mydf.

### Challenge 4: Create a 3 by 1 (3 rows, 1 column) matrix called 'mymat3' with elements c(1,2,3). How is this matrix different from a vector (e.g., created by running the command '1:3')? HINT: use the "dim()" function, which returns the dimensionality of an object.

### Challenge 5: Take your matrix 'mymat2' and convert (coerce) it to a vector containing all elements in the matrix. HINT: use the 'c()' function to combine the first column and the second column into a single vector object.

### Challenge 6: Create a list named 'mylist' that is composed of a vector: 1:3, a matrix: matrix(1:6,nrow=3,ncol=2), and a data frame: data.frame(x=c(1,2,3),y=c(TRUE,FALSE,TRUE),z=c("a","a","b")).

### Challenge 7: Extract the first and third observation from the 2nd row of the data frame in 'd.list' (the list created in challenge 6 above).

### Challenge 8: (extra challenging!) Create a data frame named 'df_spatial' that contains 25 locations, with 'long' and 'lat' as the column names (25 rows/observations, 2 columns/variables). These locations should describe a 5 by 5 regular grid with extent long: [-1,1] and lat: [-1,1]. 

###     HINT: you don't need to type each location in by hand! Use the 'rep()' and 'seq()' functions instead.


########
# Code for visualizing the results from challenge problem 8

plot(x=df_spatial$long, y=df_spatial$lat, main="Regular grid",xlab="long",ylab="lat",xlim=c(-1.5,1.5),ylim=c(-1.5,1.5),pch=20,cex=2)
abline(v=c(-1,1),h=c(-1,1),col="green",lwd=1)

