# MakiePlotting.jl

Providing simple plotting interfaces using [Makie.jl](https://docs.makie.org/stable/) for standardised 
high quality pictures.

# Overview

MakiePlotting.jl provides simple methods to produce appealing plots with simple interfaces.
Plotting functions include only limited arguments and keyword arguments to produce plots.
On the other hand, all output may be further adjusted for more advanced user needs.

MakiePlotting.jl provides plotting methods on a need to have basis. Features may be 
requested and pull requests are welcome to extend MakiePlotting.jl to further plot types.

Currently, the following plot types are supported.

- horizontal bar plots

This documentation gives a detailed overview of all plotting functions for users 
and some insides for developers how to adopt the package and adjust it to other needs.

# Contents

```@contents
Pages = [
  "index.md",
  "code_index.md"
]
```

# Installation

MakiePlotting.jl is an unregistered package, but can still be installed with the package
manager. To add MakiePlotting.jl at the url of the GitHub repository in the package
manager.

```julia
julia> ]
pkg> add https://github.com/pb866/MakiePlotting.jl.git
pkg> ⇤ (backspace)
julia> using MakiePlotting
```
