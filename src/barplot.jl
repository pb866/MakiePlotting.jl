## Functions to create barplots


"""
    function figure(
      datasets::Vector{T} where T<:Real,
      labels::Vector{String},
      xmax::Union{Nothing,Int}=nothing;
      size::Tuple{Int,Int}=(600,450),
      xlabel="",
      ylabel="",
      smallfont=20,
      largefont=26,
      barcolours=:grey,
      colours_overbar=:white,
      colours_overbg=:grey,
      axisposition::Symbol=:top,
      showframe::Bool=false,
      formatfunction::Function=Makie.bar_label_formatter,
      flipthreshold::Real=Inf
    )::Tuple{Figure,Axis}

Generate a horizontal barplot and return the figure and axis handle.
The properties of the figure and axes can be adjusted afterwards, if the parameters
of this function do not satisfy the formatting needs.

Bars are generate from data in `datasets` and labelled with `labels`.
The graph width can be restricted to `xmax`. The overall figure `size` can be given
as tuple of `(width, height)`. Axes labels are defined by `xlabel` and `ylabel`,
2 font sizes can be used by default: `smallfont` and `largefont.`

Colours can be defined for bars (`barcolours`), the font over and next to bars
(`colours_overbar` and `colours_overbg`, respectively). If you want a frame around
the graph, set `showframe` to `true`. The horizontal axis position can be chosen
with `axisposition` as `:top` or `:bottom`. A `formatfunction` can be given as anonymous
function to format labels of the individual bars. Define `flipthreshold` at which
bar labels switch from overbar labels to labels next to bars.
"""
function figure(
  datasets::Vector{T} where T<:Real,
  labels::Vector{String},
  xmax::Union{Nothing,Int}=nothing;
  size::Tuple{Int,Int}=(600,450),
  xlabel="",
  ylabel="",
  smallfont=20,
  largefont=26,
  colourscheme::Union{Bool,Symbol}=false,
  barcolours=:grey,
  colours_overbar=nothing,
  colours_overbg=:grey,
  colourscheme_start::Real=0,
  colourscheme_stop::Real=1,
  brightness::T where T<:AbstractFloat=0.6,
  axisposition::Symbol=:top,
  showframe::Bool=false,
  formatfunction::Function=Makie.bar_label_formatter,
  flipthreshold::Real=Inf
)::Tuple{Figure,Axis}
  # Set colour scheme
  if isnothing(colours_overbar)
    colours_overbar = colourscheme === false ? (:white, 0.7) : (; :dark=>:midnightblue, :bright=>(:white, 0.7))
  end
  if (colourscheme!==false)
    colourscheme === true && (colourscheme = :inferno)
    barcolours, colours_overbar = colours(length(datasets),
      scheme = colourscheme,
      fontcolour = colours_overbar,
      start = colourscheme_start,
      stop = colourscheme_stop;
      brightness
    )
  end
  # Setup plot
  fig = Figure(;size)
  ax = Axis(fig[1,1],
    yticks=(1:length(labels), labels),
    xaxisposition=axisposition
  )
  # Format plot
  ax.yticksvisible = 0
  ax.ygridvisible=0
  if xmax ≠ nothing
    xlims!(0, xmax)
  end
  ax.xlabelsize=largefont
  ax.xticklabelsize = smallfont
  ax.yticklabelsize = smallfont
  ax.xlabelsize = largefont
  ax.ylabelsize = largefont
  ax.xlabel = xlabel
  ax.ylabel = ylabel
  if !showframe
    pos = axisposition == :top ? :b : :t
    hidespines!(ax, pos, :r)
  end
  # Plot
  barplot!(ax,
    datasets,
    direction = :x,
    bar_labels = :y,
    label_formatter = formatfunction,
    xaxisposition = axisposition,
    label_size = largefont,
    color = barcolours,
    color_over_bar=colours_overbar,
    color_over_background=colours_overbg,
    flip_labels_at = flipthreshold
  )
  return fig, ax
end


"""
    function hbar(
      file::String,
      datasets::Vector{T} where T<:Real,
      labels::Vector{String},
      xmax::Union{Nothing,Int}=nothing;
      dir::String=".",
      size = (600, 450),
      xlabel="",
      ylabel="",
      smallfont=20,
      largefont=26,
      barcolours=:grey,
      colours_overbar=(:white, 0.8),
      colours_overbg=:grey,
      axisposition::Symbol=:top,
      showframe::Bool=false,
      formatfunction::Function=x->x,
      flipthreshold::Union{Nothing,Real}=nothing
)::Nothing

Uses function `figure` to create a horizontal barplot and save to `file` in directory `dir`.
If no `dir` is given, the current directory is used. Alternatively, the directory can be
given in the file name in which case `dir` is ignored.

See function `figure` for help of the parameters for plot formatting.
"""
function hbar(
  file::String,
  datasets::Vector{T} where T<:Real,
  labels::Vector{String},
  xmax::Union{Nothing,Int}=nothing;
  dir::String=".",
  size = (600, 450),
  xlabel="",
  ylabel="",
  smallfont=20,
  largefont=26,
  colourscheme::Union{Bool,Symbol}=false,
  barcolours=:grey,
  colours_overbar=nothing,
  colours_overbg=:grey,
  colourscheme_start::Real=0,
  colourscheme_stop::Real=1,
  brightness::T where T<:AbstractFloat=0.6,
  axisposition::Symbol=:top,
  showframe::Bool=false,
  formatfunction::Function=x->x,
  flipthreshold::Union{Nothing,Real}=nothing
)::Nothing
  # Define output file
  if !contains(file, "/")
    file = joinpath(dir, file)
  end
  fig, ax = figure(datasets, labels, xmax; size, xlabel, ylabel, smallfont, largefont,
    colourscheme, barcolours, colours_overbar, colours_overbg,
    colourscheme_start, colourscheme_stop, brightness,
    axisposition, showframe, formatfunction, flipthreshold)
  save(file, fig)
  return
end
