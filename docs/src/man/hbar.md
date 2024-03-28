# Horizontal bar plots

## Overview

MakiePlotting includes two exported functions to generate horizontal bar plots —
[hbar](@ref) and [hbar_scene](@ref). The difference is that [hbar_scene](@ref) 
returns a `Makie.Figure` and `Makie.Axis` handle that can be further processed 
for more advanced plots.

The [hbar](@ref) function is more convenient and directly saves plots to a file.
However, it is not possible to alter plots other than with the given keyword 
arguments. In the following, modifying plots with the given keyword arguments is 
explained in detail.


## Data arguments

For standard plots, both functions need only 2 data arrays, a `Vector{<:Real}` 
with the values of the bars to be plotted and a `Vector{<:AbstractString}` with 
`labels` assigned to each data point in the vector for `datasets`. In addition,
[hbar](@ref) needs the `file` name given as `AbstractString`


## Public plotting functions

```@docs
hbar
hbar_scene
MakiePlotting.colours
MakiePlotting.RGBbrightness
MakiePlotting.commasep
```
