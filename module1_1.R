
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


Batmans_butler <- 'Alfred Pennyworth'  


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

vector1 <- c(1.1, 2.1, 3.1, 4)
vector2 <- c('a', 'b', 'c')
vector3 <- c(1, 'a', 2, 'b')
vector4 <- c(TRUE, 'a', 1)
vector5 <- c(TRUE, 1.2, FALSE)


a <- 1
b <- 2
c <- c(3,4)

d.vec <- c(a, b, c)
d.vec



d.vec <- c(1,2,3,4)            # another way to construct the vector "d.vec"
d.vec = c(1,2,3,4)             # the "equals" sign can also be an assignment operator
d.vec <- 1:4                   # we can use the colon operator as a shorthand for creating a sequence of integers


length(d.vec)    # the "length()" function returns the number of elements in a vector

d1 <- d.vec           # copy the vector "d.vec"
d2 <- d.vec+3         # add 3 to all elements of the vector "d.vec"
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

d.mat <- cbind(d1,d2)        # create a matrix by binding vectors, with vector d1 as column 1 and d2 as column 2
d.mat
class(d.mat)   # confirm that the new object "d.mat" is a matrix!


d.mat <- matrix(c(1,2,3,4,5,6),nrow=3,ncol=2)        # create matrix another way (stack columns together)
d.mat

d.mat <- matrix(c(1,2,3,4,5,6),nrow=3,ncol=2,byrow=T)        # create matrix another way (stack rows together)
d.mat

d.mat <- rbind(c(1,4),c(2,5),c(3,6))        # create matrix another way (stacking three vectors)
d.mat


# math with matrices

d.mat + 2
d.mat/sum(d.mat)


############
### ARRAYS!
############

d.array=array(0,dim=c(3,2,4))       # create 3 by 2 by 4 array full of zeros
d.array				                      # see what it looks like
d.mat=matrix(1:6,nrow=3)
d.array[,,1]=d.mat  		            # enter d as the first slice of the array
d.array[,,2]=d.mat*2		            # enter d*2 as the second slide...
d.array[,,3]=d.mat*3
d.array[,,4]=d.mat*4
d.array				                      # view the array 

d.array[1,2,4]  # view an element of the array
d.array[1,,]    # view a slice of the array


#############
### LISTS
#############

d.list <- list()        # create empty list
d.list[[1]] <- c(1,2,3)     # note the double brackets- this is one way to reference and define a specified list element. 
d.list[[2]] <- c(4,5)
d.list[[3]] <- "Alfred Pennyworth"
d.list


#############
### DATA FRAMES
#############
d.df <- data.frame(d1=c(1,2,3),d2=c(4,5,6))        # create a ‘data frame’ with two columns. Each column is a vector of length 3
d.df


d.df=data.frame(d.mat)        # create data frame another way - directly from a matrix
d.df


names(d.df)          # view or change column names
names(d.df)=c("meas_1","meas_2")        # provide new names for columns
d.df


rownames(d.df) <- c("obs1","obs2","obs3")
d.df


#############
### functions
#############

sum(1, 2, 3, 10)    # returns: 15

## sum can be used with one of the vectors we created
sum(vector1)        # returns: 10.3


help(sum)
?sum    # this is an alternative to 'help(sum)'!


#############
### MAKING UP DATA!
#############

#######
# Generating vector sequences

1:10                        # sequential vector from 1 to 10
10:1                        # reverse the order
rev(1:10)                   # a different way to reverse the order

seq(from=1,to=10,by=1)      # equivalent to 1:10
seq(10,1,-1)                # equivalent to 10:1
seq(1,10,length=10)         # equivalent to 1:10
seq(0,1,length=10)          # sequence of length 10 between 0 and 1 



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
rbinom(5,3,.8)                # 5 realizations from Binom(3,0.8)

rbinom(5,1:5,0.5)       # simulations from binomial w/ diff number of trials
rbinom(5,1:5,seq(.1,.9,length=5))   # simulations from diff number of trials and probs

runif(10)                # 10 standard uniform random variates
runif(10,min=-1,max=1)        # 10 uniform random variates on [-1,1]


sample(1:10,size=5,replace=TRUE)        # 5 rvs from discrete unif. on 1:10.
sample(1:10,size=5,replace=TRUE,prob=(1:10)/sum(1:10)) # 5 rvs from discrete pmf w/ varying probs.


############
# Make up an entire fake data frame!


my.data <- data.frame(
  Obs.Id = 1:100,
  Treatment = rep(c("A","B","C","D","E"),each=20),
  Block = rep(1:20,times=5),
  Germination = rpois(100,lambda=rep(c(1,5,4,7,1),each=20)),
  AvgHeight = rnorm(100,mean=rep(c(10,30,31,25,35,7),each=20))
)
head(my.data)

summary(my.data)    # Use the "summary()" function to summarize each column in the data frame.


############
### Accessing, indexing and subsetting data
############

# X[i]         access the ith element of vector X

d.vec <- 2:10
d.vec
d.vec[3]
d.vec[c(1,5)]
d.vec[-3]


d.vec <- 1:4
names(d.vec) <- c("fred","sally","mimi","terrence")
d.vec
d.vec["terrence"]
d.vec[c("sally","fred")]


# X[a,b]       access row a, column b element of matrix/data frame X
# X[,b]        access column b of matrix/data frame X
# X[a,]        access row a of matrix/data frame X

d <- matrix(1:6,3,2)
d
d[,2]                # 2nd column of d
d[2,]                # 2nd row of d
d[2:3,]        # 2nd and 3rd rows of d in a matrix


# $            access component of an object (data frame or list)
# Z_list[[i]]  access the ith element of list Z

d.df=my.data[21:30,]  # only take 10 observations
d.df

## many ways of accessing a particular column of a data frame
d.df$Germination           # Subsetting a data frame
d.df[["Germination"]]      # same thing!
d.df[,4]                   # same thing!
d.df[[4]]                  # same thing!
d.df[,"Germination"]       # same thing!
d.df["Germination"]        # same thing!  (or is it...??)


d.df$AvgHeight
d.df$AvgHeight[3]  # subset an element of a data frame


# Data frame can also be indexed just like a matrix
d.df[,2]
d.df[2,]
d.df[,2:3]
d.df[2,2:3]



###############
# Other data exploration tricks in R

length(d2)        # Obtain length (# elements) of vector d2
dim(d.mat)        # Obtain dimensions of matrix or array
summary(my.data)  # summarize columns in a data frame. 
names(my.data)    # get names of variables in a data frame (or names of elements in a named vector)
nrow(my.data)     # get number of rows/observations in a data frame
ncol(my.data)     # get number of columns/variables in a data frame
str(my.data)      # look at the "internals" of an object (useful for making sense of complex objects!)


########
# basic mathematical operations

2+3              # addition
          
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

21 %% 5          # modulus   


############
### CHALLENGE EXERCISES
############

### Challenge 1: Create a 3 by 2 matrix equivalent to d.mat by binding rows 

# (HINT: use the "rbind()" function), using the following as rows:

c(1,4) 
c(2,5) 
c(3,6)

### Challenge 2: Is d.mat[-c(1,2),] a matrix or a vector? HINT: you can use the "class()" function to help out.

### Challenge 3: Create a new matrix 'd.mat2' by converting directly from data frame d.df, and using only columns 3 to 5 of the object 'd.df'.

### Challenge 4: Create a 3 by 1 (3 rows, 1 column) matrix called 'd.mat3' with elements c(1,2,3). How is this matrix different from a vector (e.g., created by running the command '1:3')? HINT: use the "dim()" function, which returns the dimensionality of an object.

### Challenge 5: Take your matrix 'd.mat2' and convert (coerce) it to a vector containing all elements in the matrix. HINT: use the "as.vector()" function.

### Challenge 6: Create a list named 'd.list' that is composed of a vector: 1:3, a matrix: matrix(1:6,nrow=3,ncol=2), and an array: array(1:24,dim=c(3,2,4)).

### Challenge 7: Extract (subset) the 2nd row of the 3rd matrix in the array in 'd.list' (the list created in challenge 6 above). For this exercise, please consider the array to be indexed as [row #, column #, matrix #]. 

### Challenge 8: (extra challenging!) Create a data frame named 'df_spatial' that contains 25 locations, with 'long' and 'lat' as the column names (25 rows/observations, 2 columns/variables). These locations should describe a 5 by 5 regular grid with extent long: [-1,1] and lat: [-1,1]. 

###     HINT: you don't need to type each location in by hand!


########
# Code for visualizing the results from challenge problem 8

plot(x=df_spatial$long, y=df_spatial$lat, main="Regular grid",xlab="long",ylab="lat",xlim=c(-1.5,1.5),ylim=c(-1.5,1.5),pch=20,cex=2)
abline(v=c(-1,1),h=c(-1,1),col="green",lwd=1)


#################
# More advanced exploration of functions!

########
## first class functions

## assign functions to values
sum2 <- sum
sum2(1, 2, 3, 10)    # use the value sum2 as a function!

## use functions as arguments in other functions
## lets compute the average length of some of the vectors we've created
## this should return 3.66
mean(c(length(vector1), length(vector2), length(vector3)))

