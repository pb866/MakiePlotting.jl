push!(LOAD_PATH,"../src/")

using Documenter
using MakiePlotting

makedocs(
    sitename = "MakiePlotting",
    format = Documenter.HTML(),
    modules = [MakiePlotting],
    # checkdocs=:exports,
    pages = [
        "Home" => "index.md",
        # "installation.md",
        "Manual" => [
            "horizontal bar plot" => "man/hbar.md"
        ],
        "Developers" => [
            "Adapting code" => "dev/adapt.md",
            "Functions" => "dev/functions.md"
        ],
        "code_index.md"
    ]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
