## Data Tables
# Display your matrices or data.tables in sorting
# and filtering format
install.packages('DT')
library('DT')
datatable(iris, options = list(pageLength = 7))

## Time-series Line Graph
install.packages('dygraphs')
library('dygraphs')
dygraph(nhtemp, main = "New Haven Temperatures") %>% 
  dyRangeSelector(dateWindow = c("1926-01-01", "1970-01-01"))

## Scatterplot
devtools::install_github('hrbrmstr/metricsgraphics')
library('metricsgraphics')
mjs_plot(mtcars, x=wt, y=mpg) %>%
  mjs_point(color_accessor=carb, size_accessor=carb) %>%
  mjs_labs(x="Weight of Car", y="Miles per Gallon")

## Network Graph
install.packages('networkD3')
library('networkD3')
data(MisLinks, MisNodes)
forceNetwork(Links = MisLinks, Nodes = MisNodes, Source = "source",
             Target = "target", Value = "value", NodeID = "name",
             Group = "group", opacity = 0.4)

## ThreeJS
install.packages('threejs')
library('threejs')
z <- seq(-10, 10, 0.01)
x <- cos(z*4)
y <- sin(z*4)
scatterplot3js(x,y,z, color=rainbow(length(z)))

## Diagrams and Flowcharts
install.packages('DiagrammeR')
library('DiagrammeR')

grViz("
  digraph {
    layout = twopi
    node [shape = circle]
    A -> {B C D} 
  }")
      