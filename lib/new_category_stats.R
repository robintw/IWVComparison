get_stats <- function(df, ind, mlist, col)
{
  print("In GetStats")
  print(col)
  if (length(ind) == 0)
  {
    res <- list(rmse = NA,
                err_mean = NA,
                err_sd = NA,
                perc_err_mean = NA,
                perc_err_sd = NA,
                m = NA,
                R2 = NA,
                n = NA)
    
    return(res)
  }
  print(ind)
  ids <- df[ind,]$bigf
  ids <- as.vector(sapply(ids, toupper))
  
  print(str(ids))
  
  items <- mlist[ids]
  
  newitems <- lapply(items, as.data.frame)
  res <- do.call(rbind, newitems)
  
  results = c(subset_stats(res, col, "iwv"))
  
  return(results)
}

make_into_factors <- function(col, l)
{
  col <- factor(unlist(col), labels=names(l))
  
  return(col)
}



calculate_category_stats_aeronet <- function(mlist)
{  
  # Calculate indices for each of the selection criteria
  sets = list(All     = 1:nrow(ClassifiedValAERONET),
              UK      = which(ClassifiedValAERONET$UK == 1),
              Europe  = which(ClassifiedValAERONET$Europe == 1),
              Global  = which(ClassifiedValAERONET$Global == 1))
  
  cat_excluded = list(None =  1:nrow(ClassifiedValAERONET),
                      Any  =  which(ClassifiedValAERONET$Category1_SmallIsland == 0 &
                                      ClassifiedValAERONET$Category2_SeparatedLandMass == 0 &
                                      ClassifiedValAERONET$Category3_SmallIsland_LargeOceanMass == 0 &
                                      ClassifiedValAERONET$Category4_SeparatedLargerIsland == 0 &
                                      ClassifiedValAERONET$Category5_FewSamples == 0),
                      SmallAndFew = which(ClassifiedValAERONET$Category1_SmallIsland == 0 &
                                            ClassifiedValAERONET$Category3_SmallIsland_LargeOceanMass == 0 &
                                            ClassifiedValAERONET$Category5_FewSamples == 0))
  
  
  results = list()
  listind = 1
  # Intersect the required indices and then calculate statistics
  for (i in 1:length(sets))
  {
    for (j in 1:length(cat_excluded))
    {
      ind = intersect(unlist(sets[i]), unlist(cat_excluded[j]))
      ind <- unlist(ind)
      
      res <- get_stats(ClassifiedValAERONET, ind, mlist, 'PWC')
      
      res <- c(set = i,
               cat_excl = j,
               res)
      
      results[[listind]] <- res
      listind = listind + 1
      
    }
  }
  
  r <- do.call('rbind', results)
  r <- as.data.frame(as.matrix(r))
  
  r <- as.data.frame(sapply(r, as.numeric))

  r$set <- make_into_factors(r$set, sets)
  r$cat_excl <- make_into_factors(r$cat_excl, cat_excluded)
  
  return(r)
}


calculate_category_stats_radiosonde <- function(mlist)
{
  
  # Calculate indices for each of the selection criteria
  sets = list(All     = 1:nrow(ClassifiedValRadiosonde),
              UK      = which(ClassifiedValRadiosonde$UK == 1),
              Europe  = which(ClassifiedValRadiosonde$Europe == 1),
              Global  = which(ClassifiedValRadiosonde$Global == 1))
  
  cat_excluded = list(None =  1:nrow(ClassifiedValRadiosonde),
                      Any  =  which(ClassifiedValRadiosonde$Category1_SmallIsland == 0 &
                                      ClassifiedValRadiosonde$Category2_SeparatedLandMass == 0 &
                                      ClassifiedValRadiosonde$Category3_SmallIsland_LargeOceanMass == 0 &
                                      ClassifiedValRadiosonde$Category4_SeparatedLargerIsland == 0 &
                                      ClassifiedValRadiosonde$Category5_FewSamples == 0),
                      SmallAndFew = which(ClassifiedValRadiosonde$Category1_SmallIsland == 0 &
                                            ClassifiedValRadiosonde$Category3_SmallIsland_LargeOceanMass == 0 &
                                            ClassifiedValRadiosonde$Category5_FewSamples == 0))
  
  radiosonde_types = list(Any = 1:nrow(ClassifiedValRadiosonde),
                          RS92 = which(ClassifiedValRadiosonde$rtype == 79 |
                                       ClassifiedValRadiosonde$rtype == 80 |
                                       ClassifiedValRadiosonde$rtype == 81),
                          OthersNoRS80 = which(ClassifiedValRadiosonde$rtype != 79 &
                                               ClassifiedValRadiosonde$rtype != 80 &
                                               ClassifiedValRadiosonde$rtype != 81 &
                                               ClassifiedValRadiosonde$rtype != 52))
  
  results = list()
  listind = 1
  # Intersect the required indices and then calculate statistics
  for (i in 1:length(sets))
  {
    for (j in 1:length(cat_excluded))
    {
      for (k in 1:length(radiosonde_types))
      {
        ind <- intersect(unlist(sets[i]), unlist(cat_excluded[j]))
        ind <- intersect(ind, unlist(radiosonde_types[k]))
        ind <- unlist(ind)
        
        res <- get_stats(ClassifiedValRadiosonde, ind, mlist, 'pwc')
        
        res <- c(set = i,
                 cat_excl = j,
                 radiosonde_types = k,
                 res)
        
        results[[listind]] <- res
        listind = listind + 1
      }
    }
  }
  
  r <- do.call('rbind', results)
  r <- as.data.frame(as.matrix(r))
  
  r <- as.data.frame(sapply(r, as.numeric))
  
  
  r$set <- make_into_factors(r$set, sets)
  r$cat_excl <- make_into_factors(r$cat_excl, cat_excluded)
  r$radiosonde_types <- make_into_factors(r$radiosonde_types, radiosonde_types)
  
  return(r)
}

get_stats_ar <- function(df, ind, mlist, col)
{
  print("In GetStats")
  print(col)
  if (length(ind) == 0)
  {
    res <- list(rmse = NA,
                err_mean = NA,
                err_sd = NA,
                perc_err_mean = NA,
                perc_err_sd = NA,
                m = NA,
                R2 = NA,
                n = NA)
    
    return(res)
  }
  print(ind)
  ids <- df[ind,]$radiosonde
  ids <- as.vector(sapply(ids, toupper))
  
  print(str(ids))
  
  items <- mlist[ids]
  
  newitems <- lapply(items, as.data.frame)
  res <- do.call(rbind, newitems)
  
  results = c(subset_stats(res, col, "pwc"))
  
  return(results)
}

calculate_category_stats_ar <- function(mlist)
{  
  # Calculate indices for each of the selection criteria
  sets = list(All     = 1:nrow(ClassifiedValAR),
              UK      = which(ClassifiedValAR$UK == 1),
              Europe  = which(ClassifiedValAR$Europe == 1),
              Global  = which(ClassifiedValAR$Global == 1))
  
  cat_excluded = list(None =  1:nrow(ClassifiedValAR),
                      Any  =  which(ClassifiedValAR$Category3_SmallIsland_LargeOceanMass == 0 &
                                      ClassifiedValAR$Category4_SeparatedLargerIsland == 0 &
                                      ClassifiedValAR$Category5_FewSamples == 0),
                      SmallAndFew = which(ClassifiedValAR$Category3_SmallIsland_LargeOceanMass == 0 &
                                            ClassifiedValAR$Category5_FewSamples == 0))
  
  
  results = list()
  listind = 1
  # Intersect the required indices and then calculate statistics
  for (i in 1:length(sets))
  {
    for (j in 1:length(cat_excluded))
    {
      ind = intersect(unlist(sets[i]), unlist(cat_excluded[j]))
      ind <- unlist(ind)
      
      res <- get_stats_ar(ClassifiedValAR, ind, mlist, 'PWC')
      
      res <- c(set = i,
               cat_excl = j,
               res)
      
      results[[listind]] <- res
      listind = listind + 1
      
    }
  }
  
  r <- do.call('rbind', results)
  r <- as.data.frame(as.matrix(r))
  
  r <- as.data.frame(sapply(r, as.numeric))
  
  r$set <- make_into_factors(r$set, sets)
  r$cat_excl <- make_into_factors(r$cat_excl, cat_excluded)
  
  return(r)
}