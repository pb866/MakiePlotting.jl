const HBAR_KWARGS = """
# Arguments

- `datasets::Vector{<:Real}`: Vector of real numbers to be displayed by bar plots.
- `labels::Vector{<:AbstractString}`: Vector of strings with labels explaining the data
  in `datasets`. Must be of same length as the `datasets` vector.


# Keyword arguments

- `size::Tuple{Int,Int}=(800, 600)`: Canvas size of the plot in pixels given as
  Tuple of Ints with width and height (default: 800x600).
- `xmax::Union{Nothing,Int}=nothing`: Adjust the axis length of the bar plot by
  giving a maximum value as real.
- `xlabel::T where T<:AbstractString=""`: Label of the x-axis. Can be a simple string
  or, e.g., a `LaTeXString` for mor complex labels.
- `ylabel::T where T<:AbstractString=""`: Label of the y-axis. Can be a simple string
  or, e.g., a `LaTeXString` for mor complex labels.
- `smallfont=20`: By default, MakiePlotting uses 2 font sizes. Small fonts are used for tick labels.
- `largefont=26`: By default, MakiePlotting uses 2 font sizes. Large fonts are used for
  axis labels and bar labels.
- `barcolours=:grey`: In `colourschemes`, a common colour for all bars is defined.
  `barcolours` accepts any Makie colour format such as RGB values, symbols of named colours,
  tuple of colour name as symbol and transparency value as float, etc. Colours can also be
  assigned individually to each bar by giving a Vector of the same length as `datasets`.
- `colours_overbar=nothing`: Defines the font colour of text written on top of bars.
  The same Makie colour format as for bar colours is allowed as input. Either define one
  font colour uniformly used for all bars or use a vector of the same length as `datasets`
  to assign colours individually to each bar. As another alternative, a `NamedTuple` with
  entries `:bright` and `:dark` can be defined that specifies a bright font, which is
  being used over dark columns for the `bright` entry and a dark font vice versa. Dark and
  bright bars are identified by their colour brightness and threshold where to separate bright
  and dark fonts can be given by the `brightness` kwarg (see below).
- `colours_overbg=:grey`: Defines the font colour of bar labels written next to the bars in the plot.
  The same Makie colour format as for bar colours is allowed as input. Either define one
  font colour uniformly used for all bars or use a vector of the same length as `datasets`
  to assign colours individually to each bar.
- `colourscheme::Union{Bool,Symbol}=false`: Define a colour scheme to bars of varying colours.
  If set to `true`, `inferno` is used as default colour scheme. Otherwise, define a colour scheme
  by giving the scheme name as `Symbol`. By default, colours from the colour scheme are chosen
  as such individual colours from the scheme are picked so that they are nearly evenly distributed
  in the scheme for the number of colours needed. Therefore, individual bar colours will look
  differently depending on the number of bars in a plot. This behaviour can be influenced with
  the below kwargs.
- `colourscheme_start::Union{Int,<:AbstractFloat} = -Inf`/
  `colourscheme_stop::Union{Int,<:AbstractFloat} = Inf`:
  The `colourscheme` range from which colours are picked can be restricted by giving a start
  and/or stop index. Colours will be included within given indices, if `colourscheme_start`/
  `colourscheme_stop` are passed as `Int`. If given as float between `0` and `1`, this
  percentage of colours at the beginning or end of a `colourscheme` is ignored.
- `colourscheme_stepwidth::Union{Int,<:AbstractFloat} = 0`: By default, colours in a
  `colourscheme` are chosen so that the colours stretch over the whole range and are evenly
  distributed. This results in different bar colours for bar plots with different number of bars.
  To have the same bar colours in each plot, a stepwidth can be defined by which colours
  are chosen from a `colourscheme`. The `colourscheme_stepwidth` can either be given an `Int`,
  which directly sets the stepwidth or a floating value. When given a Floating value, the
  brightness value of each colour is determined, and colours from a scheme are picked so
  consecutive colours exceed the threshold in brightness given. (see also next point)
- `brightness::T where T<:AbstractFloat=0.6`: RGB colour brightness is determined by the
  formula ``brightness = 0.299red + 0.587green + 0.114blue``. The brightness value is
  used to separate darker from brighter colours. A threshold can be given to used a bright
  and a dark font over bars depending on the brightness threshold.
- `axisposition::Symbol=:top`: Defines the position of the main axis with tick values.
- `showframe::Bool=false`: When set to true, all four axis are displayed in the plot
  giving the impression of a frame around the bars. Otherwise, a more minimalistic design
  with an axis at the left and top is used.
- `formatfunction::Function=Makie.bar_label_formatter`: A lambda function can be passed with
  this kwarg to format bar label strings.
- `flipthreshold::Real=Inf`: If a threshold is given here, bar labels of bars exceeding the
  threshold are displayed on top of the bars. Otherwise, bar labels are displayed next to
  the bars.
- `cycle::Bool=true`: By default, if there are more `datasets` than colours available from
  a `colourscheme`, for the first colour exceeding the limit, the first colour from the
  `colourscheme` will be chosen again and it will be cycled through the scheme as many times
  as needed. If setting `cycle` to `false`, a `BoundsError` will be thrown instead to make
  aware of the duplicate use of colours.
"""
