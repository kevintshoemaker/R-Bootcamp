#### R Bootcamp
#### Jonathan Greenberg, jgreenberg@unr.edu
#### Parallel R and Introduction to GIS
#### 8 September 2018

######## PARALLEL R ########
# This is a huge topic, but the basic
# concept of parallel programming is the following:
#
# Given some problem X that can be divided into 
# subproblems x1, x2, x3, each subproblem can
# be sent to a different "worker" processor (which may be
# located on a different physical computer).  Each
# processor then sends the results of its subproblem
# back to a central "master".  The master often then
# pieces the subproblems back together to return to the user.
#
# Parallel computing is not a cure-all, and not all problems
# will benefit from it.  We'll come back to this issue in a bit.
#
# There are a lot of packages to realize parallel computing
# within R, and current versions of R even come with some
# parallel computing packages built-in.  A full list can
# be found at:
# http://cran.r-project.org/web/views/HighPerformanceComputing.html

# I will be following the examples from:
# http://trg.apbionet.org/euasiagrid/docs/parallelR.notes.pdf

# First, grab this function:
source("http://bioconductor.org/biocLite.R")
biocLite("Biobase")

# We are going to run a test using genetic data:
data(geneData, package = "Biobase")
# This data represents 500 genes (organized by rows)
# with expression data (numerical).  
# The goal is to calculate the correlation coefficient
# between all pairs of genes across all samples.  For example,
# to test gene 12 vs 13:
?cor
geneData[12,]
geneData[13,]
plot(geneData[12,],geneData[13,])
cor(geneData[12,],geneData[13,])
# The total number of paired correlations will be:
#	500 x 499 / 2 = 124,750 correlations
# We can determine all combination ids using:
?combn
# We are going to leave this as a list, for now...
pair <- combn(1:nrow(geneData),2,simplify=F)
length(pair)
head(pair,n=3)
tail(pair,n=3)

# Let's write a function to accept a pair and the database and returns
# the correlation:
geneCor <- function(pair,gene=geneData)
{
  cor(gene[pair[1],],gene[pair[2],])
}

# TEST THIS:
cor(geneData[12,],geneData[13,])
geneCor(pair=c(12,13),gene=geneData)

# We left our pairs as a list, so we can, of course, use lapply:
# Let's just test the first 3 pairs:
pair[1:3]
outcor <- lapply(pair[1:3],geneCor)
outcor

# Now let's do the whole calculation.  First, open your task manager
# by hitting control-alt-delete and choosing Start Task Manager.
# Click the "Performance".  Notice you have a few graphs next to 
# CPU Usage, which shows each processor you have on your machine.

# Type the following and watch the CPU Usage History graph:

system.time(outcor <- lapply(pair,geneCor))

# Notice ONE CPU spiked.  Make note of how long it took to run.

# Let's make an even bigger dataset, making 26 x 4 = 104 columns.
fakeData <- cbind(geneData,geneData,geneData,geneData)
# Now lets make a more complex function that calculates the 
# 95% confidence intervals of the correlation coefficients
# through a process of bootstrapping:
library(boot)
geneCor2 <- function(x, gene = fakeData) 
{
  mydata <- cbind(gene[x[1], ], gene[x[2], ])
  mycor <- function(x, i) cor(x[i,1], x[i,2])
  boot.out <- boot(mydata, mycor, 1000)
  boot.ci(boot.out, type = "bca")$bca[4:5]
}

# Test how long 10 pairs would take:
genCor2_system_time <- system.time(outcor <- lapply(pair[1:10],geneCor2))
genCor2_system_time["elapsed"] # for 10 pairs.  So to figure out
# how long 124,750 pairs will take, let's multiply this by:
genCor2_system_time["elapsed"] *(124750/10)# seconds or
genCor2_system_time["elapsed"] *(124750/10/60/60) # hours
# to execute.  Ouch!  This is a good candidate for 
# parallel processing.

# Let's take a subsample of all the pairs for exploring this further:
pair2 <- sample(pair,300)

# Let's test a sequential version of this:
system.time(outcor <- lapply(pair2,geneCor2))

# Note the elapsed time.

### parallel: built-in parallel computation package.

# parallel's basic concept is to launch "worker" instances of R
#	on other processors, and then send the subproblems to each
#	R instance.  This means that if you want to use 4 processors
#	("cores"), after you start a parallel cluster, you will have 5
# 	copies of R running: the master copy (the one you are typing
#	into) and 4 worker copies.  

# The "cluster" of processors can be either a single computer
#	with multiple computers (like the one you are working on),
#	or a network of computers linked by some clustering framework.

# The basic order of ops with using 'parallel' is as follows:
#	1) library("parallel")
#   2) make a parallel cluster using makeCluster(...)
#	3) load packages that your function needs into the workers
#		  using clusterEvalQ(cl=...,library(...))
#	4) load objects (data) from the master environment into the worker
#		  environments using clusterExport(cl=...)
#	5) Following basic lapply() semantics, use e.g. clusterApplyLB(cl=...)
#		  to apply your function to an input list, where each iteration of the
#		  "loop" will be sent to an available processor.  The output
#	  	is usually a list.
#	6) Shut down your cluster using stopCluster(...)

library("parallel")

# We're also going to grab the "future" package:
install.packages("future")

library("future")

# The way parallel works, is we first have to make an R cluster via: 
?makeCluster
# We are going to create a cluster with 4 cpus of type "PSOCK".
# Click the task manager "Processes" (Windows) or Activity Monitor (mac), 
#	and scroll down to the "R"s:
myCluster <- makeCluster(spec=4,type="PSOCK")
# Notice you now have multiple instances of Rscript.exe running now.
myCluster
length(myCluster) # One entry per "worker".
myCluster[[1]]
# We can stop the cluster by:
?stopCluster
stopCluster(myCluster)

# Let's make a new cluster using all available cores.
mycorenum <- availableCores()


myCluster <- makeCluster(spec=mycorenum,type="PSOCK")
# We can send the same function to each node (worker) 
# in the cluster using 
?clusterCall
clusterCall(cl=myCluster,fun=date)
# These get returned as lists:
workerDates <- clusterCall(cl=myCluster,fun=date)
class(workerDates)
length(workerDates) # One per worker.

# You need to remember that each worker instance of R that is running
#  	is essentially "empty" -- it won't, be default, have access to
# 	the environment of the master.  Thus, we need to send some commands/data
# 	to them in anticipation of running the code.  

workerPackages <- clusterCall(cl=myCluster,fun=search)
workerPackages

# We are using a package called "boot" in our function, so we need
# to load up this package on every worker:
clusterEvalQ(cl=myCluster,library("boot"))

# We can confirm the boot package is now loaded:
clusterCall(cl=myCluster,fun=search)

# Next, we will export the dataset "fakeData" to each worker.
# First, look at the worker Rs and note how much memory they are using.
?clusterExport
clusterExport(cl=myCluster,"fakeData")
# Check the environment on each worker:
clusterEvalQ(cl=myCluster,ls())
# Check the memory now.  Note that each worker
#	is using more memory, since we loaded the fakeData
#	into each of those worker Rs.

# Note we could have sent the entire Global environment over to the workers.
clusterExport(cl=myCluster,ls())
clusterEvalQ(cl=myCluster,ls())

# Now comes the actual function call. 
?clusterApplyLB 
# This is VERY similar to an lapply statement, except we 
# 	identify the cluster to send the command to.
# Watch your Performance tab as your cores light up:
system.time(outcor2 <- clusterApplyLB(cl=myCluster,pair2,geneCor2))
# vs the non-clustered version:
system.time(outcor <- lapply(pair2,geneCor2))
# We got a big performance boost here!
# Don't forget to shut down your cluster:
stopCluster(myCluster)

### foreach: making parallel computing EVEN EASIER
# There are multiple parallel "backends" to R, including
# parallel, snow, multicore, Rmpi, to name a few.
# foreach is a meta-wrapper that works on many parallel
# backends. 
#
# What this means is you can write one set of code, and
# not have to mod it if the user prefers to use Rmpi
# instead of parallel (in which case the commands are very
# different).

# The basic order of ops with using foreach is as follows:
#	1) library("foreach")
#	2) Load a parallel backend and foreach registration package
#		e.g. library("doParallel")
#	3) Start a parallel backend with e.g. makeCluster(...)
#	4) Register the parallel backend with foreach, 
#		e.g.: registerDoParallel(...)
# 	5) Use foreach(...) %dopar% function() to run your function
#		in parallel.  
#	6) Use .packages parameter in foreach(...) to load needed packages.
#	7) Stop your cluster using e.g. stopCluster(...)
#	8) Register the sequential backend to foreach using registerDoSEQ()

install.packages("foreach")
library("foreach")
?foreach
# sequential mode:
registerDoSEQ() # Avoids warnings
system.time(
  outcor <- foreach(
    p = pair2, .packages="boot", 
    .combine="rbind") %dopar% 
    { 
      #       browser()
      return(geneCor2(p)) 
    }
)

# Use a parallel backend:
# Install the parallel backend to foreach:
install.packages("doParallel")
library("doParallel")
# Create a cluster using parallel:
myCluster <- makeCluster(spec=4,type="PSOCK")
# Register the backend with foreach:
registerDoParallel(myCluster)
# Run our code! Notice I didn't change the foreach call at all:
?foreach
system.time(
		outcor <- foreach(
						p = pair2, .packages="boot", 
						.combine="rbind") %dopar% 
				{ 
					#       browser()
					return(geneCor2(p)) 
				}
)
# Some things to notice: 
#	- we explicitly define what packages are to be sent over using the .packages parameter
#	- foreach calls have access to the master's global environment.
#	- we can use specific functions to join the data once its done (e.g. rbind)

# Don't forget to stop the cluster:
stopCluster(myCluster)

# You should also register the default, non-parallel backend for foreach
# 	otherwise the next time you use foreach it will not work.
registerDoSEQ()

### Sources of overhead
# Parallel computing, optimally, should be linear in terms of number of 
#	processors vs. time.  However, this is never the case.  A process
#	running on one core does not take twice the time as a process
#	running on two cores.  There are losses along the way from various
#	sources.  These need to be thought about when writing the most
#	efficient code.

# First, many programs will have parallel and non-parallel components.
#	If your non-parallel components take X amount of time, no matter
#	how many processors you have available, you will never run faster
#	than X amount of time.

# Chunking is one of the most important considerations.  So far, we've
#  been iterating one "row" at a time.  For faster computations, this
#  may not be very efficient, as the overhead of sending/receiving/
#  managing the parallel cluster swamps out gains from the processing.
#  We can get more clever with this by sending MULTIPLE rows at one
#  time to a worker.  This optimization of the chunk size (number of
#  rows to send at one time to a single worker) can dramatically speed
#  up your computation, at the cost of heavier RAM usage.  

# Shared-memory machines: a single computer like the one you are working
#	on is a "shared memory machine" -- each processor has access to the
#	same physical RAM.  When two processors "ask" for an R object in RAM
#	they must compete against each other.  One process will have to wait
#	until the other process are done reading that area of memory.  Memory
#	access, thus, can be a bottleneck.

# Networked systems of computers: a cluster computer ("supercomputer")
#	is really just a bunch of individual computers networked together.
#	Each individual computer ("node" in cluster terminology) has its own
#	set of processors, memory, and hard drive space.  When the master
#	R process does things like sends variables to the workers, it sends
#	this data through a network, which is a lot slower than sending it
#	within a single computer.  This transfer of data causes relatively
#	severe bottlenecks that can be ameliorated by faster networking or
#  more clever code.  For instance, you could copy the data the function
#  will work on to each node in a cluster, so the data does not have
#  to be transferred from the master R to the worker Rs.
#	Note that two nodes in a cluster do not share memory.

# 	Other things to worry about: RACE CONDITIONS. This comes in to play
#	  if your workers are all writing to the same output file (say,
#	  a raster file).  As we discussed before, in general only one
#	  "thread" (worker) can write to a file at a time, otherwise
#	  the file may get corrupt.  In parallel computing, we can increase
#	  the chance that this might happen if we aren't careful.  This
#	  often requires a programmer to be able to "lock" a file -- i.e.
#	  before a worker tries to write to a file, it 1) checks if the file
#	  is "locked", 2) if it finds it unlocked it first locks the file
#	  itself, 3) it opens/writes/close to the file, 4) it unlocks the
#	  file for other workers.

# Embarrassingly parallel applications and those that aren't: the term
#	"embarrassingly parallel" refers to problems that are absolutely
#	trivial to parallelize.  The function we've been looking at
#	is embarassingly parallel.  Each iteration takes (basically) the same
#	amount of time, uses the same amount of memory, doesn't require
#	cross-talk between workers, etc.  Raster processing, as we will see,
#	is often an embarrassingly parallel problem -- we process an image
#	one line at a time, sending each line to a different processor.
#	Vector based processing, on the other hand, is often not embarrassingly 
#	parallel, and takes a lot more thought to properly parallelize a function.

# Parallel computing takes a lot of practice and understanding of the
#	underlying systems to get good at.  Other issues start popping up
#	such as load balancing (what if the functions take non-constant
#	amounts of time on each processor), optimization of the chunk size,
#	and a host of other issues.

# Debugging can also be tricky, as the various parallel backends do not
#	typically allows workers to print to your main screen, so you have
#	to have them dump their outputs to a file that you then do a 
#	post-mortem on.  foreach makes this a bit easier, since you can test
#	a function on a single node (using registerDoSEQ()), debug it, and
#	once it works on one node, try it out on a cluster.