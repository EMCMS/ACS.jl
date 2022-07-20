#push!(LOAD_PATH,"../src/")
using Documenter, ACS



makedocs(
    modules = [Documenter, ACS],
    build = "build",
    format = Documenter.HTML(),
    clean = true,
    sitename = "ACS.jl",
    pages = [
        "Home" => "index.md",
        "Preparation" => "prep.md",
        "SVD" => "svd.md"
    ]
)

deploydocs(
    repo = "github.com/EMCMS/ACS.jl.git",
    target = "build",
    branch = "gh-pages",
    #push_preview = true,
)
