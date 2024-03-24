"""
    colours(
      datapoints::Int=0;
      scheme::Symbol=:inferno,
      fontcolour=(; :dark=>:midnightblue, :bright=>(:white, 0.7)),
      start::Union{Int,<:AbstractFloat,} = -Inf,
      stop::Union{Int,<:AbstractFloat,} = Inf,
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
Colours a stretched to extend over the whole scheme evenly distributed by default.
If an integer is set for `stepwidth`, every nth colour defined by the `stepwidth`
will be chosen from the `scheme` between `start` and `stop`. Alternatively, a float
can be defined between `0` and `1`. In this case, colours will be picked from the
`scheme`, if there is a minimum brightness difference between them as defined by the `stepwidth`.
By default, the scheme cycles through colours and starts from the beginning, if more colours
are needed than available in the scheme. This behaviour can be switched off, by setting
`cycle` to `false` in which case a `BoundsError` is thrown.
"""
function colours(
  datapoints::Int=0;
  scheme::Symbol=:inferno,
  fontcolour=(; :dark=>:midnightblue, :bright=>(:white, 0.7)),
  start::Union{Int,<:AbstractFloat,} = -Inf,
  stop::Union{Int,<:AbstractFloat} = Inf,
  stepwidth::Union{<:AbstractFloat,Int} = 0,
  cycle::Bool=true,
  brightness::T where T<:AbstractFloat=0.6
)
  # Set colour scheme
  colourscheme = colorschemes[scheme].colors
  # Get colour vector for selected data points
  colourvector = colourpicker(colourscheme, datapoints; cycle, start, stop, stepwidth)
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


"""
    colourpicker(
      scheme::Vector{ColorSchemes.ColorTypes.RGB{Float64}},
      datapoints::Int=0;
      cycle::Bool=true,
      start::Union{Int,<:AbstractFloat,} = -Inf,
      stop::Union{Int,<:AbstractFloat,} = Inf
    )::Vector{ColorSchemes.ColorTypes.RGB{Float64}}

Select a colour palette from the colour `scheme` with `datapoints` colours.
If no `datapoints` are given, all colours are selected from the `scheme` otherwise
colours are evenly stretched over the whole scheme unless a `start` or `stop` index
or percentage (as rational number between `0` and `1`) is given. In this case,
only colours between the `start` and/or `stop` index are considered. The `stepwidth`
can be adjusted by setting an integer `n`, so that every `nth` colour is picked or
giving a percentage float between `0` and `1`, in which case colours are picked, if
the difference in brightness exceeds the value given by `stepwidth`.
If you want to pick more colours than available in the scheme, the colourpicker will
cycle through the colours from the beginning again. To throw a `BoundsError` instead,
set `cycle` to `false`.
"""
function colourpicker(
  scheme::Vector{ColorSchemes.ColorTypes.RGB{Float64}},
  datapoints::Int=0;
  cycle::Bool=true,
  start::Union{Int,<:AbstractFloat,} = -Inf,
  stop::Union{Int,<:AbstractFloat,} = Inf,
  stepwidth::Union{Int,<:AbstractFloat,} = 0
)::Vector{ColorSchemes.ColorTypes.RGB{Float64}}
  #* Get length of colour scheme and bounds of selection
  start, stop = setbounds(scheme, start, stop)
  stop > length(scheme) && throw(BoundsError(scheme, stop))
  schememax =  abs(stop - start) + 1
  #* Special cases and exception handling
  if datapoints == 0 && stepwidth isa Int
    if stepwidth == 0
      stepwidth = start < stop ? 1 : -1
      datapoints = schememax
    else
      datapoints, rem = divrem(schememax, abs(stepwidth))
      rem == 0 || (datapoints += 1)
    end
  elseif datapoints == 1
    return scheme[start:start]
  end
  #* Get colours for current palette
  pickcolours(scheme, datapoints, cycle, start, stop, stepwidth)
end


function pickcolours(
  scheme::Vector{ColorSchemes.ColorTypes.RGB{Float64}},
  datapoints::Int,
  cycle::Bool,
  start::Int,
  stop::Int,
  stepwidth::Int
)::Vector{ColorSchemes.ColorTypes.RGB{Float64}}
  if start == stop
    index = start:stop
  elseif iszero(stepwidth)
    # Define default index and set index to start colour
    stepwidth = (stop-start)/(datapoints-1)
    abs(stepwidth) < 1 && (stepwidth = sign(stepwidth))
    index = collect(start:stepwidth:stop)
    index = round.(Int, index)
  else
    # Get selected colours from scheme
    index = start:stepwidth:stop
    if stop - index[end] ≥ 0.5stepwidth > 0
      index = vcat(collect(index), stop)
      datapoints < length(index) && (datapoints += 1)
    end
  end
  colours = scheme[index]
  # Check bounds and throw exception, if cycling is off
  if !cycle && length(colours) < datapoints
    throw(BoundsError(scheme, datapoints))
  end
  # Compile colour vector
  n, i = divrem(datapoints, length(colours))
  return vcat(repeat(colours, n), colours[1:i])
end


function pickcolours(
  scheme::Vector{ColorSchemes.ColorTypes.RGB{Float64}},
  datapoints::Int,
  cycle::Bool,
  start::Int,
  stop::Int,
  stepwidth::T where T<:AbstractFloat
)::Vector{ColorSchemes.ColorTypes.RGB{Float64}}
  # Check stepwidth range
  !(0 < stepwidth < 1) && throw(DomainError(stepwidth, "stepwidth must be between 0 and 1 or valid index of colour scheme"))
  # Init colour palette
  colours = scheme[start:start]
  steps = start == stop ? 1 : sign(stop-start)
  for colour in scheme[start:steps:stop]
    if abs(RGBbrightness(colours[end]) - RGBbrightness(colour)) ≥ stepwidth
      push!(colours, colour)
      length(colours) == datapoints && break
    end
  end
  # Check bounds and throw exception, if cycling is off
  if !cycle && length(colours) < datapoints
    throw(BoundsError(scheme, datapoints))
  end
  # Compile colour vector
  datapoints == 0 && (datapoints = length(colours))
  n, i = divrem(datapoints, length(colours))
  return vcat(repeat(colours, n), colours[1:i])
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
