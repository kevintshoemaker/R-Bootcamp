
# https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf

# based on http://varianceexplained.org/RData/lessons/lesson4/segment6/

# Clear workspace ---------------------

rm(list=ls())

# Load packages ------------------

library(data.table)
library(ggplot2)
library(tidyverse)

# Load data -------------------

# Baseball data ----------------------
salaries <- read.csv("http://dgrtwo.github.io/pages/lahman/Salaries.csv")
salaries <- as.data.table(salaries)

master <- read.csv("http://dgrtwo.github.io/pages/lahman/Master.csv")
master <- as.data.table(master)

batting <- read.csv("http://dgrtwo.github.io/pages/lahman/Batting.csv")
batting <- as.data.table(batting)

data("diamonds")   # for ggplot demos, following varianceexplained r lesson

library(dplyr)


# gene expression data ---- 

url <- "http://varianceexplained.org/files/Brauer2008_DataSet1.tds"

cleaned_data <- read_delim(url, delim = "\t") %>%
  separate(NAME, c("name", "BP", "MF", "systematic_name", "number"), sep = "\\|\\|") %>%
  mutate_at(vars(name:systematic_name), funs(trimws)) %>%
  select(-number, -GID, -YORF, -GWEIGHT) %>%
  gather(sample, expression, G0.05:U0.3) %>%
  separate(sample, c("nutrient", "rate"), sep = 1, convert = TRUE) %>%
  filter(!is.na(expression), systematic_name != "")

cleaned_data %>%
  filter(BP == "leucine biosynthesis") %>%
  ggplot(aes(rate, expression, color = nutrient)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  facet_wrap(~name + systematic_name)

##########
# explore data

summary(salaries)
salaries

summary(master)
master

summary(batting)
batting

############
# summarize data

salaries.year <- salaries[,list(salary=mean(salary)),by=yearID]

ggplot(salaries.year, aes(yearID,salary)) + geom_line()

salaries.year.lg <- salaries[,list(salary=mean(salary)),by=list(yearID,lgID)]

salaries[order(yearID),list(yearID)]





