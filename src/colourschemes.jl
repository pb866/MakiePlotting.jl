"""
    colours(
      datapoints::Int=0;
      scheme::Symbol=:inferno,
      fontcolour=(; :dark=>:midnightblue, :bright=>(:white, 0.7)),
      start::Union{<:AbstractFloat,Int} = -Inf,
      stop::Union{<:AbstractFloat,Int} = Inf,
      cycle::Bool=true,
      brightness::T where T<:AbstractFloat=0.6
    )

For the number of `datapoints`, pick colours from the given colour `scheme` and
choose a `fontcolour`. The `start` and `stop` index in the colours of the `scheme`
may be adapted. Alternatively, the `start` and `stop` percentage given as float
between `0` and `1` may be given. You may give a single colour in all valid Makie formats or
specify a dark and a light font colour as a NamedTuple with fields `:dark` and `:bright`
given in `fontcolour` for font colours over bars. Font colours above a `brightness` value
between `0` and `1` (default: `0.6`) are bright, below dark.
By default, the scheme cycles through colours and starts from the beginning, if more colours
are needed than available in the scheme. This behaviour can be switched off, by setting
`cycle` to `false` in which case a `BoundsError` is thrown.
"""
function colours(
  datapoints::Int=0;
  scheme::Symbol=:inferno,
  fontcolour=(; :dark=>:midnightblue, :bright=>(:white, 0.7)),
  start::Union{<:AbstractFloat,Int} = -Inf,
  stop::Union{<:AbstractFloat,Int} = Inf,
  cycle::Bool=true,
  brightness::T where T<:AbstractFloat=0.6
)

  # Set colour scheme
  colourscheme = colorschemes[scheme].colors
  # Get colour vector for selected data points
  colourvector = colourpicker(colourscheme, datapoints; cycle, start, stop)
  # Define over-bar font colour based on user choice and bar colour brightness
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

# TODO integrate into colours, figure, and hbar
# TODO tests
# TODO colour picking based on brightness, or fixed step width
# solution: kwarg stepwidth::Union{Int,<:AbstractFloat}
# solution: with Int for fixed step width and Float for percentage ind brightness difference
"""
    colourpicker(
      scheme::Vector{ColorSchemes.ColorTypes.RGB{Float64}},
      datapoints::Int=0;
      cycle::Bool=true,
      start::Union{<:AbstractFloat,Int} = -Inf,
      stop::Union{<:AbstractFloat,Int} = Inf
    )::Vector{ColorSchemes.ColorTypes.RGB{Float64}}

Select a colour palette from the colour `scheme` with `datapoints` colours.
If no `datapoints` are given, all colours are selected from the `scheme` otherwise
colours are evenly stretched over the whole scheme unless a `start` or `stop` index
or percentage (as rational number between `0` and `1`) is given. In this case,
only colours between the `start` and/or `stop` index are considered.
If you want to pick more colours than available in the scheme, the colourpicker will
cycle through the colours from the beginning again. To throw a `BoundsError` instead,
set `cycle` to `false`.
"""
function colourpicker(
  scheme::Vector{ColorSchemes.ColorTypes.RGB{Float64}},
  datapoints::Int=0;
  cycle::Bool=true,
  start::Union{<:AbstractFloat,Int} = -Inf,
  stop::Union{<:AbstractFloat,Int} = Inf
)::Vector{ColorSchemes.ColorTypes.RGB{Float64}}
  # Get length of colour scheme and bounds of selection
  ncolours = length(scheme)
  start, stop = setbounds(scheme, start, stop)
  # Process datapoints input
  if datapoints == 0
    datapoints = ncolours
  elseif datapoints == 1
    return scheme[start:start]
  end
  # Check bounds and throw exception, if cycling is off
  if ncolours < datapoints && !cycle
    throw(BoundsError(scheme, datapoints))
  end
  # Loop over colour scheme and save colours for current palette
  index = start
  stepwidth = max(1, (stop-start)/(datapoints-1))
  palette = ColorSchemes.ColorTypes.RGB{Float64}[]
  while length(palette) < datapoints
    i = min(stop, round(Int, index))
    push!(palette, scheme[i])
    index = index < stop ? index + stepwidth : start
  end
  return palette
end


"""
    setbounds(
      container::AbstractArray,
      start::Union{Int,<:AbstractFloat},
      stop::Union{Int,<:AbstractFloat}
    )::Tuple{Int,Int}

Return the start and the stop index of the `container` from the given `start` and `stop`
index either directly as `Int` or as a percentage float.
Indices can be infinitives, which are converted to the first/last index.
"""
function setbounds(
  container::AbstractArray,
  start::Union{Int,<:AbstractFloat},
  stop::Union{Int,<:AbstractFloat}
)::Tuple{Int,Int}
  maxsize = length(container)
  # Set default bounds to start and end index
  if isinf(start) && isinf(stop)
    start, stop = 1, maxsize
  elseif isinf(start)
    start = stop isa Int ? 1 : 0.0
  elseif isinf(stop)
    stop = start isa Int ? maxsize : 1.0
  end
  # Throw exception for negative starting indices
  start < 0 && throw(BoundsError(container, start))
  # Convert percentages to indices
  start isa AbstractFloat && (start = max(1, round(Int, start*maxsize, RoundNearestTiesAway)))
  stop isa AbstractFloat && (stop = round(Int, stop*maxsize, RoundNearestTiesAway))
  # Check bounds of input indices
  checkbounds(container, start)
  checkbounds(container, stop)
  # Return start and stop index
  return start, stop
end
