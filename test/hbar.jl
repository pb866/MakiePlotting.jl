## Init
# Create temp dir for test plots
isdir("plots") || mkdir("plots")
# Generate basic test figure
fig, ax = MakiePlotting.hbar_scene([1,2,3], ["A", "B", "C"])


## Helper functions

"""
    checkfigure(fig, ax)::Bool

Check `fig` is a Makie `Figure` and `ax` is a Makie `Axis`.
"""
function checkfigure(fig, ax)::Bool
  fig isa MakiePlotting.Figure && ax isa MakiePlotting.Axis
end


"""
    function_kwargs(fcn::Function, args...; kwargs...)::Bool

Check that function `fcn` runs without errors when all `args` and `kwargs` are passed.
Otherwise, warn of error type. Returns true, if no errors occur, otherwise false.
"""
function function_kwargs(fcn::Function, args...; kwargs...)::Bool
  try
    fcn(args...; kwargs...)
    return true
  catch error
    @warn "Error during call of figure" typeof(error)
    return false
  end
end


"""
    hbar_output(file::String, dir::String=".")::Bool

Check that plots are generated for the given `file` in the given directory `dir`.
Returns `true`, if plots are generated, otherwise `false`.
"""
function hbar_output(file::String, dir::String=".")::Bool
  MakiePlotting.hbar(file, [1,2,3], ["A", "B", "C"]; dir)
  file = joinpath(dir, file)
  plot_generated = isfile(file)
  rm(file, force=true)
  return plot_generated
end


## Tests
@testset "hbar scene" begin
  #* Test default plots
  @test checkfigure(fig, ax)
  @test isempty(ax.ylabel.val)
  #* Test figure is adjustable
  ax.ylabel = "y label";
  @test !isempty(ax.ylabel.val) && ax.ylabel.val == "y label"
  #* Test kwargs
  @test function_kwargs(hbar_scene,
    [1,2,3], ["A", "B", "C"], 5,
    size = (1200, 900),
    xlabel="x label",
    ylabel="y label",
    smallfont=16,
    largefont=22,
    colourscheme=:inferno,
    barcolours=:blue,
    colours_overbar=:yellow,
    colours_overbg=[:red, :orange, :green],
    colourscheme_start = 0.1,
    colourscheme_stop = 200,
    colourscheme_stepwidth = 0.1,
    brightness=0.7,
    axisposition=:bottom,
    showframe=true,
    formatfunction = x->string(x)*"%",
    flipthreshold=2,
    cycle=false
  )
end

@testset "hbar plot to file" begin
  #* Check output files
  @test hbar_output("test.pdf")
  @test hbar_output("plots/test.pdf")
  @test hbar_output("test.pdf", "plots")
  #* Check exception handling
  # Folder does not exist
  @test_throws SystemError hbar("foo/test.pdf", [1,2,3], ["A", "B", "C"])
  @test_throws SystemError hbar("test.pdf", [1,2,3], ["A", "B", "C"], dir="foo")
  # Wrong size of colour vectors
  @test_throws ErrorException hbar("test.pdf", [1,2,3], ["A", "B", "C"], barcolours=[:red, :green])
  #* Check kwargs
  @test function_kwargs(hbar,
    "test.pdf",
    [1,2,3], ["A", "B", "C"], 5,
    dir="plots",
    size = (1200, 900),
    xlabel="x label",
    ylabel="y label",
    smallfont=16,
    largefont=22,
    colourscheme=:inferno,
    barcolours=:blue,
    colours_overbar=:yellow,
    colours_overbg=[:red, :orange, :green],
    colourscheme_start = 0.1,
    colourscheme_stop = 200,
    colourscheme_stepwidth = 0.1,
    brightness=0.7,
    axisposition=:bottom,
    showframe=true,
    formatfunction = x->string(x)*"%",
    flipthreshold=2,
    cycle=false
  )
end

## Clean-up temp files
rm("plots", recursive=true, force=true)
