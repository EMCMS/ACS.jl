using Documenter, ACS

makedocs(sitename="Advanced Chemometrics and Statistics Course UvA")



makedocs(
    modules = [Documenter, ACS],
    build = "build",
    clean = true,
    sitename = "ACS at UvA",
    pages = [
        "Home" => "index.md",
        "Preparation" => "prep.md",
        "SVD" => "svd.md"
    ]
)

deploydocs(
    repo = "github.com/EMCMS/ACS.jl.git",
    target = "build",
    push_preview = true,
)
