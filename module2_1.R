
##################################################
####                                          ####  
####  R Bootcamp #2, Module 1                 ####
####                                          #### 
####   University of Nevada, Reno             ####
####                                          #### 
##################################################


###################################################
####  Expanding R functionality: packages etc. ####
###################################################



##############
# PACKAGES!
##############

install.packages("modeest")    # run this if you haven't yet installed the package from CRAN! 
                                   # you only need to install this once, so you can comment it out if
                                   # you already have this package installed


library(modeest)    # load the package: This is package 'modeest' written by P. PONCET.

   # install.packages("BiocManager")
   # BiocManager::install("genefilter")    # you might need to install a dependency in order to make this work!


library(help = "modeest")    # get overview of package


newdf <- read.table(file="data_missing.txt", sep="\t", header=T)

# ?mlv   # learn more about the function for computing the mode (most likely value). Who knew there were so many methods for computing the mode?

  # lets find the most frequent value(s) in the "Export" column:
mlv(newdf$Export, method="mfv", na.rm = T)    


detach("package:modeest")  # remove the package from your current working session


#########
# 3D Plotting example 
#########

#########
# Data: dog barks per day (and two explanatory variables)

Cars= c(32, 28, 9, 41, 23, 26, 26, 31, 12, 25, 32, 13, 19, 19, 38,
        36, 43, 26, 21, 15, 17, 12, 7, 41, 38, 33, 31, 9, 40, 21)
Food= c(0.328, 0.213, 0.344, 0.339, 0.440, 0.335, 0.167, 0.440, 0.328,
        0.100, 0.381, 0.175, 0.238, 0.360, 0.146, 0.430, 0.446, 0.345,
        0.199, 0.301, 0.417, 0.409, 0.142, 0.301, 0.305, 0.230, 0.118,
        0.272, 0.098, 0.415)
Bark=c(15, 14, 6, 12, 8, 1, 9, 8, 1, 12, 14, 9, 8, 1, 19, 8, 13, 9,
       15, 11, 8, 7, 8, 16, 15, 10, 15, 4, 17, 0)


install.packages("car")
install.packages("rgl")   # you need this one as well!

library(car)


##########
# interactive 3-D graphics!

car::scatter3d(Bark~Food+Cars,surface=TRUE)


###########
# install package from GitHub:

 # install.packages("remotes")    # run this if you haven't already installed the "remotes" package
library(remotes)
install_github("kbroman/broman")  # install a random package from GitHub!


###########
# Learning more about packages
###########

###########
# Package overview

library(help = "car")    # help file for the useful "car" package for applied regression


##########
# package vignette

browseVignettes('car')
vignette('embedding','car')   # pull up the "embedding" vignette in the 'car' package


################
#### GENERAL TIPS
################

#############
# 1. Use code examples provided by others

# install.packages("dismo")     # install "dismo" for species distribution modeling

browseVignettes('dismo')
vignette('sdm','dismo')      # pull up one of the helpful vignettes from the 'dismo' package, with useful code examples! Many packages have built-in vignettes.
vignette('brt','dismo')      # and another one!


########
# package demo

demo(package="stats")    # list all demos for package 'stats', which is included in base R
demo('nlm','stats')


###########
# Load html documentation for R and all installed packages

help.start()


#########
# Built-in examples

example(lm)   # run examples for "lm" function (included in base R)


########
# package citations

citation('car')   # citation for the 'car' package

citation()    # and here's the citation for R in general- useful for when you use R for manuscripts



