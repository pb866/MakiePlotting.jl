## Functions to create barplots
# TODO add kwarg with switch for different default layouts

"""
    figure(
      datasets::Vector{<:Real},
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
      colourscheme_start::Union{Int,<:AbstractFloat} = -Inf,
      colourscheme_stop::Union{Int,<:AbstractFloat} = Inf,
      colourscheme_stepwidth::Union{Int,<:AbstractFloat} = 0,
      brightness::T where T<:AbstractFloat=0.6,
      axisposition::Symbol=:top,
      showframe::Bool=false,
      formatfunction::Function=Makie.bar_label_formatter,
      flipthreshold::Real=Inf,
      cycle::Bool=true
    )::Tuple{Figure,Axis}

Generate a horizontal barplot and return the figure and axis handle.
The properties of the figure and axes can be adjusted afterwards, if the parameters
of this function do not satisfy the formatting needs.


# Extended help

Bars are generate from data in `datasets` and labelled with `labels`.
The graph width can be set to `xmax`. The overall figure `size` can be given
as tuple of `(width, height)`. Axes labels are defined by `xlabel` and `ylabel`,
2 font sizes can be used by default: `smallfont` and `largefont.`

Colours can be defined for bars (`barcolours`), the font over and next to bars
(`colours_overbar` and `colours_overbg`, respectively). Either one overbar colour
can be specified in any valid Makie format or a `NamedTuple` with entries `:dark`
and `bright` for dark and bright bars. Colour brightness is determined automatically
and can be adjusted with the `brightness` argument by giving a percentage between
`0` and `1`.

Instead of giving a colour vector directly, a `colourscheme` can be chosen, which
can be restricted to the `colourscheme_start` and `colourscheme_stop`.
The start/stop values can be given as index or as percentage float between
`0` and `1`. If set, colours outside `colourscheme_start` and `colourscheme_stop`
are ignored. Colours a stretched to extend over the whole scheme evenly distributed
by default. If an integer is set for `colourscheme_stepwidth`, every nth colour
defined by the `colourscheme_stepwidth` will be chosen from the `colourscheme` between
`colourscheme_start` and `colourscheme_stop`. Alternatively, a float can be defined
between `0` and `1`. In this case, colours will be picked from the `colourscheme`, if there
is a minimum brightness difference between them as defined by the `colourscheme_stepwidth`.
If more colours are needed than in the scheme, colours are chosen from the beginning
again. This `cycle` behaviour can be switched off, and a `BoundsError` is thrown instead.

To show all 4 axes, set `showframe` to `true`. The horizontal axis position can be
chosen with `axisposition` as `:top` or `:bottom`, which also affect labelling.
A `formatfunction` can be given as anonymous function to format labels of the
individual bars. Define `flipthreshold` at which bar labels switch from overbar
labels to labels next to bars.
"""
function figure(
  datasets::Vector{<:Real},
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
  colourscheme_start::Union{Int,<:AbstractFloat} = -Inf,
  colourscheme_stop::Union{Int,<:AbstractFloat} = Inf,
  colourscheme_stepwidth::Union{Int,<:AbstractFloat} = 0,
  brightness::T where T<:AbstractFloat=0.6,
  axisposition::Symbol=:top,
  showframe::Bool=false,
  formatfunction::Function=Makie.bar_label_formatter,
  flipthreshold::Real=Inf,
  cycle::Bool=true
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
    hbar(
      file::String,
      datasets::Vector{<:Real},
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
      colourscheme_start::Union{Int,<:AbstractFloat} = -Inf,
      colourscheme_stop::Union{Int,<:AbstractFloat} = Inf,
      colourscheme_stepwidth::Union{Int,<:AbstractFloat} = 0,
      brightness::T where T<:AbstractFloat=0.6,
      axisposition::Symbol=:top,
      showframe::Bool=false,
      formatfunction::Function=x->x,
      flipthreshold::Union{Nothing,Real}=nothing,
      cycle::Bool=true
    )::Nothing

Uses function `figure` to create a horizontal barplot and save to `file` in directory `dir`.
If no `dir` is given, the current directory is used. Alternatively, the directory can be
given in the file name in which case `dir` is ignored.

See function `figure` for help of the parameters for plot formatting.
"""
function hbar(
  file::String,
  datasets::Vector{<:Real},
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
  colourscheme_start::Union{Int,<:AbstractFloat} = -Inf,
  colourscheme_stop::Union{Int,<:AbstractFloat} = Inf,
  colourscheme_stepwidth::Union{Int,<:AbstractFloat} = 0,
  brightness::T where T<:AbstractFloat=0.6,
  axisposition::Symbol=:top,
  showframe::Bool=false,
  formatfunction::Function=x->x,
  flipthreshold::Union{Nothing,Real}=nothing,
  cycle::Bool=true
)::Nothing
  # Define output file
  if !contains(file, "/")
    file = joinpath(dir, file)
  end
  fig, ax = figure(datasets, labels, xmax; size, xlabel, ylabel, smallfont, largefont,
    colourscheme, barcolours, colours_overbar, colours_overbg,
    colourscheme_start, colourscheme_stop, colourscheme_stepwidth, brightness,
    axisposition, showframe, formatfunction, flipthreshold, cycle)
  save(file, fig)
  return
end
