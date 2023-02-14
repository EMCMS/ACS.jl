using ACS
using Test
#using ScikitLearn
@sk_import decomposition: PCA

@testset "ACS.jl" begin
    # Write your tests here.
    #@sk_import decomposition: PCA
    iris = dataset("datasets", "iris")
    #println(iris)

    X = Matrix(iris[:,1:3])
    s = iris[!,"Species"]
    #pca = sk_pca(n_components=2)
    pca = PCA(n_components=2)
    pca.fit(X)
    #println(pca.explained_variance_ratio_)

    @test pca.explained_variance_ratio_[1] > 0.9

    #LogisticRegression

end
