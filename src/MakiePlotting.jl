module MakiePlotting

# Import packages
using Makie #, CairoMakie, Format
using ColorSchemes
# Include MakiePlotting modules
include("barplot.jl")
include("colourschemes.jl")
include("conversions.jl")

# Export functions
export hbar, figure
# TODO use public, when available in Julia v1.11
# public colours, brightness

end # module MakiePlotting
