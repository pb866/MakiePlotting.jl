module MakiePlotting

# Import packages
using Makie, CairoMakie
using ColorSchemes
# Include MakiePlotting modules
include("constants.jl")
include("barplot.jl")
include("colourschemes.jl")
include("conversions.jl")

# Export functions
export hbar, hbar_scene
# TODO use public, when available in Julia v1.11
# public colours, RGBbrightness, commasep

end # module MakiePlotting
