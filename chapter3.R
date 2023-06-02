#### Chapter 3: Data Transformation with dplyr ####

### Setup ###

# Visualization is an important tool for insight generation, but it's
# rare that you'll get the data in exactly the right form you need. Often,
# you'll need to create some new variables or summaries, or you'll just
# want to rename the variables or reorder the observations. This can all
# be done via dplyr

library(nycflights13)
library(tidyverse)

# Take note that there are conflict messages when you load dplyr/tidyverse.
# It tells you that dplyr overwrites some functions in base R. If you want 
# to use the base versions of these functions, you'll need to use their 
# full names: stats::filter() and stats::lag()

# To explore the basic data manipulation of dplyr, we'll use the following
# data set:
nycflights13::flights

# To see the whole dataset, you can run View(flights), which will open
# the dataset in the RStudio viewer. 
View(flights)

# The above prints differently because it's a tibble, which are data frames
# but slightly tweaked to work better in the tidyverse. You may have also 
# noticed the row of <letters> under the column names. These describe the 
# type of each variable:

# int: integers
# dbl: doubles, or real numbers
# chr: character vectors, or strings
# dttm: date-times
# lgl: logical vectors, or booleans
# fctr: factors, which R uses to represent categorical variables
# date: dates, no time

# There are five key dplyr functions that solve the vast majority
# of your data-manipulation challenges:

# Pick observations by their values: filter()
# Reorder the rows: arrange()
# Pick variables by their names: select()
# Create new variables with functions of existing variables: mutate()
# Collapse many values down to a single summary: summarize()

# These can be used in conjunction with group_by(), which changes the 
# scope of each function from operating on the entire dataset to 
# operating on it group-by-group

# All functions work similarly:

# 1) The first argument is a dataframe (or tibble)
# 2) The subsequent arguments describe what to do with the dataframe,
#    using the variable names (without quotes)
# 3) The result is a new dataframe (or tibble)

### Filtering Rows ###

# filter() allows you to subset observations based on their values. 
# The first argument is the name of the dataframe. The second and
# later arguments are the expressions that filter the dataframe.

# Select all flights on January 1st
filter(flights, month == 1, day == 1)

# Note that dplyr functions never modify their inputs, so if you 
# want to save the result you'll need to use the assignment operator

# When using logical operators, remember that computers use finite
# precision arithmetic, so use near() for comparisons with floats
1/49 * 49 == 1
near(1/49 * 49, 1)

# The following code finds all flights that departed in November
# or December:
filter(flights, month == 11 | month == 12)

# A useful shorthand for this problem is x %in% y. This will select
# every row where x is one of the values in y:
filter(flights, month %in% c(11, 12))

# Sometimes you can simplify complicated subsetting by remembering 
# De Morgan's law: !(A&B) = !A|!B and !(A|B) = !A&!B. If you wanted
# to find flights that weren't delayed by more than two hours:
filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)

# NA represents an unknown value (not available). If you want to 
# determine if a value is missing, use is.na()
x <- NA
is.na(x)

# Note that filter() only includes rows where the condition is True,
# it excludes both FALSE and NA values. If you want to preserve the 
# NA values, you have to explicitly ask for them:
df <- tibble(x=c(1, NA, 3))

filter(df, x > 1)

filter(df, is.na(x) | x > 1)

### Arranging Rows ###

# arrange() changes the order of the rows. It takes a dataframe and
# a set of column names to order by. If you provide more than one
# column name, each additional column will be used to break ties
arrange(flights, year, month, day)

# Use desc() to reorder by a column in descending order:
arrange(flights, desc(arr_delay))

# Missing values are always sorted at the end:
df <- tibble(x=c(5, 2, NA))
arrange(df, x)
arrange(df, desc(x))

### Selecting Columns ###

# select() allows you to zoom in on a useful subset of columns based
# on their names

# Select columns by name:
select(flights, year, month, day)

# Select all columns between year and day (inclusive)
select(flights, year:day)

# Select all columns except those from year to day (inclusive)
select(flights, -(year:day))

# There are a number of helper functions you can use within:

#     starts_with('string'): matches names that begin with 'string'
#     ends_with('string'): matches names that end with 'string'
#     contains('string'): matches names that contain 'string'
#     matches('string'): selects columns that match a regular expression
#     num_range('string', 1:3): matches string1, string2, and string3

# select() can be used to rename variables but it's not useful since it
# drops any columns not mentioned. Instead, use rename(df, new_name=old_name)
rename(flights, tail_num=tailnum)

### Mutating Data ###

# It's often useful to add new columns that are functions of existing
# columns, which can be done with mutate()

# Note that mutate() always adds new columns at the end of your dataset,
# so we'll start by creating a narrower dataset. 

flights_sml <- select(flights,
                      year:day,
                      ends_with('delay'),
                      distance,
                      air_time)

mutate(flights_sml,
       gain = arr_delay - dep_delay,
       speed = distance / air_time * 60)

# Note that you can refer to columns that you're just created:
mutate(flights_sml,
       gain = arr_delay - dep_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours)

# If you only want to keep the new variables, use transmute()

transmute(flights,
          gain = arr_delay - dep_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours)

# There are many useful creation functions:
transmute(flights,
          air_time_hours = air_time / 60,            # arithmetic
          air_time_diff = air_time - mean(air_time), # aggregates
          hour = dep_time %/% 100,                   # integer division
          minute = dep_time %% 100)                  # modulo

# 



