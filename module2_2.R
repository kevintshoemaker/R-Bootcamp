
##################################################
####                                          ####  
####  R Bootcamp #2, Module 2                 ####
####                                          #### 
####   University of Nevada, Reno             ####
####                                          #### 
##################################################


#########################################
####  Data Wrangling with Tidyverse  ####
####                                 ####
####  Author: Christine Albano       ####
#########################################



# install.packages("tidyverse")
library(tidyverse)


####
####  Using the pipe operator %>% (ctrl-shift-m)
####

# start with a simple example
x <- 3

# calculate the log of x
log(x) # form f(x) is equivalent to

x %>% log() # form x %>% f

# example of multiple steps in pipe
round(log(x), digits=2) # form g(f(x)) is equivalent to

x %>% log() %>% round(digits=2) # form x %>% f %>%  g


####
####  Import data as a Tibble dataframe and take a quick glance
####

# import meteorological data from Hungry Horse (HH) and Polson Kerr (PK) dams as tibble dataframe using readr 
clim_data <- read_csv("MTMetStations.csv")

# display tibble - note nice formatting and variable info, entire dataset is not displayed as is case in read.csv
clim_data

 # display the last few lines of the data frame
tail(clim_data)


####
####  Use Tidyr verbs to make data 'tidy'
####

# look at clim_data -- is it in tidy format? What do we need to do to get it there?
head(clim_data)

# gather column names into a new column called 'climvar_station', and all of the numeric precip and temp values into a column called 'value'. By including -Date, we indicate that we don't want to gather this column.
clim_vars_longer <- clim_data %>% pivot_longer( 
                           cols = !Date,
                           names_to = "climvar_station",
                           values_to = "value"
                    )

clim_vars_longer

# separate the climvar_station column into two separate columns that identify the climate variable and the station
clim_vars_separate <- clim_vars_longer %>% separate(
                           col = climvar_station, 
                           into = c("Station","climvar")
                      )

clim_vars_separate

# pivot_wider distributes the clim_var column into separate columns, with the data values from the 'value' column
tidy_clim_data <- clim_vars_separate %>% pivot_wider( 
                        names_from = climvar, 
                        values_from = value
                  )

tidy_clim_data

  
# repeat above as single pipe series without creation of intermediate datasets
  
tidy_clim_data <- clim_data %>% 
  pivot_longer(cols = !Date,
               names_to = "climvar_station",
               values_to = "value") %>% 
  separate(col = climvar_station, 
           into = c("Station","climvar")) %>% 
  pivot_wider(names_from = climvar, 
              values_from = value)
  
tidy_clim_data



####
####  Use dplyr verbs to wrangle data
####

# example of simple data selection and summary using group_by, summarize, and mutate verbs

# take tidy_clim_data, then
# group data by station, then 
# calculate summaries and put in columns with names mean.precip.in, mean.TMax.F, and mean.Tmin.F, then 
# transform to metric and put in new columns mean.precip.in, mean.TMax.F, and mean.Tmin.F

station_mean1 <- tidy_clim_data %>%
  group_by(Station) %>% 
  summarize(
    mean.precip.in = mean(PrcpIN, na.rm=TRUE),
    mean.TMax.F = mean(TMaxF, na.rm=TRUE),
    mean.TMin.F = mean(TMinF, na.rm=TRUE)) %>%
  mutate(
    mean.precip.mm = mean.precip.in * 25.4,
    mean.TMax.C = (mean.TMax.F - 32) * 5 / 9,
    mean.TMin.C = (mean.TMin.F - 32) * 5 / 9
  )
  
station_mean1
  
# using variants

# take tidy_clim_data, then
# group data by station, then 
# calculate summary (mean of all non-NA values) for numeric data only, then 
# transform temp data (.) from F to C, then
# transform precip data (.) from in to mm


station_mean2 <- tidy_clim_data %>%
  group_by(Station) %>% 
  summarize_if(is.numeric, mean, na.rm=TRUE) %>%
  mutate_at(vars(TMaxF, TMinF), funs(C=(.-32)*5/9)) %>% 
  mutate_at(vars(PrcpIN), funs(Prcp.mm=.*25.4))

station_mean2
  

#### 
####  Using lubridate to format and create date data types
####

library(lubridate)

date_string <- ("2017-01-31")

# convert date string into date format by identifing the order in which year, month, and day appear in your dates, then arrange "y", "m", and "d" in the same order. That gives you the name of the lubridate function that will parse your date

date_dtformat <- ymd(date_string)

# note the different formats of the date_string and date_dtformat objects in the environment window.

# a variety of other formats/orders can also be accommodated. Note how each of these are reformatted to "2017-01-31" A timezone can be specified using tz=

mdy("January 31st, 2017")
dmy("31-Jan-2017")
ymd(20170131)
ymd(20170131, tz = "UTC")

# can also make a date from components. this is useful if you have columns for year, month, day in a dataframe
year<-2017
month<-1
day<-31
make_date(year, month, day)


# times can be included as well. Note that unless otherwise specified, R assumes UTC time

ymd_hms("2017-01-31 20:11:59")
mdy_hm("01/31/2017 08:01")

# we can also have R tell us the current time or date

now()
now(tz = "UTC")
today()


####
####  Parsing dates with lubridate
####

datetime <- ymd_hms("2016-07-08 12:34:56")

# year
year(datetime)

# month as numeric
month(datetime)

# month as name
month(datetime, label = TRUE)

# day of month
mday(datetime)

# day of year (julian day)
yday(datetime)

# day of week
wday(datetime)
wday(datetime, label = TRUE, abbr = FALSE)


#### 
####  Using lubridate with dataframes and dplyr verbs
####

# going back to our tidy_clim_data dataset we see that the date column is formatted as character, not date
head(tidy_clim_data)

# change format of date column
tidy_clim_data <- tidy_clim_data %>% 
  mutate(Date = mdy(Date))
tidy_clim_data
# parse date into year, month, day, and day of year columns
tidy_clim_data <- tidy_clim_data %>% mutate(
  Year = year(Date),
  Month = month(Date),
  Day = mday(Date),
  Yday = yday(Date))

tidy_clim_data

# calculate total annual precipitation by station and year
annual_sum_precip_by_station <- tidy_clim_data %>%
  group_by(Station, Year) %>%
  summarise(PrecipSum = sum(PrcpIN))

annual_sum_precip_by_station 

