# answers1

# Module 1_1 challenge problems: answers  -------------


### Challenge 1: Create a 3 row by 2 column matrix named "mymat". Use the "rbind()" function to bind the following three rows together using these three vectors as rows:

mymat <- rbind(
  c(1,4),
  c(2,5),
  c(3,6)
)

### Challenge 2: Create a new matrix called 'mymat2' that includes all the data from columns 3 to 5 of data frame mydf. HINT: use the "as.matrix()" function to coerce a data frame into a matrix.

mymat2 <- as.matrix(mydf[,3:5])

### Challenge 3: Create a list named 'mylist' that is composed of a vector: 1:3, a matrix: matrix(1:6,nrow=3,ncol=2), and a data frame: data.frame(x=c(1,2,3),y=c(TRUE,FALSE,TRUE),z=c("a","a","b")).

mylist <- list()
mylist[[1]] <- 1:3
mylist[[2]] <- matrix(1:6,nrow=3,ncol=2)
mylist[[3]] <- data.frame(x=c(1,2,3),y=c(TRUE,FALSE,TRUE),z=c("a","a","b"))

### Challenge 4: Extract the first and third observation from the 2nd column of the data frame in 'mylist' (the list created in challenge 6 above).

mylist[[3]][[2]][c(1,3)]


### Challenge 5: (optional, extra challenging!) Create a data frame named 'df_spatial' that contains 25 spatial locations, with 'long' and 'lat' as the column names (25 rows/observations, 2 columns/variables). These locations should describe a 5 by 5 regular grid with extent long: [-1,1] and lat: [-1,1]. 

# challenge 5

x <- rep(seq(-1,1,length=5),each=5)
y <- rep(seq(-1,1,length=5),times=5)
df_spatial <- data.frame(long=x,lat=y)
plot(x=df_spatial$long, y=df_spatial$lat, main="Regular grid",xlab="long",ylab="lat",xlim=c(-1.5,1.5),ylim=c(-1.5,1.5),pch=20,cex=2)
abline(v=c(-1,1),h=c(-1,1),col="green",lwd=1)






# Module 1_2 challenge problems: answers  -------------


# 1: Save the "comm_data.txt" file to your working directory. Read this file in as a data frame. Select only only the following columns: Hab_class, C_DWN, C_UPS (discard the remaining columns). Finally, rename these columns as: "Class","Downstream", and "Upstream" respectively. [hint 1: use read_table to read in the file as a data frame] [hint 2: use the "select" verb to select the columns you want] [hint 3: use the names() function to rename the columns]

comdat <- read_table("comm_data.txt")
comdat <- comdat %>% 
  select(Hab_class,C_DWN,C_UPS)
names(comdat) <- c("Class","Downstream", "Upstream")

# 2: Read in the file "turtle_data.txt". Create a new version of this data frame with all missing data removed (discard all rows with one or more missing data). Save this new data frame to your project directory as a comma delimited text file. [hint 1: use the "na.omit()" function to remove rows with NAs] [hint 2: use the write_csv function to write to your working directory] 

turt1 <- read_table("turtle_data.txt")
turt1 <- na.omit(turt1)
write_csv(turt1,"turt_test1.csv")

# 3: Read in the file "turtle_data.txt". Create a new data frame with only male turtles. Use this subsetted data set to compute the mean and standard deviation for carapace length of male turtles.

turt1 <- read_table("turtle_data.txt")
turtmale <- turt1 %>% 
  filter(sex=="male")
mean(turtmale$carapace_length)
sd(turtmale$carapace_length)




# Module 1_3 soils solutions:

# basic boxplot and violin plot

plot1 <- ggplot(soil) +
  geom_boxplot(aes(x=Contour, y=pH))

plot2 <- ggplot(soil) + 
  geom_violin(aes(x=Contour, y=pH))

plot_grid(plot1,plot2,labels = "AUTO")



# basic scatterplot

ggplot(soil) +
  geom_point(aes(x=pH, y=Ca))


# Color the points by depth

ggplot(soil) +
  geom_point(aes(x=pH, y=Ca, color=Depth))


# make additional alterations (outside the "aes" function)

ggplot(soil) +
  geom_point(aes(x=pH, y=Ca, fill=Depth), shape=21, color="black", size=4, stroke=1.5)



# Module 1_3 challenge problems: answers  -------------


# 1. Using our scatterplot of calcium by pH, in which points were colored according to which depth they represent, 
#     fit a separate trendline for each depth category. Have the color of the trendline match the color of each 
#     cloud of points. Remove the confidence band from the trendlines. 

ggplot(soil) +
  geom_point(aes(pH, Ca, fill=Depth), shape=21, color='black', size=4, stroke=1.5) +
  geom_smooth(method='lm', aes(pH, Ca, color=Depth), se=FALSE) +
  theme_bw() +
  ylab('Ca (mg/100g soil)') +
  scale_fill_manual(values=c('#FFF0BF','#FFC300','#BF9200','#604900'), name='Depth (cm)') +
  scale_color_manual(values=c('#FFF0BF','#FFC300','#BF9200','#604900'))

#
# 2. Create a boxplot that shows the values of Ca, Mg, and Na across all 3 contour positions, with no faceting (all on one plot). 
#     Add a diamond symbol indicating the mean value across all 3 contour positions for each nutrient.
#

ggplot(soil.nut) +
  geom_boxplot(aes(nutrient, value, fill=Contour)) +
  stat_summary(aes(nutrient, value), 
               fun=mean, geom="point", shape=18, size=4, color='black')

# 3. Plot the density curves of Ca, Mg, and Na atop each other with fixed y and x axes. Make them transparent in color 
#     (use `alpha=0.5`) in order to see overlapping areas.

ggplot(soil.nut) +
  geom_density(aes(x=value, fill=nutrient), color="black", alpha=0.5) +
  xlab("mg / 100g soil") +
  theme_dark() +
  theme(axis.text = element_text(size=14),
        axis.title = element_text(size=16),
        strip.text = element_text(size=16, face="bold"))






# Module 1_4 challenge problems: answers  -------------


# 1. Create a tibble dataframe using the code below (`tribble()` constructs a tibble by rows)
#      and make it tidy. Do you need to pivot_longer or pivot_wider?

relig_income %>% 
  pivot_longer(cols=!religion, names_to = "Income",values_to="count")

# 2. Use the dplyr verbs and the tidy_clim_data dataset you created above 
#       to calculate monthly average Tmin and Tmax (in Fahrenheit is okay) for each station

tidy_clim_data %>% 
  group_by(Station,Month) %>% 
  summarize(across(c(TMinF,TMaxF),mean))

# 3. Using lubridate, make a date object out of a character string of your 
#        birthday and find the day of week it occurred on. Note, you 
#        can use the 'wday' function in lubridate to extract the day of the #         week (1 is sunday).

mybday <- "12/12/1977"
mybday <- mdy(mybday)
wday(mybday,label=T)










