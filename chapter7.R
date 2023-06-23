#### Chapter 7: Tibbles with tibble ###########################################

library(tidyverse)

### Creating Tibbles ##########################################################

# Almost all of the functions in the tidyverse produce tibbles. Most other R
# packages use regular data frames. To coerce a data frame to a tibble:
as_tibble(iris)
