using MakiePlotting
using Test

@testset "Makie Plotting tests" begin

    @testset "Conversions" begin
        include("conversions.jl")
    end
    @testset "Colour Schemes" begin
        include("colourschemes.jl")
    end
    #=
    TODO
    @testset "Horizontal bar plots" begin
        # TODO check figure returns figure and axis handle
        # TODO check hbar creates image file (pdf, png, jpg), kwarg dir works
        include("hbar.jl")
    end
    =#
end
