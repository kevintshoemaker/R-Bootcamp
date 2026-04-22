
# exclude_strings=c("fold-hide","solution")
# include_strings= c("answer","test","solution")
rmd2R <- function(file="mod_test.Rmd", exclude_first=TRUE, 
                                   include_strings = NULL, exclude_strings=NULL){    # function for converting markdown to scripts
  outfile <- gsub(".Rmd",".R",file)
  close( file( outfile, open="w" ) )   # clear output file
  con1 <- file(file,open="r")
  con2 <- file(outfile,"w")
  string1_iscodeblock <- "```{r*"
  
  isrblock <- FALSE
  #count=0
  blocknum=0
  
  while(length(input <- readLines(con1, n=1)) > 0){   # while there are still lines to be read
    isrblock <- grepl(input, pattern = string1_iscodeblock, perl = TRUE)   # is it the start of an R block?
    
    showit <- ifelse(is.null(include_strings),T,
              any(sapply(include_strings,function(t) grepl(input, pattern = t, perl = TRUE) ))) 
    hideit <- ifelse(is.null(exclude_strings),F,
                     any(sapply(exclude_strings,function(t) grepl(input, pattern = t, perl = TRUE) ))) 
    firstblock = ifelse(exclude_first,1,0)
    if(isrblock){
      blocknum=blocknum+1
      while(!grepl(newline<-readLines(con1, n=1),pattern="```",perl=TRUE)){
        if((blocknum>firstblock)&showit&!hideit) write(newline,file=con2,append=TRUE)
      }
      isrblock=FALSE
    }
  }
  closeAllConnections()
}
rmd2R("mod_test.Rmd",exclude_first=T,exclude_strings=c("fold-hide"))


