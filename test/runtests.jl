using MakiePlotting
using Test

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
