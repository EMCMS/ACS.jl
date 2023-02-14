#push!(LOAD_PATH,"../src/")
using Documenter, ACS



makedocs(
    modules = [Documenter, ACS],
    build = "build",
    format = Documenter.HTML(assets=["assets/init.js"]),
    clean = true,
    sitename = "ACS.jl",
    pages = [
        "Home" => "index.md",
        "Preparation" => "prep.md",
        "SVD" => "svd.md",
        "HCA" => "HCA.md",
        "k-means" => "KMeans.md",
        "Decision trees" => "DT_RF.md",
        "Bayesian Statistics" => "Bayes.md"
    ]
)

deploydocs(
    repo = "github.com/EMCMS/ACS.jl.git",
    target = "build",
    branch = "gh-pages",
    #push_preview = true,
)

# include("/Users/saersamanipour/Desktop/dev/pkgs/ACS/docs/make.jl") 