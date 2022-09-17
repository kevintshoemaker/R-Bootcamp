
#  R Bootcamp #1, Module 4
#       University of Nevada, Reno             
#       Data wrangling!

library(tidyverse)
library(lubridate)


#  Import and "tidy" your data  -----------------------------

# import meteorological data from Hungry Horse (HH) and Polson Kerr (PK) dams as tibble dataframe using readr 
clim_data <- read_csv("MTMetStations.csv")

# quick look at the contents
clim_data

 # display the last few lines of the data frame (often useful to check!)
tail(clim_data)


#  Use Tidyr verbs to make data 'tidy' 

# look at clim_data -- is it in tidy format? What do we need to do to get it there?
head(clim_data)


# step 1: pivot this data frame into long format: 
#    we will create a new column called 'climvar_station', and all of the numeric precip and temp values into a column called 'value'. 
clim_vars_longer <- clim_data %>% pivot_longer( 
                           cols = !Date,
                           names_to = "climvar_station",
                           values_to = "value"
                    )

clim_vars_longer


# step 2: separate the climvar_station column into two separate columns that identify the climate variable and the station
clim_vars_separate <- clim_vars_longer %>% separate(
                           col = climvar_station, 
                           into = c("Station","climvar")
                      )

clim_vars_separate


# step 3: pivot_wider distributes the clim_var column into separate columns, with the data values from the 'value' column

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


#  Use dplyr verbs to wrangle data   ----------------------------

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

  
# using an even more compact form:

# take tidy_clim_data, then
# group data by station, then 
# calculate summary (mean of all non-NA values) for numeric data only, then 
# transform temp data (.) from F to C, then
# transform precip data (.) from in to mm


station_mean2 <- tidy_clim_data %>%
  group_by(Station) %>% 
  summarize(across(where(is.numeric), mean, na.rm=TRUE)) %>%
  mutate(across(c("TMaxF", "TMinF"), ~(.-32)*(5/9)))   %>% 
  rename_with(~gsub("F","C",.),starts_with("T")) %>% 
  mutate(across(PrcpIN, ~.*25.4,.names="Prcp_mm")) %>% 
  select(!PrcpIN)

station_mean2
  

#  Using lubridate to format and create date data types -----------------

library(lubridate)

date_string <- ("2017-01-31")

# convert date string into date format by identifing the order in which
#   year, month, and day appear in your dates, then arrange "y", "m", and #   "d" in the same order. That gives you the name of the lubridate
#    function that will parse your date

ymd(date_string)

# note the different formats of the date_string and date_dtformat objects in the environment window.

# a variety of other formats/orders can also be accommodated. Note how each of these are reformatted to "2017-01-31" A timezone can be specified using tz=

mdy("January 31st, 2017")
dmy("31-Jan-2017")
ymd(20170131)
ymd(20170131, tz = "UTC")

# can also make a date from components. 
#   this is useful if you have columns for year, month, 
#   day in a dataframe

year<-2017
month<-1
day<-31
make_date(year, month, day)


# times can be included as well. Note that unless otherwise specified, R assumes UTC time

ymd_hms("2017-01-31 20:11:59")
mdy_hm("01/31/2017 08:01")

# we can also have R tell us the current time or date

now()
today()


#  Parsing dates with lubridate 

datetime <- ymd_hms("2016-07-08 12:34:56")

# year
year(datetime)

# month as numeric
month(datetime)

# month as name
month(datetime, label = TRUE)

# day of month
mday(datetime)

# day of year (often incorrectly referred to as julian day)
yday(datetime)

# day of week
wday(datetime)
wday(datetime, label = TRUE, abbr = FALSE)


###  Using lubridate with dataframes and dplyr verbs

# going back to our tidy_clim_data dataset we see that 
#   the date column is formatted as character, not date

head(tidy_clim_data)

# change format of date column
tidy_clim_data <- tidy_clim_data %>% 
  mutate(Date = mdy(Date))
tidy_clim_data
# parse date into year, month, day, and day of year columns
tidy_clim_data <- tidy_clim_data %>% 
  mutate(
    Year = year(Date),
    Month = month(Date),
    Day = mday(Date),
    Yday = yday(Date)
  )

tidy_clim_data

# calculate total annual precipitation by station and year
annual_sum_precip_by_station <- tidy_clim_data %>%
  group_by(Station, Year) %>%
  summarise(PrecipSum = sum(PrcpIN))

annual_sum_precip_by_station 


# CHALLENGE EXERCISES   -------------------------------------

# 1. Try to put tidyr's built-in `relig_income` dataset into a tidier format. 
#      This dataset stores counts based on a survey which (among other things) 
#      asked people about their religion and annual income:

# 2. Use the dplyr verbs and the tidy_clim_data dataset you created above 
#       to calculate monthly average Tmin and Tmax for each station (in Fahrenheit is okay)

# 3. Using lubridate, make a date object out of a character string of your 
#        birthday and find the day of week it occurred on. Note, you 
#        can use the 'wday' function in lubridate to extract the day of the #         week (1 is sunday).


