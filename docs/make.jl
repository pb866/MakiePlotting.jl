push!(LOAD_PATH,"../src/")

using Documenter
using MakiePlotting

makedocs(
    sitename = "MakiePlotting",
    format = Documenter.HTML(),
    modules = [MakiePlotting],
    checkdocs=:exports
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
