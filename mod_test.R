
#  R Crash Course                

#  Module 4: Working with data

library(tidyverse)


#  Import/Export data files into R with base R functions----------------------

# read.table to import text file (if no delim specified, it will try to guess!)
data.txt.df <- read.table("data/raw/data.txt")  



# read.csv to import textfile with columns separated by commas
data.df <- read.csv("data/raw/data.csv")

#print data
data.df

# Remove redundant objects from memory
rm(data.txt.df)


  # Using Rs built-in data----------------------

# Look at all built-in data files
data()   


# read built-in data on car road tests performed by Motor Trend
data(mtcars) 

# inspect the first few lines
head(mtcars)   

# learn more about this built-in data set
# ?mtcars        


  # Basic data checking ----------------------

# ?str: displays the internal structure of the data object
str(mtcars)
str(data.df)



# get summary of the variables (columns) of a data object
summary(data.df)


# get summary info for a specific variable
summary(data.df$Import)


# Exporting data (save to hard drive as data file)

# ?write.csv: writes a CSV file to the working directory

# to save an entire data frame to your hard drive you would use the format below
# write.csv(data name in R, file = 'data name to save as.csv')

# however if we did this for data.df we would just be making a copy, instead we can export a subset of the data we just ran in
write.csv(data.df[, c("Country","Product")], # this tells R to save all rows for the 'Country' and 'Product' columns
          file = "data/processed/data_export.csv")   


# Working with data in R ------------------------

  # Assigning objects ----------------------

# <- assignment operator
# =  alternative assignment operator *avoid using this to assign objects to the environment

a <- 3     # assign the value "3" to the object named "a"
a = 3      # assign the value "3" to the object named "a" (alternative)
a == 3     # answer the question: "does the object "a" equal "3"? 


  # Boolean operations ----------------------

# Basic operators

# <    less than
# >    greater than
# <=   less than or equal to
# >=   greater than or equal to
# ==   equal to
# !=   not equal to
# %in% matches one of a specified group of possibilities

# Combining multiple conditions

# &    must meet both conditions (AND operator)
# |    must meet one of two conditions (OR operator)

Y <- 4
Z <- 6

Y == Z  #I am asking if Y is equal to Z, and it will return FALSE
Y < Z

!(Y < Z)  # the exclamation point reverses any boolean object (read "NOT")

# Wrong!
data.df[, 2] = 74     # sets entire second column equal to 74! OOPS WE GOOFED UP!!!

data.df <- read.csv("data/raw/data.csv")  ## correct our mistake in the previous line (revert to the original data)!

# Right
data.df[, 2] == 74    # tests each element of column to see whether it is equal to 74

data.df[, 2] < 74 | data.df[, 2] == 91   # use the logical OR operator


  # Sub-setting data base R----------------------

# select those rows of data for which second column is less than 74
data.df[data.df[, "Import"] < 74, ]  

# select rows of data for which second column is greater than 25 AND less than 75

data.df[data.df[, 'Import'] > 25 & 
          data.df[, 'Import'] <75, ]

  # Summary statistics with base R ----------------------

mean(data.df$Import)
sd(data.df$Import)


  # Packages----------------------

# Install packages 

# install.packages("tidyverse")


# Load packages to library 

library(tidyverse)


  # Package datasets ----------------------

ggplot2::diamonds   # note the use of the package name followed by two colons- this is a way to make sure you are using a function (or data set or other object) from a particular package... (sometimes several packages have functions with the same name...)




  # Read in tidy data ----------------------

tidy_data.txt <- read_delim('data/raw/data.txt')

# print data
tidy_data.txt


# check the object type of data

class(tidy_data.txt)


tidy_data.csv <- read_csv('data/raw/data.csv')

# print the first few rows of data
head(tidy_data.csv)

  # Export tidy data ----------------------

# ?write_csv

# write_csv(data, 'data_name_to_save.csv')

  # The pipe operator ----------------------

# start by assigning a value to x
x <- 3

# call the variable x followed by %>% ('then')
x %>% 
  
  # calculate the log of x, 'then'
  log() %>% 
  
  # round the log of x to 2 digits
  round(digits = 2) 


# Renaming columns ----------------------

# check names of turtles data before changing
names(turtles.df)

turtles.df %>% 
  
   # set column names to lowercase
  set_names(
    names(.) %>%  # the period here is a placeholder for the data it tells R to use the element before the last pipe (e.g., turtles.df)
      tolower()) 

# check the names of turtles data
names(turtles.df)

# read turtle_data.txt in to R using readr
turtles.df <- read_delim('data/raw/turtle_data.txt',
                         delim = '\t') %>% 
  
   # set column names to lowercase
  set_names(
    names(.) %>%  
      tolower()) 

summary(turtles.df)

# extract the column names for turtle data
names(turtles.df)

# to change the column names, use the "names()" function
names(turtles.df)  <- c("tag", "sex","c_length", "h_width", "weight")

# let's check
head(turtles.df)

# read turtle_data.txt in to R using readr
turtles.df <- read_delim('data/raw/turtle_data.txt',
                         delim = '\t') %>% 
  
   # set column names to lowercase
  set_names(
    names(.) %>%  
      tolower()) %>% 
  
  # rename columns to shorter names
  rename(tag = tag_number,
         c_length = carapace_length,
         h_width = head_width)

summary(turtles.df)
# calculate the mean and sd for three columns in the turtles data using dplyr

turtles.df %>% 
  
  # use summarise function to get mean and sd for multiple columns
  summarise(cl_mean = mean(c_length),
            cl_sd = sd(c_length),
            hw_mean = mean(h_width),
            hw_sd = sd(h_width),
            w_mean = mean(weight),
            w_sd = sd(weight)
  )


turtles.df %>% 
summarise_all(.funs = list(mean, sd))


turtles.df %>% 
summarise_if(is.numeric,
             .funs = list(mean, sd))

by_species <- iris %>%
  group_by(Species)

by_species %>%
  summarise(across(everything(), list(min = min, max = max)))

turtles.df %>% 
summarise_if(is.numeric,
             .funs = list(mean = mean, 
                          sd = sd))
# Change variable type ----------------------

# Change sex to factor
turtles.df %>% 
  mutate(sex = as.factor(sex)) # we use the same name for our 'new' column so that it modifies the old column instead of creating a new one

# check structure
str(turtles.df) # sex is still a character, why?

# Change sex to factor as save changes to data
turtles.df <-  turtles.df %>% 
  mutate(sex = as.factor(sex))

# check structure
str(turtles.df) 
# INSERT YOUR CODE HERE ----------------------

# Use the code below to read in the data and make changes we covered in the sections above, then in your script add a pipe and use the mutate function to change sex to a factor variable 


# read turtle_data.txt in to R using readr
turtles.df <- read_delim('data/raw/turtle_data.txt',
                         delim = '\t') %>% 
  
   # set column names to lowercase
  set_names(
    names(.) %>%  
      tolower()) %>% 
  
  # rename columns to shorter names
  rename(tag = tag_number,
         c_length = carapace_length,
         h_width = head_width)
# in this example we will specify how we want ALL of the data in the turtle_data.txt file to read in 

turtles.df <- read_delim('data/raw/turtle_data.txt',
                         delim = '\t',
                         
                         # specify variable types 
                         col_types = cols(Tag_number = col_number(),
                                          Sex = col_factor(),
                                          Carapace_length = col_number(),
                                          Head_width = col_number(),
                                          Weight = col_number())
) %>% 
  
  # set column names to lowercase
  set_names(
    names(.) %>%  
      tolower()) %>% 
  
  # rename columns to shorter names
  rename(tag = tag_number,
         c_length = carapace_length,
         h_width = head_width)

# or even less coding

turtles.df <- read_delim('data/raw/turtle_data.txt',
                         delim = '\t',
                         
                         # specify variable types 
                         col_types = cols(Sex = col_factor(),
                                          .default = col_number()) # this sets every variable not specified above to this type
)%>% 
  
  # set column names to lowercase
  set_names(
    names(.) %>%  
      tolower()) %>% 
  
  # rename columns to shorter names
  rename(tag = tag_number,
         c_length = carapace_length,
         h_width = head_width)
  # Subsetting data with tidyr ----------------------

  # Filter ----------------------

# subset turtles data
turtles.df %>% 
  
  # return data for males only
  filter(sex == 'male')

turtles.df %>% 
  
  # return data for males only that are larger than 5 (grams?)
  filter(sex == 'male' &
           weight > 5)

  # Select ----------------------

turtles.df %>% 
  
  # return data for tag and weight only
  select(tag, weight)
turtles.df %>%
  
  # return data for males only with weight greater than 5
  filter(sex == 'male' &
           weight > 5) %>% 

# return data for tag and weight only
  select(tag, weight)
turtles_males_lg <- turtles.df %>% 
    # return data for males only with weight greater than 5
  filter(sex == 'male' &
           weight > 5) %>% 

# return data for tag and weight only
  select(tag, weight)
  # Group by ----------------------

turtles.df %>% 
  
  # group by sex
  group_by(sex) %>% 
  
  summarise(mean = mean(weight))

 
