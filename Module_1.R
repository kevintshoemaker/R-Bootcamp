##################################################
####                                          ####  
####  R Bootcamp, Module 1                    ####
####                                          #### 
####   University of Nevada, Reno             ####
####                                          #### 
##################################################


## NOTE: this module borrows heavily from an R short course developed by a team at Colorado State University. 
   # Thanks to Perry Williams for allowing us to use these materials!!


########################
####  Demonstration: making up data in R ####
########################


####
####  Create R Objects 
####

a=1
b=2
c=3
ls()                  # View contents of your workspace.
?ls                   # View help pertaining to function ‘ls’


d=c(a,b,c)            # d is now a ‘vector’ in R
d


ls()
rm(a,b,c)             # remove extraneous variables.
ls()


d=c(1,2,3)            # more efficient way to construct d
d<-c(1,2,3)           # the arrow is also a storage operator


d1=d
d2=d+3
d=cbind(d1,d2)        # create a matrix by binding vectors
rm(d1,d2)
d
ls()


d=matrix(c(1,2,3,4,5,6),3,2)        # create matrix another way
d


d.df=data.frame(d1=c(1,2,3),d2=c(4,5,6))        # create ‘data frame’
d.df
names(d.df)          # view column names


d.df=data.frame(d)        # create data frame another way
d.df
names(d.df)
names(d.df)=c("d1","d2")        # provide new names for columns
d.df


d.list=vector("list",2)        # create empty list with 2 elements
d.list[[1]]=c(1,2,3)
d.list[[2]]=c(4,5,6)
d.list


d.f <- function(){        # create R function
  matrix(1:6,3,2)        # use colon operator to create sequence
}
ls()
d.f()                                # invoke function d.f
dd=d.f()                        # store output in variable dd
dd


d.f <- function(a,b){                # make function with inputs
  matrix(1:(a*b),a,b)
}
d.f(3,2)
d.f(2,3)
d.f(4,5)


####
####  Enumeration
####


1:10
10:1                        # reverse the order
rev(1:10)                # a different way to reverse the order


seq(1,10,1)        # equivalent to 1:10
seq(10,1,-1)        # equivalent to 10:1
seq(1,10,length=10)        # equivalent to 1:10
seq(0,1,length=10)        # sequence of length 10 between 0 and 1 


rep(0,3)                # repeat 0 three times
rep(1:3,2)                # repeat 1:3 two times
rep(1:3,each=2)        # repeat each element of 1:3 two times


####################
####  Exercises ####
####################


####
#### Subset variables
####


d=matrix(1:6,3,2)
d
d[,2]                # 2nd column of d
d[2,]                # 2nd row of d
d[2:3,]        # 2nd and 3rd rows of d in a matrix


d2=d[,2]
d2[3]                # 3rd element of d2 vector
d2[-2]        # all elements of d2 vector except 2


d.df=data.frame(d)
names(d.df)=c("d1","d2")
d.df


d.df$d1      # Subsetting a data frame
d.df[,1]


d.df$d2
d.df$d2[3]  # subset an element of a data frame


length(d2)        # Obtain length of vector d2
dim(d)        # Obtain dimensions of matrix d

d.array=array(0,c(3,2,4))       # create 3 by 2 by 4 array full of zeros (Note: array is not list)
d.array				# see what it looks like
d.array[,,1]=d  		# enter d as the first slice of the array
d.array[,,2]=d*2		# enter d*2 as the second slide...
d.array[,,3]=d*3
d.array[,,4]=d*4
d.array				# view the array 


####
#### Generate random numbers!! 
####

z=rnorm(10)                # 10 realizations from std. normal
z

y=rnorm(10,-2,4)        # 10 realizations from N(-2,4^2)
y

rbinom(5,3,.5)                # 5 realizations from Binom(3,0.5)
rbinom(5,3,.1)                # 5 realizations from Binom(3,0.1)
rbinom(5,3,.8)                # 5 realizations from Binom(3,0.8)


rbinom(5,1:5,0.5)       # simulations from binomial w/ diff number of trials
rbinom(5,1:5,seq(.1,.9,length=5))   # simulations from diff number of trials and probs


runif(10)                # 10 standard uniform random variates
runif(10,-1,1)        # 10 uniform random variates on [-1,1]


sample(1:10,5,replace=TRUE)        # 5 rvs from discrete unif. on 1:10.
sample(1:10,5,replace=TRUE,prob=(1:10)/sum(1:10)) # 5 rvs from discrete pmf w/ varying probs.


####################
####  Challenge ####
####################


# 1: Create a 3 by 2 matrix equivalent to d by binding rows
#         c(1,4); c(2,5); c(3,6). 


# 2: Is d[-c(1,2),] a matrix or a vector?


# 3: Create matrix d by converting directly from data frame d.df.


# 4: Why does length(d) work, but dim(d2) does not work?


# 5: Create a 3 by 1 matrix with elements c(1,2,3).  Does dim work on this matrix?


# 6: Create a function that takes a matrix as an input variable and outputs a vector 
#	containing all elements in the matrix.  


# 7: Create a list that includes a vector: 1:3, a matrix: matrix(1:6,3,2), and an array: array(1:24,c(3,2,4)).  


# 8: View only the 2nd row of the 3rd matrix in the array that is in the list created in challenge 7 above.

# 9: Create a data frame of 25 locations, with 'long' and 'lat' as
#        the column headings, for a 5 by 5 regular grid with extent 
#        long: [-1,1] and lat: [-1,1] (without typing each one in by hand).

