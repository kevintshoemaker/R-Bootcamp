
#  UNR R workshop #1, Module 2 -------------------

#  Managing data  --------------------

library(tidyverse)
library(ggplot2)


# Find the directory you're working in 
getwd()          # note: the results from running this command on my machine will differ from yours!  


# for example...

# setwd("E:/GIT/R-Bootcamp")   # note that the use of backslashes for file paths, as used by Windows, are not supported by R


# Contents of working directory
# list.files()    # uncomment this to run it...


####
####  Import data files into R
####

# ?read_table    # some useful functions for reading in data

# read_table to import textfile with columns separated by whitespace
data.txt.df <- read_table("data.txt")  

# read_csv to import textfile with columns separated by commas
data.df <- read_csv("data.csv")
names(data.df) 

# Remove redundant objects from memory
rm(data.txt.df)



# Built-in data files
data()   



# read built-in data on car road tests performed by Motor Trend
data(mtcars)   
head(mtcars)    # inspect the first few lines

# ?mtcars        # learn more about this built-in data set


ggplot2::diamonds   # note the use of the package name followed by two colons- this is a way to make sure you are using a function (or data set) from a particular package... (sometimes several packages have functions with the same name...)



####
#### Check/explore data object
#### 

# ?str: displays the internal structure of the data object
str(mtcars)
str(data.df)

names(diamonds)


summary(data.df)


####
#### Exporting data (save to hard drive as data file)
####

# ?write_csv: writes a CSV file to the working directory
   
write_csv(data.df[,c("Country","Product")], file="data_export.csv")   # export a subset of the data we just read in.


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
# Clear the environment

rm(list=ls())   # clear the entire environment. Confirm that your environment is now empty!

data.df <- read_csv("data.csv")  # read the data back in!


# <- assignment operator
# =  alternative assignment operator

a <- 3     # assign the value "3" to the object named "a"
a = 3      # assign the value "3" to the object named "a" (alternative)
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
# %in% matches one of a specified group of possibilities

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
data.df[,2]=74     # sets entire second column equal to 74! OOPS WE GOOFED UP!!!

data.df <- read.csv("data.csv")  ## correct our mistake in the previous line (revert to the original data)!

# Right
data.df[,2]==74    # tests each element of column to see whether it is equal to 74

data.df[,2]<74|data.df[,2]==91   # use the logical OR operator


#  Subsetting data ---------------------------

data.df[data.df[,"Import"]<74,]    # select those rows of data for which second column is less than 74

#  or alternatively, using tidyverse syntax:

data.df %>% 
  filter(Import<74)

sub.countries<-c("Chile","Colombia","Mexico")    # create vector of character strings

data.df %>% 
  filter(Country %in% sub.countries)   # subset just those rows that match the list of countries


#  Practice subsetting a data frame ------------------------

turtles.df <- read_table(file="turtle_data.txt")
turtles.df

# Subset for only females

fem.turtles.df = turtles.df %>%
  filter(sex=="female")
  
# Here we want to know the mean weight of all females 
mean(fem.turtles.df$weight)

# or we can summarize the mean weight for males and females at the same time using the following tidyverse syntax ...

turtles.df %>% 
  group_by(sex) %>% 
  summarize(meanwt = mean(weight))

# OOPS, looks like we just caught an error!


unique(turtles.df$sex)  # note the two ways of representing females...

turtles.df$sex[turtles.df$sex=="fem"] <- "female"  # correct the error

# or alternatively using more tidyverse-y syntax
turtles.df = turtles.df %>% 
  mutate(sex = replace(sex,sex=="fem","female"))

turtles.df %>%          # summarize weight by sex
  group_by(sex) %>% 
  summarize(meanwt = mean(weight))


#  Data Manipulation using subsetting -------------------

subset.turtles.df <- turtles.df %>% 
  filter(weight >= 10)

subset.turtles.df

# list of tags we do not trust the data for
bad.tags <- c(13,105)

turtles.df = turtles.df %>% 
  mutate(
    sex = replace(sex,tag_number%in%bad.tags,NA),
    carapace_length = replace(carapace_length,tag_number%in%bad.tags,NA),
    head_width = replace(head_width,tag_number%in%bad.tags,NA),
    weight = replace(weight,tag_number%in%bad.tags,NA)
  )

# or use the following non-tidyverse syntax... which seems simpler to me!

turtles.df[turtles.df$tag_number%in%bad.tags,c("sex","carapace_length","head_width","weight")]  <- NA

turtles.df

 # make a new variable "size.class" based on the "weight" variable

turtles.df = turtles.df %>% 
  mutate(size.class = case_when(
    weight < 3 ~ "juvenile",
    weight > 6 ~ "adult",
    is.na(weight) ~ NA_character_,
    TRUE  ~ "subadult"
  ))

turtles.df$size.class


# select only the x y and z columns from the diamonds dataset

diamonds2 <- diamonds %>% 
  select(x,y,z)
 
# in base R (non tidyverse) you can do this:
diamonds2 <- diamonds[,c("x","y","z")]

# to change the column names, use the "names()" function

names(diamonds2)  # extract the column names
names(diamonds2)  <- c("length", "width","depth")


#  Sorting  ----------------

# The 'order' function returns the indices of the original (unsorted) vector in the order that they would appear if properly sorted  
order(turtles.df$carapace_length)

# To sort a data frame by one vector, you can use "order()"
turtles.df[order(turtles.df$tag_number),]

# or we can use the "arrange" verb:
turtles.df %>% 
  arrange(carapace_length)

# or if we want in descending order...

turtles.df %>% 
  arrange(desc(carapace_length))

# Sorting by 2 columns
turtles.df %>% 
  arrange(sex,weight)


#  Missing Data   ----------------------

# NOTE: you need to specify that this is a tab-delimited file. It is especially important to specify the delimiter for data files with missing data. If you specify the header and what the text is delimited by correctly, it will read missing data as NA. Otherwise it will fail to read data in properly.

missing.df <- read_delim(file="data_missing.txt",delim="\t")   # try replacing with "read_table"- it does not work right!

# Missing data are read as an NA
missing.df

# Omits (removes) rows with missing data
na.omit(missing.df)

# ?is.na   (Boolean test!)
is.na(missing.df)

complete.cases(missing.df)   # Boolean: for each row, tests if there are no NA values

# Replace all missing values in the data frame with a an interpolation function from the 'zoo' package (here we interpolate using the mean value)

missing.df %>% 
  mutate(Export = na.fill(Export,mean(Export,na.rm=T)),
         Import = na.fill(Import,mean(Import,na.rm=T)))

# Can summarize your data and tell you how many NA's per col
summary(missing.df)


############
### CHALLENGE EXERCISES
############

# 1: Save the "comm_data.txt" file to your working directory. Read this file in as a data frame. Select only only the following columns: Hab_class, C_DWN, C_UPS (discard the remaining columns). Finally, rename these columns as: "Class","Downstream", and "Upstream" respectively. [hint 1: use read_table to read in the file as a data frame] [hint 2: use the "select" verb to select the columns you want] [hint 3: use the names() function to rename the columns]
# 
# 2: Read in the file "turtle_data.txt". Create a new version of this data frame with all missing data removed (discard all rows with one or more missing data). Save this new data frame to your project directory as a comma delimited text file. [hint 1: use the "na.omit()" function to remove rows with NAs] [hint 2: use the write_csv function to write to your working directory] 
#   
# 3: Read in the file "turtle_data.txt". Create a new data frame with only male turtles. Use this subsetted data set to compute the mean and standard deviation for carapace length of male turtles.




##########
# Demo- using the "drop=TRUE" argument when subsetting higher-dimensional objects

newmat <- matrix(c(1:6),nrow=3,byrow = T)
class(newmat)

newmat[1,]
class(newmat[1,])    # what? why is it no longer a matrix????

newmat[1,,drop=FALSE]
class(newmat[1,,drop=FALSE])    # ahhh, now we retain a 2-D matrix! 

