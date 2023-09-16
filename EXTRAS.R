
# R DEMO ----------------------  
#     don't worry if you don't understand this just yet- this is just a 
#     taste of where we are going!


# Install packages 
#   NOTE you only have to do this once. If you have not already installed the packages, you can uncomment and run the following lines:

# install.packages(c("ggplot2","tidyverse"))


# Load packages 

library(ggplot2)
library(tidyverse)
library(Lahman)    # for getting baseball data


# Read in data (from the web) 

salaries <- read_csv("http://dgrtwo.github.io/pages/lahman/Salaries.csv")

master <- read_csv("http://dgrtwo.github.io/pages/lahman/Master.csv")

batting <- read_csv("http://dgrtwo.github.io/pages/lahman/Batting.csv")

# Read in data from package (you can read in all of these from the Lahman package!)

fielding <- tibble(Lahman::Fielding)


# explore the data 

salaries
# summary(salaries)    # summary statistics for all variables in data frame

master
# summary(master)

batting
# summary(batting)

fielding
# summary(fielding)


# Do some wrangling! 

 # merge the batting and salaries data frames
merged.batting = left_join(batting, salaries, by=c("playerID", "yearID", "teamID", "lgID"))

 # merge the "master" dataset (player biographical info)
merged.bio = inner_join(merged.batting, master, by="playerID")

 # summarize fielding data by year and player- prepare to merge with other data
fielding.temp = fielding %>% 
  group_by(playerID,yearID,teamID,lgID) %>%     # 
  summarize(position = first(modeest::mfv(POS)),
            games = sum(G))

merged.all = inner_join(merged.bio,fielding.temp,by=c("playerID", "yearID", "teamID", "lgID"))
merged.all = merged.all %>%    # remove all rows with no at-bats... 
  filter( AB > 0 )

# range(merged.all$AB)

merged.all = merged.all %>%     # make a new column with the full name
  mutate(name=paste(nameFirst, nameLast))


# summarize by player 

summarized.batters = merged.all %>% 
  group_by(playerID) %>% 
  summarise(name=first(name),
            League=first(modeest::mfv(lgID)),
            Position=first(modeest::mfv(position)),
            First.yr=min(yearID),
            Total.HR=sum(HR),
            Total.R=sum(R),
            Total.H=sum(H),
            AB=sum(AB),
            BattingAverage=sum(H) / sum(AB) ) %>% 
  arrange(desc(Total.HR))


# visualize the data 

  # visualize correlation between hits and runs
ggplot(summarized.batters, aes(Total.H, Total.R)) + geom_point()

  # visualize histogram of batting average
ggplot(summarized.batters, aes(BattingAverage)) + geom_histogram()

  # remove "outliers" and try again
summarized.batters = summarized.batters %>% 
  filter(AB>100&First.yr>1920)

ggplot(summarized.batters, aes(BattingAverage)) + geom_histogram()

ggplot(summarized.batters, aes(BattingAverage,col=League)) + geom_density()

# Why does NL density plot indicate a sizable number of players with very low batting average?

# make a new variable to indicate whether each player is a pitcher or position player

summarized.batters = summarized.batters %>% 
  mutate(Pitcher=ifelse(Position=="P","Pitcher","Position Player"))

ggplot(summarized.batters, aes(BattingAverage)) + 
	geom_histogram(aes(y = ..density..,group=Pitcher)) + 
  geom_density(aes(col=Pitcher),lwd=1.5) +
	stat_function(
		fun = dnorm, 
		args = with(summarized.batters, c(mean = mean(BattingAverage[Position!="P"]), 
		                                  sd = sd(BattingAverage[Position!="P"]))),
		col="lightblue",lwd=1.1
		)   + 
   stat_function(
		fun = dnorm, 
		args = with(summarized.batters, c(mean = mean(BattingAverage[Position=="P"]), 
		                                  sd = sd(BattingAverage[Position=="P"]))),
		col="pink",lwd=1.1
		)   +
	 labs(x="Batting Average",title = "Histogram with Normal Curve")  


# Summmarize by time (and league) 

summarized.year = merged.all %>% 
  filter(yearID>1920) %>%
  group_by(yearID,lgID) %>% 
  summarise(Total.HR=sum(HR),
            Total.R=sum(R),
            Total.H=sum(H),
            AB=sum(AB),
            BattingAverage=sum(H) / sum(AB) ) %>% 
  arrange(yearID, lgID)


summarized.year

# visualize the data 

  # visualize trend in home runs
ggplot(summarized.year, aes(yearID, Total.HR, col=lgID)) + 
  geom_line()

  # visualize trend in batting average
ggplot(summarized.year, aes(yearID, BattingAverage, col=lgID)) + 
  geom_line()



# Summarize by time and team

summarized.teams.year = merged.all %>%
  filter(yearID>1920) %>%
  group_by(yearID,teamID) %>% 
  summarise(League = first(lgID),
            Total.HR=sum(HR),
            Total.R=sum(R),
            Total.H=sum(H),
            AB=sum(AB),
            BattingAverage=sum(H) / sum(AB) ) %>% 
  arrange(desc(Total.HR))


summarized.teams.year

# visualize the data 

  # visualize correlation between home runs and year
ggplot(summarized.teams.year, aes(yearID, Total.HR)) + 
  geom_point(show.legend = FALSE) +
  geom_smooth() +
  facet_wrap('League')



ggplot(summarized.teams.year,aes(yearID,Total.HR))+
  geom_point() +
  geom_smooth(method="lm")

model1 <- lm(Total.HR~yearID,summarized.teams.year)  # linear regression analysis
summary(model1)


# test key assumptions visually

layout(matrix(1:4,nrow=2,byrow=T))  # set up graphics window
plot(model1)  # run diagnostic plots for our regression

