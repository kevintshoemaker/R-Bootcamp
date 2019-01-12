
##################################################
####                                          ####  
####  R Bootcamp #1, Module 1                 ####
####                                          #### 
####   University of Nevada, Reno             ####
####                                          #### 
##################################################

## NOTE: this module borrows heavily from an R short course developed by a team at Colorado State University. 
   # Thanks to Perry Williams for allowing us to use these materials!!

########################
####  R objects     ####
########################



Batmans_butler <- 'Alfred Pennyworth'


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
scalar_2 + scalar_4


a <- 1
b <- 2
c <- 3

d.vec <- c(a, b, c)
d.vec



length(d.vec)    # the "length()" function returns the number of elements in a vector (or list, matrix etc.)

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
### functions
#############

sum(1, 2, 3, 10)    # returns: 15

## sum can be used with one of the vectors we created
sum(vector1)        # returns: 10.3


help(sum)
?sum    # this is an alternative to 'help(sum)'!


#############
### MATRICES
#############

d.mat <- cbind(d1,d2)        # create a matrix by binding vectors, with vector d1 as column 1 and d2 as column 2
d.mat
class(d.mat)   # confirm that the new object "d.mat" is a matrix!


d.mat <- matrix(c(1,2,3,4,5,6),nrow=3,ncol=2)        # create matrix another way
d.mat

d.mat <- matrix(c(1,2,3,4,5,6),nrow=3,ncol=2,byrow=T)        # create matrix another way
d.mat

d.mat <- rbind(c(1,4),c(2,5),c(3,6))        # create matrix another way
d.mat


d.mat + 2
d.mat/sum(d.mat)


#############
### DATA FRAMES
#############
d.df <- data.frame(d1=c(1,2,3),d2=c(4,5,6))        # create a ‘data frame’ with two columns
d.df


d.df=data.frame(d.mat)        # create data frame another way - directly from a matrix
d.df


names(d.df)          # view or change column names
names(d.df)=c("meas_1","meas_2")        # provide new names for columns
d.df


rownames(d.df) <- c("obs1","obs2","obs3")
d.df


#############
### LISTS
#############
d.list <- list()        # create empty list
d.list[[1]] <- c(1,2,3)
d.list[[2]] <- c(4,5)
d.list[[3]] <- "Alfred Pennyworth"
d.list


#############
### MAKING UP DATA!
#############

#######
# Sequences

1:10                        # sequence from 1 to 10
10:1                        # reverse the order
rev(1:10)                   # a different way to reverse the order

seq(from=1,to=10,by=1)      # equivalent to 1:10
seq(10,1,-1)                # equivalent to 10:1
seq(1,10,length=10)         # equivalent to 1:10
seq(0,1,length=10)          # sequence of length 10 between 0 and 1 



##############
# Repeating sequences

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
# Make up an entire data frame!


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

# X[i]         access the ith element of X

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


d.df$Germination      # Subsetting a data frame
d.df[,4]              # same thing!
d.df[[4]]             # same thing!
d.df[,"Germination"]           # same thing!


d.df$AvgHeight
d.df$AvgHeight[3]  # subset an element of a data frame


# Columns and rows of data frame
d.df$Treatment
d.df[,2]

d.df[,2:3]
cbind(ID=d.df$Obs.Id,Height=d.df$AvgHeight)    # make new data frame 

d.df[2,]
d.df[2,2:3]



###############
# Other data exploration tricks in R

length(d2)        # Obtain length (# elements) of vector d2
dim(d.mat)            # Obtain dimensions of matrix or array
summary(my.data)  # summarize columns in a data frame. 
names(my.data)    # get names of variables in a data frame (or names of elements in a named vector)
nrow(my.data)     # get number of rows/observations in a data frame
ncol(my.data)     # get number of columns/variables in a data frame
str(my.data)      # look at the "internals" of an object (useful for making sense of complex objects!)


############
### ARRAYS!
############

d.array=array(0,dim=c(3,2,4))       # create 3 by 2 by 4 array full of zeros
d.array				# see what it looks like
d.mat=matrix(1:6,nrow=3)
d.array[,,1]=d.mat  		# enter d as the first slice of the array
d.array[,,2]=d.mat*2		# enter d*2 as the second slide...
d.array[,,3]=d.mat*3
d.array[,,4]=d.mat*4
d.array				# view the array 

d.array[1,2,4]

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

