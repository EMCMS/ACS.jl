# Singular Value Decomposition (SVD) 

## Introduction

The **SVD** is a matrix factorization technique that decomposes any matrix to a unique set of matices. The **SVD** is used for dimension reduction, trend analysis, and potentially for the clustering of a multivariate dataset. **SVD** is an exploratory approach to the data analysis and therefore it is an unsuprevised approach. In other words, you will only need the *X* block matrix. However, where the *Y* matrix/vector is available, it (i.e. *Y*) can be used for building composit models or assess the quality of the clustering. 

## How? 

In **SVD** the matrix *X_{m \times n}* is decomposed into the matrices *``U_{m \times n}*, *D_{n \times n}``*, and *``V_{n \times n}^{T}``*. The matrix *``U_{m \times n}``* is the left singular matrix and it represents a rotation in the matrix space. The *D_{n \times n}* is diagonal matrix and contains the singular values. This matix may be indicated with different symbols such as *``\Sigma_{n \times n}``*. The *``D_{n \times n}``* matrix in the geometrical space represents an act of stratching. Each *singular value* is the degree and/or weight of stratching. We use the notation **D_{n \times n}** to remind ourselves that this is a diagonal matrix. Finally, **V_{n \times n}^{T}** is called the right singular matrix and is associated with rotation. Overall, **SVD** geometrically is a combination of a rotation, a stratching, and a second rotation.

The two matrics **U_{m \times n}** and **V_{n \times n}^{T}** are very special due to their unitary properties.

\begin{equation}

U

\end{equation}
