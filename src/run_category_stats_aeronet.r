# Split mlist.aeronet into post 2007
mlist.aeronet.post2007 <- lapply(mlist.aeronet, get_post_2007)

r.post2007 <- calculate_category_stats_aeronet(mlist.aeronet.post2007)
r.all <- calculate_category_stats_aeronet(mlist.aeronet)

dateranges <- list(All = 1, Post2007 = 2)
r.all$daterange <- 1
r.post2007$daterange <- 2

r <- rbind(r.all, r.post2007)
r$daterange <- factor(r$daterange, labels=c('All', 'Post2007'))

subset.stats.aeronet <- r