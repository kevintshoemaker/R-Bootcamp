
#  R Bootcamp #2, Submodule 2.1 
#   University of Nevada, Reno            
#   Expanding R functionality: packages etc. 


# PACKAGES!  ---------------------

# install.packages("modeest")    # uncomment and run this if you haven't yet installed the package from CRAN! 
                                   # you only need to install this once, so you can comment it out if
                                   # you already have this package installed


library(modeest)    # load the package: This is package 'modeest' written by P. PONCET.


library(help = "modeest")    # get overview of package


newdf <- read.table(file="data_missing.txt", sep="\t", header=T)

# ?mlv   ?mfv # learn more about the functions for computing the mode (most likely value or most frequent value). Who knew there were so many methods for computing the mode?

  # lets find the most frequent value(s) in the "Export" column:
mfv(newdf$Export, na.rm = T)    


detach("package:modeest")  # remove the package from your current working session


# install package from GitHub:

 # install.packages("remotes")    # run this if you haven't already installed the "remotes" package
library(remotes)
remotes::install_github("AckerDWM/gg3D")  # install a package from GitHub!


# 3D Plotting example ---------------

library(tidyverse)
library(deSolve)
library(ggplot2)
library(plotly) 


# Data: dog barks per day (and two explanatory variables)

dogbarks <- tibble(
  Cars= c(32, 28, 9, 41, 23, 26, 26, 31, 12, 25, 32, 13, 19, 19, 38,
          36, 43, 26, 21, 15, 17, 12, 7, 41, 38, 33, 31, 9, 40, 21),
  Food= c(0.328, 0.213, 0.344, 0.339, 0.440, 0.335, 0.167, 0.440, 0.328,
          0.100, 0.381, 0.175, 0.238, 0.360, 0.146, 0.430, 0.446, 0.345,
          0.199, 0.301, 0.417, 0.409, 0.142, 0.301, 0.305, 0.230, 0.118,
          0.272, 0.098, 0.415),
  Bark=c(15, 14, 6, 12, 8, 1, 9, 8, 1, 12, 14, 9, 8, 1, 19, 8, 13, 9,
       15, 11, 8, 7, 8, 16, 15, 10, 15, 4, 17, 0)
)

# plotly package to make 3d plot

plot_ly(x=dogbarks$Cars, y=dogbarks$Food, z=dogbarks$Bark, type="scatter3d", mode="markers", color="lightblue")


# Learning more about packages --------------------

# Package overview

library(help = "car")    # help file for the "car" package for applied regression


# package vignette 

browseVignettes('car')
vignette('embedding','car')   # pull up the "embedding" vignette in the 'car' package


# Load html documentation for R and all installed packages 

help.start()


# Built-in examples 

example(lm)   # run examples for "lm" function (included in base R)


# package citations 

citation('car')   # citation for the 'car' package

citation()    # and here's the citation for R in general- useful for when you use R for manuscripts

