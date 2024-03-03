"""
    function colours(
      datapoints::Int;
      scheme::Symbol=:inferno,
      fontcolour=(; :dark=>:midnightblue, :bright=>:antiquewhite2),
      start::Real=0,
      stop::Real=1,
      brightness::T where T<:AbstractFloat=0.6
    )

For the number of `datapoints`, pick colours from the given colour `scheme` and
choose a `fontcolour`. The `start` and `stop` index in the colours of the `scheme`
may be adapted. Alternatively, the `start` and `stop` percentage given as number
between `0` and `1` may be given. You may give a single colour in all valid Makie formats or
specify a dark and a light font colour as a NamedTuple with fields `:dark` and `:bright`
given in `fontcolour`. Font colours above a `brightness` value between `0` and `1`
(default: `0.6`) are bright, below dark.
"""
function colours(
  datapoints::Int;
  scheme::Symbol=:inferno,
  fontcolour=(; :dark=>:midnightblue, :bright=>(:white, 0.7)),
  start::Real=0,
  stop::Real=1,
  brightness::T where T<:AbstractFloat=0.6
)
  # Set colour scheme
  colourscheme = colorschemes[scheme]
  # Convert percentages to indices
  start < 1 && (start = max(1, round(Int, start *  length(colourscheme))))
  stop <= 1 && (stop = round(Int, stop *  length(colourscheme)))
  # Set range to pick colours from scheme
  stepwidth = round(Int, length(colourscheme[start:stop])/datapoints)
  colourrange = [i*stepwidth+start for i = 0:datapoints-1]
  # Get colours from scheme in given data range and set font colour above colour bars
  colourvector = [colourscheme[i] for i in colourrange]
  if fontcolour isa NamedTuple
    fontcolours =
    fontcolours =[ RGBbrightness(c) .< brightness ? fontcolour.bright : fontcolour.dark for c in colourvector]
  else
    fontcolours = [fontcolour for _ = 1:datapoints]
  end
  return colourvector, fontcolours
end

"""
    RGBbrightness(colour::ColorSchemes.ColorTypes.RGB{Float64})::Float64

Calculates a brightness value between `0` and `1` from the given RGB `colour`.
Brighter colours have values closer to 1, darker closer to 0.
"""
RGBbrightness(colour::ColorSchemes.ColorTypes.RGB{Float64})::Float64 = 0.299colour.r + 0.587colour.g + 0.114colour.b
