
##################################################
####                                          ####  
####  R Bootcamp #1, Module 2                 ####
####                                          #### 
####   University of Nevada, Reno             ####
####                                          #### 
##################################################

## NOTE: this module borrows heavily from an R short course developed by a team at Colorado State University. 
   # Thanks to Perry Williams for allowing us to use these materials!!

#########################
####  Managing data  ####
#########################



# Find the directory you're working in 
getwd()          # note: the results from running this command on my machine will differ from yours!  


# for example...

# setwd("E:/GIT/R-Bootcamp")   # note the use of forward slash- backslashes for file paths, as used by Windows, are not supported by R


# Contents of working directory
list.files()


####
####  Import data files into R
####

# ?read.table    # some useful functions for reading in data

# read.table to import textfile (default is sep = "" (one of several common delimiters, including any type of whitespace))
data.txt.df <- read.table("data.txt", header=T, sep="")  

# read.table with csv file
data.csv.df <- read.table("data.csv", header=T, sep=",")  

# built-in default for importing from CSV (easiest and most widely used)
data.df <- read.csv("data.csv")
names(data.df) 

# Remove redundant objects from memory
rm(data.txt.df)
rm(data.csv.df)



# Built-in data files
data()   



# read built-in data on car road tests performed by Motor Trend
data(mtcars)         

str(mtcars)    # examine the structure of this data object

# ?mtcars        # learn more about this built-in data set


####
#### Check/explore data object
#### 


# ?str: displays the internal structure of the data object
str(data.df)


# ?head: displays first n elements of object (default=6)
head(data.df)
head(data.df,2)

# ?tail: displays last n elements of object (default=6)
tail(data.df)


summary(data.df)


####
#### Exporting data (save to hard drive as data file)
####

# ?write.table: writes a file to the working directory
   
write.table(data.df[,c("Country","Product")], file="data_export.csv", sep=",", col.names=TRUE, row.names=FALSE)   # export a subset of the data we just read in.


####
####  Saving and loading
####

# ?save: saves particular objects to hard disk

a <- 1
b <- data.df$Product

save(a,b,file="Module1_2.RData")

rm(a,b)   # remove these objects from the environment

load("Module1_2.RData")   # load these objects back in!


##############
# Clear the environment (and load it back in!)

save.image(file="Module2.RData")    # ?save.image: saves entire environment (we don't necessarily want to clear everything right now)

rm(list=ls())   # clear the entire environment. Confirm that your environment is now empty!

load(file="Module2.RData")   # load the objects back!


# <- assignment operator
# =  alternative assignment operator

a <- 3     # assign the value "3" to the object named "a"
a = 3      # assign the value "3" to the object named "a"
a == 3     # answer the question: "does the object "a" equal "3"? 


####
####  Boolean operations
####

#####
# Basic operators

# <    less than
# >    greater than
# <=   less than or equal to
# >=   greater than or equal to
# ==   equal to
# !=   not equal to
# %in% matches any one of a specified group of possibilities

#####
# Combining multiple conditions

# &    must meet both conditions (AND operator)
# |    must meet one of two conditions (OR operator)

Y <- 4
Z <- 6

Y == Z  #I am asking if Y is equal to Z, and it will return FALSE
Y < Z

!(Y < Z)  # the exclamation point reverses any boolean object (read "NOT")

# Wrong!
data.df[,2]=74     # sets entire second column equal to 74! OOPS!!!

data.df <- read.csv("data.csv")  ## correct our mistake in the previous line (revert to the original data)!

# Right
data.df[,2]==74    # tests each element of column to see whether it is equal to 74


####
####  Subsetting data
####

##########
# The "which()" function -- return indices of a vector that meet a certain condition (condition is TRUE)

which(data.df[,2]==74)       # elements of column 2 that are equal to 74
which(data.df[,2]!=74)       # elements of column 2 that are NOT equal to 74
which(data.df[,2]<74)        #  and so on...
which((data.df[,2]<74)|(data.df[,2]==91))   # use the logical OR operator

#########
# Alternatively, save the indices as an R object as an intermediate step

indices <- which(data.df[,2]<74)
data.df[indices,2]               # same as above!


#########
# Alternatively, you can omit the "which()" function entirely- 
#     R will know that you're trying to omit "FALSE" elements and keep "TRUE" elements

data.df[data.df[,2]<74,2]    # alternative simpler syntax without using "which()"... 


sub.countries<-c("Chile","Colombia","Mexico")    # create vector of character strings

which(data.df$Country=="Chile") 

# This command doesn't work because sub.countries is a vector, not a single character string. 
which (data.df[,1]==sub.countries) 



# Instead we use %in%
which(data.df[,1] %in% sub.countries)     # elements of data column that match one or more of the elements in "sub.countries"
   
which((data.df$Country %in% sub.countries) & (data.df$Product=="N"))   # use AND operator 

# What if we don't want the row number, but the actual row(s) of data that meet a particular condition?

indices <- which(data.df$Country %in% sub.countries)
data.df[indices,]          # print all data for a subset of observations



####
####  Practice subsetting a data frame
#### 

turtles.df <- read.table(file="turtle_data.txt", header=T, stringsAsFactors = FALSE)
names(turtles.df)
head(turtles.df)

# Subset for females
fem.turtles.df <- turtles.df[which(turtles.df$sex =="female"),]    

# Can subset just one factor based on another
# Here we want to know the mean weight of all females 
mean(fem.turtles.df$weight)
mean(turtles.df$weight[which(turtles.df$sex =="female")]) 

# Try using the "subset()" function, which can make subsetting a data frame even easier!
female.turtles <- subset(turtles.df,sex=="female")              # use the "subset()" function!
female.turtles <- turtles.df[which(turtles.df$sex=="female"),]    # alternative

subset.turtles.df <- subset(turtles.df, weight >= 10)
head(subset.turtles.df)

# Subsetting to certain individuals
bad.tags <- c(13,105)
good.turtles.df <- turtles.df[!(turtles.df$tag_number %in% bad.tags),]
bad.turtles.df <- turtles.df[turtles.df$tag_number %in% bad.tags,]
bad.turtles.df


####
####  Data Manipulation using subsetting
####

# Using subset to correct data entry problems
unique(turtles.df$sex)
table(turtles.df$sex)   # do you notice the data entry problem here?    

turtles.df[which(turtles.df$sex=="fem"),2]<-"female"            # recode the sex variable

 # make a new variable "size.class" based on the "weight" variable
turtles.df$size.class <- NA
turtles.df$size.class[turtles.df$weight >= 6] <- 1         # ths is the "adult" class 
turtles.df$size.class[turtles.df$weight < 6] <- 2          # this is the "juvenile" class

turtles.df$size.class


####
####  Sorting
####

# Sort works for ordering along one vector
sort(turtles.df$carapace_length)  

# Order returns the indices of the original (unsorted) vector in the order that they would appear if properly sorted  
order(turtles.df$carapace_length)

# To sort a data frame by one vector, use "order()"
turtles.tag <- turtles.df[order(turtles.df$tag_number),]

# Order in reverse
turtles.tag.rev <- turtles.df[order(turtles.df$tag_number,decreasing = TRUE),] 

# Sorting by 2 columns
turtles.sex.weight <- turtles.df[order(turtles.df$sex,turtles.df$weight),] 


####
####  Missing Data
####

# Try reading in a data file with missing values, w/o specifying how the text is delimited
# Will not read because of missing data, it does not know where the columns are!
# missing.df <- read.table(file="data_missing.txt")

# If you specify the header and what the text is delimited by, it will read them as NA
missing.df <- read.table(file="data_missing.txt", sep="\t", header=T)

# Missing data is read as an NA
missing.df

# Omits (removes) rows with missing data
missing.NArm.df <- na.omit(missing.df)

# ?is.na
is.na(missing.df)

# Get index of NAs
which(is.na(missing.df))

# Replace all missing values in the data frame with a 0
missing.df[is.na(missing.df)] <- 0

# Create another data frame with missing values
missing.mean.df<- read.table(file="data_missing.txt", sep="\t", header=T)

# Replace only the missing values of just one column with the mean for that column
missing.mean.df$Export[is.na(missing.mean.df$Export)] <- mean(missing.mean.df$Export,na.rm=T)
missing.mean.df

# Return only those rows with missing data
missing.df<- read.table(file="data_missing.txt", sep="\t", header=T)
missing.df <- missing.df[!complete.cases(missing.df),]

# Can summarize your data and tell you how many NA's per col
summary(missing.mean.df)

# Summarize one individual col
summary(missing.mean.df$Export)


##############
# COMMON PITFALLS
##############


#############
# The attach() function

# Note: some people like to use attach
# We DO NOT recommend using attach

df <- data.frame(    # build a data frame
  a=1:10,
  b=rnorm(10)
)

df$a       # pull out columns of the data frame
df$b

attach(df)   # "attach" the data frame  # attach make objects within dataframes accessible with fewer letters

a          # now we can reference the columns without referencing the data frame
b

detach(df)   # remember to detach when you're done

#########
# BUT...

attach(data.df)

Import

Import<-rep(1,10) # What if we forget the names in our data frames and use that name for something else
Import

rm(Import) # But if we remove that object...

Import  # There is still the original object behind it. That's troubling!

detach(data.df)   # Remember to detach

 

############
### CHALLENGE EXERCISES
############

# 1: Create a new data frame by saving the file ["comm_data.txt"](comm_data.txt) to your working directory. For the new data frame, include only the following columns: Hab_class, C_DWN, C_UPS, and rename the columns as: "Class","Downstream", "Upstream".
# 
# 2: Read in the file "turtle_data.txt', and explore the data. Create a new version of this data frame with all missing data removed. Save this new data frame as a comma delimited text file in your working directory. 
#   
# 3: I am trying to create a data frame with only male turtles using the "which()" function.  Would the following command work? Why or why not? What other method could I use to create this without using "which()"?

# male_turtles <- turtles[,which(turtles$sex=="male")]  # uncomment this to run it...




##########
# Demo- using the "drop=TRUE" argument when subsetting higher-dimensional objects

newmat <- matrix(c(1:6),nrow=3,byrow = T)
class(newmat)

newmat[1,]
class(newmat[1,])    # what? why is it no longer a matrix????

newmat[1,,drop=FALSE]
class(newmat[1,,drop=FALSE])    # ahhh, now we retain a 2-D matrix! 

