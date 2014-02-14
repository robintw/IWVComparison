get_pre_2007 <- function(l) { return(l[year(index(l)) < 2007])}
get_post_2007 <- function(l) { return(l[year(index(l)) >= 2007])}
