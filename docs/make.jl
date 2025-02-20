#push!(LOAD_PATH,"../src/")
using Documenter, ACS



makedocs(
    modules = [ACS],
    build = "build",
    clean = true,
    sitename = "ACS.jl",
    pages = [
        "Home" => "index.md",
        "Preparation" => "prep.md",
        "SVD" => "svd.md",
        "HCA" => "HCA.md",
        "k-means" => "KMeans.md",
        "Decision trees" => "DT_RF.md",
        "Bayesian Statistics" => "Bayes.md"#,
        #"k-nearst neighbor" => "KNN.md"
    ]
)

deploydocs(
    repo = "github.com/EMCMS/ACS.jl.git",
    target = "build",
    branch = "gh-pages",
    push_preview = true,
)

# include("/Users/saersamanipour/Desktop/dev/pkgs/ACS/docs/make.jl") 