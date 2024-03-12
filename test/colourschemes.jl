## Helper functions

"""
    get_colours(scheme::Symbol, fontcolours, datapoints::Int, start::Int, stop::Int, colourbrightness::Real)

Return colour vectors for bar and font colours using colours from the given `scheme`
and the specified `fontcolours`. Colours will be restricted to to the number of
`datapoints` and are chosen from the `scheme` between `start` and `stop` given either
as index or as percentage float, respectively. The `colourbrightness` as float between
`0` and `1` is used to separate dark from bright colours.
"""
function get_colours(scheme::Symbol, fontcolours, datapoints::Int, start::Int, stop::Int, colourbrightness::Real)
  # Define colour range
  stepwidth = (stop - start)/(datapoints - 1)
  range = round.(Int, start:stepwidth:stop)
  # Define colour palette and font colours
  palette = MakiePlotting.ColorSchemes.colourschemes[scheme].colors[range]
  fonts = if fontcolours isa NamedTuple
    # Distinguish between dark and bright colours based on brightness index
    font = Any[fontcolours.bright for _ in range]
    darkness = MakiePlotting.RGBbrightness.(palette)
    darkfonts = darkness .≥ colourbrightness
    font[darkfonts] .= [fontcolours.dark for _ = 1:length(count(darkfonts))]
    font
  else
    [fontcolours for _ in range]
  end
  # Return colour palette and vector of font colours
  return palette, fonts
end


## Colour definitions

# Colours
black = MakiePlotting.ColorSchemes.ColorTypes.RGB(0.,0.,0.)
white = MakiePlotting.ColorSchemes.ColorTypes.RGB(1.,1.,1.)
red = MakiePlotting.ColorSchemes.ColorTypes.RGB(1.,0.,0.)
green = MakiePlotting.ColorSchemes.ColorTypes.RGB(0.,1.,0.)
blue = MakiePlotting.ColorSchemes.ColorTypes.RGB(0.,0.,1.)
grey = MakiePlotting.ColorSchemes.ColorTypes.RGB(0.5,0.5,0.5)
lightblue = MakiePlotting.ColorSchemes.ColorTypes.RGB(0.,0.5,1.)
# Colour schemes
inferno = MakiePlotting.ColorSchemes.colourschemes[:inferno].colors
delta = MakiePlotting.ColorSchemes.colourschemes[:delta].colors
tab10 = MakiePlotting.ColorSchemes.colourschemes[:tab10].colors


## Tests
# Only basic tests, functionality is extensively tested in colourpicker tests
@testset "hbar colour palettes" begin
  @test MakiePlotting.colours() ==
    get_colours(:inferno, (; :bright=>(:white, 0.7), :dark=>:midnightblue), 256, 1, 256, 0.6)
  @test MakiePlotting.colours(1) == ([inferno[1]], [(:white, 0.7)])
  @test MakiePlotting.colours(256) ==
    get_colours(:inferno, (; :bright=>(:white, 0.7), :dark=>:midnightblue), 256, 1, 256, 0.6)
  @test MakiePlotting.colours(100, fontcolour=:yellow) ==
    get_colours(:inferno, :yellow, 100, 1, 256, 0.6)
  @test MakiePlotting.colours(15, scheme=:tab10, fontcolour=:black, start = 0.15, stop = 8) ==
    ([tab10[2:8]...; tab10[2:8]...; tab10[2]], [:black for _ = 1:15])
  @test_throws BoundsError MakiePlotting.colours(15, scheme=:tab10, fontcolour=:black, start = 0.15, stop = 8, cycle=false)
end

@testset "hbar font colours" begin
  @test MakiePlotting.colours(15, scheme=:delta, fontcolour=:blue) ==
    get_colours(:delta, :blue, 15, 1, 512, 0.6)
  @test MakiePlotting.colours(15, scheme=:delta, fontcolour= (; :bright=>:yellow, :dark=>(:navy, 0.5)), start = 0.1) ==
    get_colours(:delta, (; :bright=>:yellow, :dark=>(:navy, 0.5)), 15, 51, 512, 0.6)
  @test MakiePlotting.colours(15, scheme=:delta, brightness=0.3, start = 100) ==
    get_colours(:delta, (; :bright=>(:white, 0.7), :dark=>:midnightblue), 15, 100, 512, 0.3)
  @test MakiePlotting.colours(15, scheme=:delta, brightness=0., stop = 100) ==
    get_colours(:delta, (; :bright=>(:white, 0.7), :dark=>:midnightblue), 15, 1, 100, 0.)
  @test MakiePlotting.colours(15, scheme=:delta, brightness=1., start=200, stop=350) ==
    get_colours(:delta, (; :bright=>(:white, 0.7), :dark=>:midnightblue), 15, 200, 350, 1.)
end

@testset "colour picker" begin
  @test tab10 == MakiePlotting.colourpicker(tab10)
  @test tab10 == MakiePlotting.colourpicker(tab10, 10)
  @test tab10[1:1] == MakiePlotting.colourpicker(tab10, 1)
  @test tab10[[1;10]] == MakiePlotting.colourpicker(tab10, 2)
  @test [tab10...;tab10[1:2]] == MakiePlotting.colourpicker(tab10, 12)
  @test [tab10...;tab10...;tab10[1:3]] == MakiePlotting.colourpicker(tab10, 23)
  @test inferno[round.(Int, collect(1:255/13:256))] == MakiePlotting.colourpicker(inferno, 14)
  @test inferno[1:17:256] == MakiePlotting.colourpicker(inferno, 16)
  @test inferno[round.(Int, collect(1:255/16:256))] == MakiePlotting.colourpicker(inferno, 17)
  @test inferno[round.(Int, collect(32:224/15:256))] == MakiePlotting.colourpicker(inferno, 16, start = 0.125)
  @test inferno[round.(Int, collect(100:156/15:256))] == MakiePlotting.colourpicker(inferno, 16, start = 100)
  @test inferno[round.(Int, collect(1:31/15:32))] == MakiePlotting.colourpicker(inferno, 16, stop = 0.125)
  @test inferno[round.(Int, collect(1:99/15:100))] == MakiePlotting.colourpicker(inferno, 16, stop = 100)
  @test tab10[round.(Int, collect(1:7/3:8))] == MakiePlotting.colourpicker(tab10, 4, start = 0.1, stop = 8)
  @test tab10[[3:8; 3:5]]== MakiePlotting.colourpicker(tab10, 9, start = 3, stop = 8)
  @test_throws BoundsError MakiePlotting.colourpicker(tab10, 12, cycle=false)
end

@testset "RGB brightness" begin
  @test 1.0 ≈ MakiePlotting.RGBbrightness(white)
  @test 0.0 ≈ MakiePlotting.RGBbrightness(black)
  @test 0.299 ≈ MakiePlotting.RGBbrightness(red)
  @test 0.587 ≈ MakiePlotting.RGBbrightness(green)
  @test 0.114 ≈ MakiePlotting.RGBbrightness(blue)
  @test 0.5 ≈ MakiePlotting.RGBbrightness(grey)
  @test 0.4075 ≈ MakiePlotting.RGBbrightness(lightblue)
end

# Test vector for bounds test
vector = collect(1:10)
@testset "set colour vector bounds" begin
  # Integer indices
  @test (1, 10) == MakiePlotting.setbounds(vector, -Inf, Inf)
  @test (1, 10) == MakiePlotting.setbounds(vector, 1, 10)
  @test (3, 10) == MakiePlotting.setbounds(vector, 3, Inf)
  @test (1, 8) == MakiePlotting.setbounds(vector, -Inf, 8)
  @test (3, 4) == MakiePlotting.setbounds(vector, 3, 4)
  @test (3, 3) == MakiePlotting.setbounds(vector, 3, 3)
  # Float indices
  @test (3, 10) == MakiePlotting.setbounds(vector, .25, Inf)
  @test (1, 8) == MakiePlotting.setbounds(vector, -Inf, .8)
  @test (3, 4) == MakiePlotting.setbounds(vector, .3499, .35)
  # Mixed indices
  @test (2, 7) == MakiePlotting.setbounds(vector, 2, 0.7)
  @test (3, 9) == MakiePlotting.setbounds(vector, 0.25, 9)
  # Bounds errors
  @test_throws BoundsError MakiePlotting.setbounds(vector, 0, 8)
  @test_throws BoundsError MakiePlotting.setbounds(vector, 3, 11)
  @test_throws BoundsError MakiePlotting.setbounds(vector, -Inf, 12)
  @test_throws BoundsError MakiePlotting.setbounds(vector, 0, Inf)
  @test_throws BoundsError MakiePlotting.setbounds(vector, -Inf, 1.2)
  @test_throws BoundsError MakiePlotting.setbounds(vector, -0.3, Inf)
  @test_throws BoundsError MakiePlotting.setbounds(vector, 0, 0.8)
  @test_throws BoundsError MakiePlotting.setbounds(vector, 1, 1.1)
  @test_throws BoundsError MakiePlotting.setbounds(vector, 0.8, 1.1)
  @test_throws BoundsError MakiePlotting.setbounds(vector, -0.2, 0.1)
end
