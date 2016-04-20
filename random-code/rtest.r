# A function to create the exact variance
# this function will not work for files that don't
# fit in memory.
# This function was only for testing with small datasets
#
# file - name of a pipe-delimited file with 3 columns
calcVar_Swanstrom1 <- function(file) {
  # read in the file
  data <- read.csv(file,sep='|')
  mn = mean(data$Amount)
  sq = (data$Amount - mn)^2
  return(sum(sq)/length(sq))
}


# A function to calculate the variance
# of the 3rd column of a | delimited file.
# It calculates the exact variance, not the sample variance.
# 
# This function uses the Welford method as described
# by Knuth in the Art of Programming.
# See vol. 2 of the books or John D. Cook's blog post
# on the topic.
# http://www.johndcook.com/blog/standard_deviation/
# 
# Usage:
#    calcVar_Swanstrom('yourdatafile.txt')
#
# file - name of a pipe-delimited file with 3 columns
# Returns a number indicating the variance
calcVar_Swanstrom <- function(file) {
  
  # read in the file
  conn=file(file,open="r")
  
  # read the header row
  readLines(conn, n=1)
  
  # the kth number being read in
  k = 1
  # mean of the first k numbers
  # it gets initialized to the first value
  mk = as.numeric(unlist(strsplit(readLines(conn, n=1),'[|]'))[3])
  # running calculation for variance
  vk = 0
  line = readLines(conn, n=1)
  while (length(line) >0){
    # split the string on | and select the 3rd column
    # set an a number
    ln = unlist(strsplit(line,'[|]'))
    amt = as.numeric(ln[3])
    k = k+1
    mkprev = mk
    mk = mk + (amt - mk)/k
    vk = vk + (amt-mkprev)*(amt-mk)
    line = readLines(conn, n=1)
  }
  close(conn)
  return(vk/(k))
}

calcVar_Swanstrom1('data.csv')
calcVar_Swanstrom('data.csv')

