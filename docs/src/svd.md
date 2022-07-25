# Singular Value Decomposition (SVD) 

## Introduction

The [**SVD**](https://en.wikipedia.org/wiki/Singular_value_decomposition) is a matrix factorization technique that decomposes any matrix to a unique set of matrices. The **SVD** is used for dimension reduction, trend analysis, and potentially for the clustering of a multivariate dataset. **SVD** is an exploratory approach to the data analysis and therefore it is an unsupervised approach. In other words, you will only need the *X* block matrix. However, where the *Y* matrix/vector is available, it (i.e. *Y*) can be used for building composite models or assess the quality of the clustering. 

## How? 

In **SVD** the matrix *X_{m \times n}* is decomposed into the matrices *``U_{m \times n}*, *D_{n \times n}``*, and *``V_{n \times n}^{T}``*. The matrix *``U_{m \times n}``* is the left singular matrix and it represents a rotation in the matrix space. The *``D_{n \times n}``* is diagonal matrix and contains the singular values. This matrix may be indicated with different symbols such as *``\Sigma_{n \times n}``*. The *``D_{n \times n}``* matrix in the geometrical space represents an act of stretching. Each *singular value* is the degree and/or weight of stretching. We use the notation *``D_{n \times n}``* to remind ourselves that this is a diagonal matrix. Finally, *``V_{n \times n}^{T}``* is called the right singular matrix and is associated with rotation. Overall, **SVD** geometrically is a combination of a rotation, a stretching, and a second rotation.

The two matrices *``U_{m \times n}``* and *``V_{n \times n}^{T}``* are very special due to their [unitary](https://en.wikipedia.org/wiki/Unitary_matrix) properties.

```math 

U^{T} \times U = U \times U^{T} = I\\
V^{T} \times V = V \times V^{T} = I

```

Therefore the general matrix expression of **SVD** is the following: 

```math
X = UDV^{T}.

```
To deal with the non-square matrices, we have to convert our *X* matrix to ``X^{T} \times X``. This implies that our **SVD** equation will become the following: 

```math
X^{T}X = (UDV^{T})^{T} \times UDV^{T}.

```
And after a little bit of linear algebra: 

```math
X^{T}X = VD^{T} \times DV^{T} \\ 
and \\

XV = UD.

```
This is a system of two equations with two variables that can be solved. Before looking at an example of such system let's remind ourselves that ``VD^{T} \times DV^{T}`` is the solution of [eigenvalue/eigenvector decomposition](https://en.wikipedia.org/wiki/Eigendecomposition_of_a_matrix) of ``X^{T}X``. This means that both *D* and *``V^{T}``* can be calculated by calculating the [eigenvalues and eigenvectors](https://en.wikipedia.org/wiki/Eigenvalues_and_eigenvectors) of ``X^{T}X``. Therefore we can calculate *D* and *V* as follows:

```math

D = \sqrt{eigenvalues(X^{T}X)}\\ 
V = eigenvector(X^{T}X).

```

Once we know *V*, we can use that and the second equation of SVD to calculate the last part i.e. the matrix *U*. 

```math
U = XVD^{-1} 

```
Please note that ``D^{-1}`` denotes the [inverse or pseudo-inverse](https://en.wikipedia.org/wiki/Invertible_matrix) of the matrix *D*.  

## Practical example 

Let's do the **SVD** calculations together for the below matrix: 


```@example svdex
using ACS

X = [5 -5;-1 7;1 10]

```

### Step 1: ``X^{T}X``

```@example svdex
# The function transpose(-) is part of LinearAlgebra.jl package that has been automatically installed via ACS.jl package.
# Not all the functions of LinearAlgebra.jl are exported within the ACS.jl environment. 
XtX = transpose(X)*X 

```

### Step 2: calculation of *D*, *V*, and *U*

```@example svdex

D = diagm(sqrt.(eigvals(XtX))) # A diagonal matrix is generated

```

```@example svdex

V = eigvecs(XtX) # Right singular matrix


```

```@example svdex

U = X*V*pinv(D)	# Left singular matrix


```

#### Builtin function

The same calculations can be done with the function *svd(-)* of ACS package provided via LinearAlgebra.jl package. 

```@example svdex

 out = svd(X)

```

```@example svdex

 D = diagm(out.S) # The singular value matrix

```

```@example svdex

 U = out.U # Left singular matrix

```

```@example svdex

 V = transpose(out.Vt) # Right singular matrix

```

Please note that the builtin function sorts the singular values in descending order and consequently the other two matrices are also sorted following the same. Additionally, for ease of calculations the builtin function generates the mirror image of the *U* and *V* matrices. These differences essentially do not impact your calculations at all, as long as they are limited to what is listed above.

### Step 3 calculation of ``\hat{X}``

Using both the manual method and the builtin function, you can calculate ``\hat{X}`` following the below operation. 

```@example svdex

X_hat = U*D*transpose(V)

```
## Applications 

As mentioned above **SVD** has several applications in different fields. Here we will focus on three, namely: dimension reduction, clustering/trend analysis, and multivariate regression. This dataset contains five variables (i.e. columns) and 150 measurements (i.e. rows). The last variable "Species" is a categorical variable which defines the flower species. 

### Dimension reduction

To show case the power of **SVD** in dimension reduction we will use the *Iris* dataset from [Rdatasets](https://github.com/JuliaStats/RDatasets.jl). 

```@example iris
using ACS

data = dataset("datasets", "iris")
describe(data) # Summarizes the dataset

```

Here we show how **SVD** is used for dimension reduction with the *iris* dataset. First we need to convert the dataset from table (i.e. [dataframe](https://dataframes.juliadata.org/stable/)) to a matrix. For data we can use the function *Matrix(-)* builtin in the julia core language.

```@example iris
Y = data[!,"Species"]
X = Matrix(data[:,1:4]); # The first four columns are selected for this

```

Now we can perform **SVD** on the *X* and try to assess the underlying trends in the data. 

```@example iris

 out = svd(X)

```

```@example iris

 D = diagm(out.S) # The singular value matrix

```

```@example iris

 U = out.U # Left singular matrix

```

```@example iris

 V = transpose(out.Vt) # Right singular matrix

```

As you may have noticed, there are four variables in the original data and four non-zero singular values. Each column in the lift singular matrix is associated with one singular value and one row in the *V* matrix. For example the first column of sorted *U* matrix (i.e. via the builtin function) is directly connected to the first singular value of 95.9 and the first row of the matrix *V*. With all four singular values we can describe 100% of variance in the data (i.e. ``\hat{X} = X``). By removing the smaller or less important singular values we can reduce the number of dimensions in the data. We can calculate the variance explained by each singular value via two different approaches. 

```@example iris

 var_exp = diag(D) ./ sum(D) # diag() selects the diagonal values in a matrix 


```

```@example iris

 var_exp_cum = cumsum(diag(D)) ./ sum(D) # cumsum() calculates the cumulative sum 


```

```@example iris

 scatter(1:length(var_exp),var_exp,label="Individual")
 plot!(1:length(var_exp),var_exp,label=false)

 scatter!(1:length(var_exp),var_exp_cum,label="Cumulative")
 plot!(1:length(var_exp),var_exp_cum,label=false)
 xlabel!("Nr Singular Values")
 ylabel!("Variance Explained")


```
Given that the first two singular values explain more than 95% variance in the data, they are considered enough for modeling our dataset. The next step here is to first plot the scores (i.e. the left singular matrix) of first and second singular values against each other to see whether we have a model or not. Each column in the *U* matrix represents a set of scores associated with a singular value (e.g. first column for the first singular value).

```@example iris

 scatter(U[:,1],U[:,2],label=false)
 xlabel!("First Singular value (81%)")
 ylabel!("Second Singular value (15%)")
 

```
At this point we are assuming that we do not have any idea about the plant species included in our dataset. Now we need to connect the singular values to individual variables. For that similarly to [PCA](https://en.wikipedia.org/wiki/Principal_component_analysis) we will take advantage of the loadings, which in this case are the rows of the *V* or the columns of *``V^{T}``*. 

```@example iris

 bar([V[1,:],V[2,:]],label=false)
 xlabel!("First Singular value (81%)")
 ylabel!("Second Singular value (15%)")
 

```


### Clustering and trend analysis

