#### Preface ####

## Data Science Model ##

# First you must import your data. This typically means that you take
# data stored in a file, database, or web API, and load it into a 
# data frame in R. 

# Next, it's a good idea to tidy the data, which means storing it in a
# consistent form that matches the semantics of the dataset with the
# way it's stored. In short, when your data is tidy, each column is
# a variable and each row is an observation. 

# Once data is tidy, a common first step is to transform the data. 
# Transformation includes narrowing in on observations of interest,
# creating new variables that are functions of existing variables, 
# and calculating a set of summary statistics.

# Together, tidying and transforming are called wrangling.

# Once you have tidy data, there are two main engines of knowledge
# generation: visualization and modeling.

# A good visualization will show you things that you did not expect
# or raise new questions about the data. It may also hint that you're
# asking the wrong question, or need to collect different data. 

# Once you've made your questions sufficiently precise, you can use
# a model to answer them. Every model makes assumptions, and by its
# nature a model cannot question its own assumptions. That means that
# a model can't fundamentally surprise you. 

# The last step of a data science project is communication. It doesn't
# matter how well your models and visualizations have led you to 
# understand the data unless you can also communicate your results
# to others. 

# Data exploration is the art of looking at your data, rapidly 
# generating hypotheses, quickly testing them, then repeating again
# and again. The goal is to generate many promising leads that you 
# can later explore in more depth.

#### Chapter 1: Data Visualization with ggplot2 ####

# ggplot2 implements the grammar of graphics, a coherent system
# for describing and building graphs. 

# If we need to be explicit about where a function (or dataset) 
# comes from, we'll use the special form package::function()

## Creating a ggplot ##

# With ggplot2, you begin a plot with the function ggplot(), which
# creates a coordinate system that you can add layers to. The first
# argument of ggplot() is the data to use in the graph. So the 
# line ggplot(data=mpg) creates an empty graph. The function 
# geom_point() adds a layer of points to your plot, which creates
# a scatterplot. Each geom function in ggplot2 takes a mapping 
# argument, which defines how variables in your data are mapped
# to visual properties. The mapping argument is always paired with
# aes(), and the x and y arguments specify which variables to map 
# to the respective axes. 

ggplot(data=mpg) + 
  geom_point(mapping=aes(x=displ, y=hwy))

### Graphing Template ###

# ggplot(data=<DATA>) +
#   <GEOM_FUNCTION>(mapping=aes(<MAPPINGS))

## Exercises ##

# 1) Run ggplot(data=mpg). What do you see?

ggplot(data=mpg)

# A blank plot appears

# 2) How many rows are in mtcars? How many columns?

# To get the number of rows:
length(mtcars$mpg) # 32
 
# To get the number of columns:
length(colnames(mtcars)) # 11

# You can also convert the data.frame into a tibble,
# which gives you this information as nrow X ncol
as_tibble(mtcars)

# 3) What does the drv variable describe?

# It describes which wheels are powered in the vehicle.

# 4) Make a scatterplot of hwy versus cyl

ggplot(data=mpg, mapping=aes(x=hwy, y=cyl)) + 
  geom_point(color='blue')

# 5) What happens if you make a scatterplot of class versus
#    drv? Why is the plot not useful?

ggplot(data=mpg, mapping=aes(x=class, y=drv)) + 
  geom_point(color='blue')

# You get a grid-like plot (with overlapping points). The plot
# isn't useful because the classes are not ordinal.

### Aesthetic Mappings ###

# You can add a third variable, like class, to a two-dimensional
# scatterplot by mapping it to an aesthetic, which is a visual 
# property of the objects in your plot. They can include things
# like the size, shape, and color of your points. 

# You can convey information about your data by mapping the 
# aesthetics in your plot to the variables in your data.
ggplot(data=mpg) + 
  geom_point(mapping=aes(x=displ, y=hwy, color=class))

# You can also set the aesthetic properties of your geom manually.
# To set an aesthetic manually, set the property by name as an 
# argument of your geom function, outside of the aes() argument. 
ggplot(data=mpg) + 
  geom_point(mapping=aes(x=displ, y=hwy), color='blue')

# One common problem when creating ggplot2 graphics is to put
# the + in the wrong place: it has to be at the end of a line, 
# not the beginning.

## Exercises ##

# 1) What's gone wrong with this code? Why are the points not
#    blue?

ggplot(data=mpg) + 
  geom_point(
    mapping=aes(x=displ, y=hwy, color='blue')
  )

# When within the aes() arguments, color will map based on a
# a class variable. In this case, it is mapping everything to 
# a single class, 'blue'. If you want the points to be blue, 
# you have to add it as an argument outside of the aes()

ggplot(data=mpg) + 
  geom_point(
    mapping=aes(x=displ, y=hwy),
    color='blue'
  )

# 2) Which variables in mpg are categorical? Which variables
#    are continuous?

mpg

# Looking at the columns, we see that manufacturer, model, trans,
# drv, fl, and class are character types, implying heavily that
# they are categorical. 

# Furthermore, year and cyl can be treat as classes since you can
# classify cars based on these values (generally a small discrete 
# set of possible values). The only continuous columns are those 
# that are generally measured, such as displacement and mileage. 

# 3) Map a continuous variable to color, size, and shape. How
#    do these aesthetics behave differently for categorical versus
#    continuous variables?

ggplot(data=mpg) +
  geom_point(
    mapping=aes(x=displ, y=hwy, color=displ)
  )

# When using a continuous variable on color, it'll result with
# a gradient coloring scheme, likewise with size it will produce
# a discrete set of point sizes based on bins. Shape will not work
# however. 

# 4) What happens if you map the same variable to multiple 
#    aesthetics?

ggplot(data=mpg) +
  geom_point(
    mapping=aes(x=displ,
                y=hwy,
                color=drv,
                shape=drv,)
  )

# It coordinates the aesthetics together, so that a shape
# correlates with a color. 

# 5) What does the stroke aesthetic do? What shapes does it
#    work with?

# Stroke controls the size of the outline, and works on the 
# shapes that feature an outline

# 6) What happens if you map an aesthetic to something other 
#    than a variable name, like aes(color=displ < 5)?

ggplot(data=mpg) +
  geom_point(
    mapping=aes(x=displ, y=hwy, color=displ < 5)
  )

# It'll interpret the inputs as different classes, depending
# on what the inputs look like (in this case it treats the
# booleans as two separate classes)

### Facets ###

# Another way to add additional variables is to split your plot
# into facets, which are subplots that each display one subset
# of the data. 

# To facet your plot by a single variable, use facet_wrap(), the 
# first argument of which should be a formula, which you create
# with a ~ followed by a variable name (here "formula" is the 
# name of a data structure in R, not an "equation"). The variable
# that you pass to facet_wrap() should be discrete. 
ggplot(data=mpg) + 
  geom_point(mapping=aes(x=displ, y=hwy)) + 
  facet_wrap(~ class, nrow=2)

# To facet your plot on the combination of two variables, add 
# facet_grid() to your plot call. This time the formula should
# contain two variable names separated by a ~ where the left 
# variable will be the y-axis and the right variable will be
# the x-axis. 
ggplot(data=mpg) + 
  geom_point(mapping=aes(x=displ, y=hwy)) + 
  facet_grid(drv ~ cyl)

# If you prefer to not facet in the rows or columns dimension,
# use a '.' instead of a variable name.
ggplot(data=mpg) + 
  geom_point(mapping=aes(x=displ, y=hwy)) + 
  facet_grid(. ~ cyl)

## Exercises ##

# 1) What happens if you facet on a continuous variable?

ggplot(data=mpg) + 
  geom_point(mapping=aes(x=displ, y=hwy)) + 
  facet_wrap(~ cty, nrow=2)

# You get far too many resulting plots to make sense of anything,
# so the bins are not meaningful

# 2) What do the empty cells in a plot with facet_grid(drv ~ cyl)
#    mean? How do they relate to this plot?

ggplot(data=mpg) + 
  geom_point(mapping=aes(x=displ, y=hwy)) + 
  facet_wrap(drv ~ cyl)

ggplot(data=mpg) + 
  geom_point(mapping=aes(x=displ, y=hwy))

### Geometric Objects ###

# A geom is the geometrical object that a plot uses to represent
# data. To change the geom in your plot, change the geom function
# that you add to ggplot().

# scatter
ggplot(data=mpg) + 
  geom_point(mapping=aes(x=displ, y=hwy))

# plot
ggplot(data=mpg) + 
  geom_smooth(mapping=aes(x=displ, y=hwy))

# You can set the linetype of line in geom_smooth(), where it'll
# draw a different line for each unique value of the variable 
# that you map to linetype.
ggplot(data=mpg) + 
  geom_smooth(mapping=aes(x=displ, y=hwy, linetype=drv))

# Many geoms use a single geometric object to display multiple
# rows of data. For these geoms, you can set the group aesthetic
# to a categorical variable to draw multiple objects. It'll draw
# a separate object for each unique value of the grouping variable. 

# In practice, it'll automatically group the data for these geoms
# whenever you map an aesthetic to a discrete variable (as in 
# the use of linetype). It's convenient to rely on this feature
# because the group aesthetic by itself does not add a legend.

ggplot(data=mpg) + 
  geom_smooth(mapping=aes(x=displ, y=hwy))

ggplot(data=mpg) + 
  geom_smooth(mapping=aes(x=displ, y=hwy, group=drv))

ggplot(data=mpg) + 
  geom_smooth(
    mapping=aes(x=displ, y=hwy, color=drv),
    show.legend=FALSE
  )

# To display multiple geoms in the same plot, add multiple geom
# functions to ggplot():
ggplot(data=mpg) + 
  geom_point(mapping=aes(x=displ, y=hwy)) + 
  geom_smooth(mapping=aes(x=displ, y=hwy))

# To avoid duplication of code (and hence reduce the need to change
# things at multiple spots) you may pass a set of mappings, which
# will be treated as global mappings to each geom in the graph.
ggplot(data=mpg, mapping=aes(x=displ, y=hwy)) + 
  geom_point() + 
  geom_smooth()

# If you pass mappings in a geom function, they'll be treated as
# local mappings for the layer. It'll use these mappings to extend
# of overwrite the global mappings for that layer only. 
ggplot(data=mpg, mapping=aes(x=displ, y=hwy)) + 
  geom_point(mapping=aes(color=class)) + 
  geom_smooth()

# You can use the same idea to specify different data for each 
# layer. Here, our smooth line displays just a subset of the 
# mpg data. The local data argument in geom_smooth overwrites
# the global data argument. 

ggplot(data=mpg, mapping=aes(x=displ, y=hwy)) + 
  geom_point(mapping=aes(color=class)) +
  geom_smooth(
    data=filter(mpg, class=='subcompact'),
    se=FALSE
  )






















