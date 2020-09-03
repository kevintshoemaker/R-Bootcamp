
##################################################
####                                          ####  
####  R Bootcamp #2, Module 4                 ####
####                                          #### 
####   University of Nevada, Reno             ####
####                                          #### 
##################################################

##################################################
####  Parallel processing in R                ####
####  Developed by: Jonathan Greenberg         ####
####     jgreenberg@unr.edu                   ####
##################################################



################
# Set up the workspace (can take a surprisingly long time!)

# examples from http://trg.apbionet.org/euasiagrid/docs/parallelR.notes.pdf

# First, load this script directly from the web (which also installs required packages for you!):

if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("Biobase")



data(geneData, package = "Biobase")   # load example data from Biobase package between all pairs of genes across all samples.
  # geneData <- read.csv("geneData.csv")    # alternative!


# This data represents 500 genes (organized by rows)
# with expression data (numerical). 

# The goal is to calculate the correlation coefficient
# between all pairs of genes across all samples.  For example,
# to test gene 12 vs 13:


?cor    # view help page for "cor()" function
geneData[12,]
geneData[13,]


plot(geneData[12,],geneData[13,])    # plot the correlation between two genes
cor(geneData[12,],geneData[13,])


?combn    # function to determine all combination ids


pair <- combn(1:nrow(geneData),2,simplify=F)   #leave this as a list, for now...

length(pair)
head(pair,n=3)     # note that the "head()" and "tail()" functions can be used on lists in addition to data frames...
tail(pair,n=3)


############
# New function: accepts a gene pair and the database as arguments and returns
# the correlation:

geneCor <- function(pair,gene=geneData){
  cor(gene[pair[1],],gene[pair[2],])
}

# Test the function:
cor(geneData[12,],geneData[13,])
geneCor(pair=c(12,13),gene=geneData)    # should be the same result as the previous command...


########
# use "lapply" to run our function on the first three gene pairs

pair[1:3]
outcor <- lapply(pair[1:3],geneCor)
outcor


#################
# Examine processor use and speed

# First, open your task manager to view processor usage (see website for more details).

system.time(outcor <- lapply(pair,geneCor))

# Notice ONE CPU spiked.  Make note of how long it took to run.


fakeData <- cbind(geneData,geneData,geneData,geneData)    # make an even bigger dataset!


###########
# New, more complex function that generates bootstrap confidence intervals for correlation coefficients

library(boot)   # load the "boot" library for performing bootstrapping analysis

# 'x' represents vector with two elements, indicating the pair of genes to compare
# 'gene' represents a gene expression database

geneCor2 <- function(x, gene = fakeData){
  mydata <- cbind(gene[x[1], ], gene[x[2], ])      # extract the rows (genes) to compare
  mycor <- function(x, i) cor(x[i,1], x[i,2])     # function (correlation) to perform bootstrap analysis with
  boot.out <- boot(mydata, mycor, 1000)           # perform bootstrap analysis (1000 iterations)
  boot.ci(boot.out, type = "bca")$bca[4:5]         # extract and return the bootstrap confidence interval
}


# Test how long 10 pairs would take:
genCor2_system_time <- system.time(outcor <- lapply(pair[1:10],geneCor2))
genCor2_system_time["elapsed"] 


length(pair)   # how many pairs were there again?


############
# estimate time to run 124,750 pairs

genCor2_system_time["elapsed"]      # time it took to run 10 pairs, in seconds

genCor2_system_time["elapsed"] *(124750/10)     # time it would take to run 124750 pairs, in seconds 
genCor2_system_time["elapsed"] *(124750/10/60/60)    # in hours...


###########
# Explore parallel processing vs sequential processing

pair2 <- sample(pair,300)    # first extract a subsamble of all the pairs


# Let's test a sequential version of this:
system.time(outcor <- lapply(pair2,geneCor2))

# Note the elapsed time.


###########
# Run this operation in parallel!!

### parallel: built-in parallel computation package.
library("parallel")       # load the package (comes with basic R installation)

install.packages("future")    # install "future" package, which we will use later
library("future")


?makeCluster    # learn more about "makeCluster()"


########
# Make a cluster

myCluster <- parallel::makeCluster(spec=4,type="PSOCK")    # make cluster with 4 cpus of type "PSOCK"
myCluster

length(myCluster) # One entry per "worker".

myCluster[[1]]    # more info about this "worker"


?stopCluster
parallel::stopCluster(myCluster)


######
# Make a cluster with all available cores

mycorenum <- availableCores()   # determine number of available cores
myCluster <- parallel::makeCluster(spec=mycorenum,type="PSOCK")


######
# Run a function on each cluster:

?clusterCall       # clustercall(): sends the same function to each node (worker) in the cluster


date()    # run the "date()" function

workerDates <- parallel::clusterCall(cl=myCluster,fun=date)    # now try running the "date()" function on all clusters 
class(workerDates)
length(workerDates) # One list element per worker.


####
# explore packages loaded in our worker environments

search()      # packages loaded in global environment
workerPackages <- parallel::clusterCall(cl=myCluster,fun=search)     # .. and worker environments
# workerPackages


#########
# load required packages on every worker:

?clusterEvalQ
loadOnCls <- parallel::clusterEvalQ(cl=myCluster,library("boot"))   

# We can confirm the boot package is now loaded:
parallel::clusterCall(cl=myCluster,fun=search)


########
# Load required data on every worker

?clusterExport
loadData <- parallel::clusterExport(cl=myCluster,"fakeData")
parallel::clusterEvalQ(cl=myCluster,ls())   # Check the environment on each worker- make sure data are loaded


#### alternatively, load all data in our environment into each worker:
# loadData <- parallel::clusterExport(cl=myCluster,ls())
# parallel::clusterEvalQ(cl=myCluster,ls())


############
# Spread function calls across workers using an "lapply"-like function

?clusterApplyLB     # function for performing the actual function call


#######
# Call the "geneCor2()" function for each gene pair, using parallel processing

system.time(outcor2 <- parallel::clusterApplyLB(cl=myCluster,pair2,geneCor2))   

# vs the non-clustered version:
system.time(outcor <- lapply(pair2,geneCor2))   # takes much longer!


stopCluster(myCluster)   # finally, stop the cluster..


##########
# Parallel processing using 'foreach'

install.packages("foreach")
# Install the parallel backend to foreach:
install.packages("doParallel")


library("foreach")
library("doParallel")


?foreach

# sequential mode:
registerDoSEQ() # Avoids warnings

system.time(
  outcor <- foreach(
    p = pair2, 
    .packages="boot", 
    .combine="rbind") %dopar% { 
      return(geneCor2(p)) 
    }
)


# Parallel mode (use a parallel backend):

# Create a cluster using parallel:
myCluster <- makeCluster(spec=4,type="PSOCK")

# Register the backend with foreach (doParallel):
registerDoParallel(myCluster)
# Run our code! Notice I didn't change the foreach call at all:

system.time(
  outcor <- foreach(
    p = pair2, 
    .packages="boot",
    .combine="rbind") %dopar% {
      return(geneCor2(p)) 
    }
)


stopCluster(myCluster)     # Don't forget to stop the cluster:


registerDoSEQ()    # register the default, non-parallel backend for foreach

