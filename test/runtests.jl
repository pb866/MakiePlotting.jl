using MakiePlotting
using Test

# TODO add Docs.undocumented_names(module) test, when v1.11 is available

@testset "Makie Plotting tests" begin

    @testset "Conversions" begin
        include("conversions.jl")
    end
    @testset "Colour Schemes" begin
        include("colourschemes.jl")
    end
    @testset "Horizontal bar plots" begin
        include("hbar.jl")
    end
end
