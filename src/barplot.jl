## Functions to create barplots
# TODO add kwarg with switch for different default layouts
"""
    hbar_scene(datasets::Vector{<:Real}, labels::Vector{String}; kwargs...)::Tuple{Figure,Axis}

Generate a horizontal bar plot and return the figure and axis handle.
The properties of the figure and axes can be adjusted afterwards, if the parameters
of this function do not satisfy the formatting needs.

Standard bar plots are generated from data in `datasets` labelled with `labels`.
Keyword arguments can be used to influence to plot design.

$HBAR_KWARGS
"""
function hbar_scene(
  datasets::Vector{<:Real},
  labels::Vector{<:AbstractString};
  size::Tuple{Int,Int}=(800, 600),
  xmax::Union{Nothing,<:Real}=nothing,
  xlabel::AbstractString="",
  ylabel::AbstractString="",
  smallfont=20,
  largefont=26,
  barcolours=:grey,
  colours_overbar=nothing,
  colours_overbg=:grey,
  colourscheme::Union{Bool,Symbol}=false,
  colourscheme_start::Union{Int,<:AbstractFloat} = -Inf,
  colourscheme_stop::Union{Int,<:AbstractFloat} = Inf,
  colourscheme_stepwidth::Union{Int,<:AbstractFloat} = 0,
  brightness::AbstractFloat=0.6,
  axisposition::Symbol=:top,
  showframe::Bool=false,
  formatfunction::Function=Makie.bar_label_formatter,
  flipthreshold::Real=Inf,
  cycle::Bool=true
)::Tuple{Figure,Axis}
  # Check input data
  if length(datasets) ≠ length(labels)
    @warn "number of datasets and labels unequal"
  end
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
      stop = colourscheme_stop,
      stepwidth = colourscheme_stepwidth;
      cycle,
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
    hbar(file::String, datasets::Vector{<:Real}, labels::Vector{String}, dir::String=".", kwargs...)::Nothing

Uses function `hbar_scene` to create a horizontal barplot and save to `file` in directory `dir`.
If no `dir` is given, the current directory is used. Alternatively, the directory can be
given in the file name in which case `dir` is ignored.

Arguments and keyword arguments needed for plotting are explained below.

$HBAR_KWARGS
"""
function hbar(file::String, args...; dir=".", kwargs...)::Nothing
  # Define output file
  if !contains(file, "/")
    file = joinpath(dir, file)
  end
  fig, ax = hbar_scene(args...; kwargs...)
  save(file, fig)
  return
end
