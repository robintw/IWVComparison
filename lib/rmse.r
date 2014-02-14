rmse <- function(error)
{
  sqrt(mean(error * error))
}