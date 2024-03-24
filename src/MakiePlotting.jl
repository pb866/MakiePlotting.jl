module MakiePlotting

# Import packages
using Makie, CairoMakie
using ColorSchemes
# Include MakiePlotting modules
include("barplot.jl")
include("colourschemes.jl")
include("conversions.jl")

# Export functions
export hbar, figure
# TODO use public, when available in Julia v1.11
# public colours, RGBbrightness

end # module MakiePlotting
