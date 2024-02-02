
#  UNR R workshop #1, Module 2

#  Managing data

library(tidyverse)
library(ggplot2)
library(zoo)


# Working directories --------------------

# Find the directory you're working in 
getwd()          # note: the results from running this command on my machine will differ from yours!  


# for example...

# setwd("E:/GIT/R-Bootcamp")   # note that the use of backslashes for file paths, as used by Windows, are not supported by R


# Contents of working directory
# list.files()    # uncomment this to run it...


#  Import/Export data files into R----------------------

# read_csv to import textfile with columns separated by commas
data.df <- read_csv("data.csv")
names(data.df) 

# Remove redundant objects from your workspace
rm(data.txt.df)


# Built-in data files  -----------------------
data()   


data(mtcars)   # read built-in data on car road tests performed by Motor Trend

head(mtcars)    # inspect the first few lines

# ?mtcars        # learn more about this built-in data set


ggplot2::diamonds   # note the use of the package name followed by two colons- this is a way to make sure you are using a function (or data set or other object) from a particular package... (sometimes several packages have functions with the same name...)


# Check/explore data objects --------------------------

# ?str: displays the internal structure of the data object
str(mtcars)
str(data.df)

names(diamonds)


summary(data.df)


# Exporting data (save to hard drive as data file)

# ?write_csv: writes a CSV file to the working directory

newdf <- data.df[,c("Country","Product")]
   
write_csv(newdf, file="data_export.csv")   # export a subset of the data we just read in.


#  Saving and loading

# saveRDS: save a single object from the environment to hard disk
# save: saves one or more objects from the environment to hard disk. Must be read back in with the same name.

a <- 1
b <- data.df$Product

saveRDS(b, "Myobject1.rds")    # use saveRDS to save individual R objects
save(a,b,file="Myobjects1.RData")    # use 'save' to save sets of objects
save.image("Myworkspace.RData")      # use 'save.image' to save your entire workspace

rm(a,b)   # remove these objects from the environment

new_b <- readRDS("Myobject1.rds")
load("Myworkspace.RData")   # load these objects back in with the same names!


# Clear the environment

rm(list=ls())   # clear the entire environment. Confirm that your environment is now empty!

data.df <- read_csv("data.csv")  # read the data back in!


# Working with data in R ------------------------

# <- assignment operator
# =  alternative assignment operator

a <- 3     # assign the value 3 to the object named "a"
b = 5      # assign the value 5 to the object named "b" 
a == 3     # answer the question: "does the object "a" equal "3"? 

a == b

# what happens if you accidentally typed 'a = b'?


# explore Boolean operators -----------------------


Y <- 4   # first define a couple new objects
Z <- 6

Y == Z  # is Y equal to Z?  (T/F)
Y < Z   # is Y less than Z?

!(Y < Z)  # the exclamation point reverses any boolean object (read "NOT")

data.df[,2]=74     # (for each element in the second column of data.df) is it equal to 74? 

# OOPS! sets entire second column equal to 74! OOPS WE GOOFED UP!!!

data.df <- read.csv("data.csv")  ## correct our mistake in the previous line (revert to the original data)!

# Let's do it right this time
data.df[,2]==74    # tests each element of column to see whether it is equal to 74

data.df[,2]<74|data.df[,2]==91   # combine two questions using the logical OR operator


#  Subsetting data 

data.df[data.df[,"Import"]<74,]    # select those rows of data for which second column is less than 74

#  or alternatively, using tidyverse syntax (and the pipe operator):

data.df %>% 
  filter(Import<74)    # use "filter" verb from 'dplyr' package

sub.countries<-c("Chile","Colombia","Mexico")    # create vector of character strings

data.df %>% 
  filter(Country %in% sub.countries)   # subset the dataset for only that subset of countries we're interested in


# Subsetting data ----------------------

#  Practice subsetting a data frame 
turtles.df <- read_delim(file="turtle_data.txt",delim="\t")   # tab-delimited file
turtles.df

# Subset for turtles that weigh greater than or equal to 10g

subset.turtles.df <- turtles.df %>% 
  filter(weight >= 10)

subset.turtles.df


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

# or alternatively
turtles.df = turtles.df %>% 
  mutate(
    sex= fct_collapse(sex,
             female=c("fem","female"),
             male=c("male")))
  

# or alternatively
turtles.df = turtles.df %>% 
  mutate(sex = replace(sex,sex=="fem","female"))

turtles.df %>%          # summarize weight by sex (check that it's fixed)
  group_by(sex) %>% 
  summarize(meanwt = mean(weight))


# select only the x y and z columns from the diamonds dataset

diamonds2 <- diamonds %>% 
  select(x,y,z)
 
# in base R (non tidyverse) you can do this:
diamonds2 <- diamonds[,c("x","y","z")]

# to change the column names, use the "names()" function

names(diamonds2)  # extract the column names
names(diamonds2)  <- c("length", "width","depth")

# or rename specific variables using 'dplyr' from the 'tidyverse;

diamonds2 <- rename(diamonds2, len = length)


#  Sorting  

# The 'order' function returns the indices of the original (unsorted) vector in the order that would sort the vector from lowest to highest...   
order(turtles.df$carapace_length)

# To sort a data frame by one vector, you can use "order()"
turtles.df[order(turtles.df$tag_number),]

# And in decreasing order:

turtles.df[order(turtles.df$tag_number,decreasing=T),]

# or we can use the "arrange" verb in the 'tidyverse':
turtles.df %>% 
  arrange(carapace_length)

# or if we want in descending order...

turtles.df %>% 
  arrange(desc(carapace_length))

# Sorting by 2 columns
turtles.df %>% 
  arrange(sex,weight)


# CHALLENGE EXERCISES   -------------------------------------

# 1: Save the "comm_data.txt" file to your working directory. Read this file in as a data frame. Select only only the following columns: Hab_class, C_DWN, C_UPS (discard the remaining columns). Finally, rename these columns as: "Class","Downstream", and "Upstream" respectively. [hint 1: use read_table to read in the file as a data frame] [hint 2: use the "select" verb to select the columns you want] [hint 3: use the names() function to rename the columns]
# 
# 2: Read in the file "turtle_data.txt". Create a new version of this data frame with all missing data removed (discard all rows with one or more missing data). Save this new data frame to your project directory as a comma delimited text file. [hint 1: use the "na.omit()" function to remove rows with NAs] [hint 2: use the write_csv function to write to your working directory] 
#   
# 3: Read in the file "turtle_data.txt". Create a new data frame with only male turtles. Use this subsetted data set to compute the mean and standard deviation for carapace length of male turtles.




#  Missing Data 

# NOTE: you need to specify that this is a tab-delimited file. It is especially important to specify the delimiter for data files with missing data. If you specify the header and what the text is delimited by correctly, it will read missing data as NA. Otherwise it will fail to read data in properly.

missing.df <- read_delim(file="data_missing.txt",delim="\t")   # try replacing with "read_table"- it does not work right!

# Missing data are read as an NA
missing.df

# Can summarize your data and tell you how many NA's per col
summary(missing.df)

# Omits (removes) rows with missing data
na.omit(missing.df)

# ?is.na   (Boolean test!)
is.na(missing.df)

complete.cases(missing.df)   # Boolean: for each row, tests if there are no NA values

# Replace all missing values in the data frame with a an interpolation function from tidyverse: replace_na

missing.df %>% 
  mutate(Export = replace_na(Export,mean(Export,na.rm=T)),
         Import = replace_na(Import,mean(Import,na.rm=T)))

# or using tidyverse trickery (less code repetition)
missing.df %>% 
  mutate(across(where(is.numeric),~replace_na(.,mean(.,na.rm=T))))


#  ASIDE: using the pipe operator %>% (ctrl-shift-m) in R 

# start with a simple example
x <- 3

# calculate the log of x
log(x) # form f(x) is equivalent to

x %>% log() # form x %>% f

# example of multiple steps in pipe
round(log(x), digits=2) # form g(f(x)) is equivalent to

x %>% log() %>% round(digits=2) 


#  Data Manipulation using subsetting 

# list of tags we do not trust the data for
bad.tags <- c(13,105)

turtles.df = turtles.df %>% 
  mutate(
    sex = replace(sex,tag_number%in%bad.tags,NA),
    carapace_length = replace(carapace_length,tag_number%in%bad.tags,NA),
    head_width = replace(head_width,tag_number%in%bad.tags,NA),
    weight = replace(weight,tag_number%in%bad.tags,NA)
  )

# or... use some more tidyverse helper functions and tricks!

turtles.df = turtles.df %>% 
  mutate(across(c("sex","carapace_length","head_width","weight"),
                ~replace(.,tag_number%in%bad.tags,NA)))

# or use the following non-tidyverse syntax... which still seems easier to me!

turtles.df[turtles.df$tag_number%in%bad.tags,c("sex","carapace_length","head_width","weight")]  <- NA

turtles.df

 # make a new variable "size.class" based on the "weight" variable

turtles.df = turtles.df %>% 
  mutate(size.class = case_when(
    weight < 3 ~ "juvenile",
    weight > 6 ~ "adult",
    is.na(weight) ~ NA_character_,
    .default = "subadult"
  ))

turtles.df$size.class

