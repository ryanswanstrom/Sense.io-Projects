#=
Setup
-----

Packages only need to be installed once per project. Installing packages can 
take a few moments.
=#

Pkg.add("RDatasets")

#=
Basic data manipulation
-----------------------

The RDatasets package provides some sample datasets and makes it easy to
import them into Julia as [DataFrames](http://dataframesjl.readthedocs.org/en/latest/).
=#
using RDatasets
mac = dataset("Zelig", "macro")
typeof(mac)

#=
We can extract and compute statistical summaries from individual columns, or 
get a statistical summary of the entire dataset.
=#
mean(mac[:Trade])
median(mac[:Trade])
describe(mac)

#=
Subsetting allows us to keep only rows that satisfy a criterion, and datasets 
provide many other sophisticated ways to split, modify and combine datasets.
=#
mac[mac[:Year] .> 1985, :]

#=
Plotting
--------

We can use the plotting package Gadfly to visualize the dataset.
=#
using Gadfly
plot(mac, x=:Year, y=:Unem, color=:Country, Geom.line)

## Create a histogram with bin count
plot(dataset("ggplot2", "diamonds"), x=:Price, color=:Cut,
     Geom.histogram(bincount=40))