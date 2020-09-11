
##################################################
####                                          ####  
####  R Bootcamp #2, Module 3                 ####
####                                          #### 
####   University of Nevada, Reno             ####
####                                          #### 
##################################################


#############################################
####  Data Visualization with 'ggplot2'  ####
####                                     ####
####  Author: Stephanie Freund           ####
#############################################


########
# Load packages!

## note: if you don't already have these packages you will need to install them first!

library(tidyverse)
library(ggplot2)
library(ggthemes)
library(carData)
library(DAAG)
library(RColorBrewer)
library(leaflet)


##############
# Load the example data!

data(Soils,package = "carData")    # load example data

#See what variables it contains...
soil <- data.frame(Soils)
head(soil)


########
# basic boxplot...

ggplot(soil) +
  geom_boxplot(aes(x=Contour, y=pH))


###########
# basic scatterplot

ggplot(soil) +
  geom_point(aes(x=pH, y=Ca))


########
# Color the points by depth

ggplot(soil) +
  geom_point(aes(x=pH, y=Ca, color=Depth))


##########
# make additional alterations (outside the "aes" function)

ggplot(soil) +
  geom_point(aes(x=pH, y=Ca, fill=Depth), shape=21, color="black", size=4, stroke=1.5)


######
# Plot several relationships on same graphics window

ggplot(soil, aes(x=pH)) +
  geom_point(aes(y=Ca), shape=21, fill="red", color="black", size=4, stroke=1.5) +
  geom_point(aes(y=Mg), shape=21, fill="blue", color="black", size=4, stroke=1.5) +
  geom_point(aes(y=Na), shape=21, fill="gray30", color="black", size=4, stroke=1.5)


#########
# Use 'tidyverse' tricks to simplify the syntax for ggplot to color by nutrient

soil.nut <- pivot_longer(soil, cols=c("Ca","Mg","Na"), names_to="nutrient",values_to = "value" )

ggplot(soil.nut) +
  geom_point(aes(x=pH, y=value, fill=nutrient), shape=21, color="black", size=4, stroke=1.5)


######
# or if we wanted to plot different nutrients...

soil.nut2 <- pivot_longer(soil, cols=c("Ca","Mg","K"), names_to="nutrient",values_to = "value" )

ggplot(soil.nut2) +
  geom_point(aes(x=pH, y=value, fill=nutrient), shape=21, color="black", size=4, stroke=1.5)


##########
# plot with facets, scales, and themes!

ggplot(soil.nut2) +
  geom_point(aes(x=pH, y=value, fill=nutrient), 
             shape=21, color="black", size=4, stroke=1.5) +
  facet_wrap(~nutrient, scales="free_y") +
  ylab("mg / 100 g soil") +
  theme_bw() +
  theme(legend.position="none",
        axis.text = element_text(size=14),
        axis.title = element_text(size=16),
        strip.text = element_text(size=16, face="bold"))
    

############
# Playing with colors in ggplot!

display.brewer.all()


#########
# Choose a new color palette from the RColorBrewer package

ggplot(soil) +
  geom_point(aes(x=pH, y=Ca, fill=Depth), shape=21, color="black", size=4, stroke=1.5) +
  theme_bw() +
  ylab("Ca (mg/100g soil)") +
  scale_fill_brewer(palette="YlOrBr", name="Depth (cm)")


#########
# Choose your own palette!

ggplot(soil) +
  geom_point(aes(x=pH, y=Ca, fill=Depth), shape=21, color="black", size=4, stroke=1.5) +
  theme_bw() +
  ylab("Ca (mg/100g soil)") +
  scale_fill_manual(values=c("#FFF0BF","#FFC300","#BF9200","#604900"), name="Depth (cm)")


##########
# add trendlines

ggplot(soil.nut2) +
  geom_point(aes(x=pH, y=value, fill=nutrient), 
             shape=21, color="black", size=4, stroke=1.5) +
  geom_smooth(aes(x=pH, y=value), method="lm", color="black") +
  facet_wrap(~nutrient, scales="free_y") +
  ylab("mg / 100 g soil") +
  theme_bw() +
  theme(legend.position="none",
        axis.text = element_text(size=14),
        axis.title = element_text(size=16),
        strip.text = element_text(size=16, face="bold"))

    

###########
# Adding density/smooth curves to plots

   ## first produce some histograms

ggplot(soil.nut) +
  geom_histogram(aes(x=value), color="black", fill="white", bins=15) +
  facet_wrap(~nutrient, scales="free") +
  xlab("mg / 100g soil") +
  theme_dark() +
  theme(axis.text = element_text(size=14),
        axis.title = element_text(size=16),
        strip.text = element_text(size=16, face="bold"))

########
# Then add density curves

ggplot(soil.nut) +
  geom_histogram(aes(x=value, y=..density..), color="black", fill="white", bins=15) +
  geom_density(aes(x=value,color=nutrient), size=1.5) +
  facet_wrap(~nutrient, scales="free") +
  xlab("mg / 100g soil") +
  theme_dark() +
  theme(legend.position="none",
        axis.text = element_text(size=14),
        axis.title = element_text(size=16),
        strip.text = element_text(size=16, face="bold"))


###########
# And now let's use a statistical function (dnorm) in ggplot to compare with a normal distribution:

ggplot(soil.nut) +
  geom_histogram(aes(x=value, y=..density..), color="black", fill="white", bins=15) +
  stat_function(fun = dnorm, color = "blue", size = 1.5,
                args=list(mean=mean(soil.nut$value), sd=sd(soil.nut$value))) +
  facet_wrap(~nutrient, scales="free") +
  xlab("mg / 100g soil") +
  theme_dark() +
  theme(legend.position="none",
        axis.text = element_text(size=14),
        axis.title = element_text(size=16),
        strip.text = element_text(size=16, face="bold"))


#######
# add error bars and other stat summaries (e.g., mean) to boxplot

ggplot(soil, aes(x=Contour, y=pH)) +
  stat_boxplot(geom="errorbar", width=0.2) +  
  geom_boxplot() +
  stat_summary(fun.y=mean, geom="point", size=5, color="black")
  

##########
# use leaflet for interactive mapping!

leaflet(possumsites) %>%
  addTiles() %>% #Adds map tiles from OpenStreetMap
  addMarkers(lng=c(possumsites$Longitude), lat=c(possumsites$Latitude), 
             popup=c(as.character(possumsites$altitude))) #Adds markers for the sites

