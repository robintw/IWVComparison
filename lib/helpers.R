add_bold <- function(c) {
  return(paste("\\textbf{", c, "}", sep=""))
}

myxtable <- function(t)
{
  x <- xtable(t, digits=3)
  #digits(x) <- 3
  display(x) <- rep("fg", ncol(x)+1)
  
  print(x, include.rownames=FALSE, table.placement=NULL, latex.environments=NULL, size="\\centering", booktabs=TRUE, sanitize.colnames.function=add_bold)
}

stats <- function(data)
{
  print(paste(min(data, na.rm=T), mean(data, na.rm=T), max(data, na.rm=T), sd(data, na.rm=T), sep=" & "))
}
