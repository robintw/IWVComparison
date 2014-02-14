# Split mlist.aeronet into post 2007
mlist.radiosonde.post2007 <- lapply(mlist.radiosonde, get_post_2007)

r.post2007 <- calculate_category_stats_radiosonde(mlist.radiosonde.post2007)
r.all <- calculate_category_stats_radiosonde(mlist.radiosonde)

dateranges <- list(All = 1, Post2007 = 2)
r.all$daterange <- 1
r.post2007$daterange <- 2

r <- rbind(r.all, r.post2007)
r$daterange <- factor(r$daterange, labels=c('All', 'Post2007'))

subset.stats.radiosonde <- r