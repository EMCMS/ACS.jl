# Singular Value Decomposition (SVD) 

## Introduction

The [**SVD**](https://en.wikipedia.org/wiki/Singular_value_decomposition) is a matrix factorization technique that decomposes any matrix to a unique set of matices. The **SVD** is used for dimension reduction, trend analysis, and potentially for the clustering of a multivariate dataset. **SVD** is an exploratory approach to the data analysis and therefore it is an unsuprevised approach. In other words, you will only need the *X* block matrix. However, where the *Y* matrix/vector is available, it (i.e. *Y*) can be used for building composit models or assess the quality of the clustering. 

## How? 

In **SVD** the matrix *X_{m \times n}* is decomposed into the matrices *``U_{m \times n}*, *D_{n \times n}``*, and *``V_{n \times n}^{T}``*. The matrix *``U_{m \times n}``* is the left singular matrix and it represents a rotation in the matrix space. The *``D_{n \times n}``* is diagonal matrix and contains the singular values. This matix may be indicated with different symbols such as *``\Sigma_{n \times n}``*. The *``D_{n \times n}``* matrix in the geometrical space represents an act of stratching. Each *singular value* is the degree and/or weight of stratching. We use the notation *``D_{n \times n}``* to remind ourselves that this is a diagonal matrix. Finally, *``V_{n \times n}^{T}``* is called the right singular matrix and is associated with rotation. Overall, **SVD** geometrically is a combination of a rotation, a stratching, and a second rotation.

The two matrics *``U_{m \times n}``* and *``V_{n \times n}^{T}``* are very special due to their [unitary](https://en.wikipedia.org/wiki/Unitary_matrix) properties.

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
# Not all the functions of LinearAlgebra.jl are exported within the ACS.jl enviornment. 
XtX = transpose(X)*X 

```

### Step 2: calculation of *D*, *V*, and *U*

```@example svdex

D = diagm(sqrt.(eigvals(XtX))) # A diagonal matrix is generated
V = eigvecs(XtX)
U = X*V*pinv(D)	

```

### Step 3 calculation of ``\hat{X}``

```@example svdex

X_hat = U*D*transpose(V)

```

The same calculations can be done with the fucntion *svd(-)* of ACS package provided via LinearAlgebra.jl package. 
