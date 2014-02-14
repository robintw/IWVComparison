# Call with a classified data frame (eg. ClassifiedValAERONET)
# and a string for the column used as a category (eg. 'global')
get_category_df <- function(df, var, mlist)
{
  ids <- df[df[var] == 1,]$bigf
  
  # Make sure all of the BIGF IDs are uppercase
  ids <- as.vector(sapply(ids, toupper))
  
  items <- mlist[ids]
  
  newitems <- lapply(items, as.data.frame)
  res <- do.call(rbind, newitems)
  
  return(res)
}

process_category <- function(column, classdf, mlist, valcol)
{
  res <- get_category_df(classdf, column, mlist)
  return (get_overall_stats(res, valcol, column))
}

process_all_categories <- function(classdf, valcol, mlist)
{
  cols <- c('Category1_SmallIsland',
            'Category2_SeparatedLandMass', 
            'Category3_SmallIsland_LargeOceanMass',
            'Category4_SeparatedLargerIsland',
            'Category5_FewSamples',
            'UK',
            'Europe',
            'Global',
            'All')
  
  res <- lapply(cols, process_category, classdf=classdf, valcol=valcol, mlist=mlist)
  newdf <- do.call(rbind, lapply(res, data.frame))
  return(newdf)
}