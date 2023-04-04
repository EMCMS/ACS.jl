# *k*-nearest neighbors algorithm (*k*-NN) 

## Introduction

The [**k-NN**](https://en.wikipedia.org/wiki/K-nearest_neighbors_algorithm) is a non-parametric and supervised algorithm for both regression and classification of multidimensional data. The **k-NN** can handle both numerical and categorical datasets to perform the regression or classification.   

## How? 

The principal concept behind **k-NN** is to use the average estimate of *k* nearest neighbors as the model prediction for that specific measurement, implying that the model relies purely on the underlying trend in the data itself (i.e. [non generalized function or equation](https://scikit-learn.org/stable/modules/neighbors.html#classification)). The steps essential to **k-NN** are: (1) distance calculations, (2) sorting of the data (3) finding k nearest neighbors, and (4) estimate the model output using those data.  

As mentioned above **k-NN** is a supervised algorithm, thus the data provided to the algorithm must have *X* matrix (i.e. the independent variables) and *Y* matrix/vector (i.e. dependent variable). The simplest example to start with is a simple calibration problem. Let's generate the needed data for our example. 

```@example knn
using ACS

f(x) = 2 .* x .+ 5  		# Defining the function
x = collect(1:0.1:10)     	# Defining X
x_n = rand(length(x))		# Let's generate some noise

y = f(x .+ x_n)				# Generate the Y via the function X and noise

# Plotting the data
scatter(x ,y,label = false)
xlabel!("X")
ylabel!("Y")

```

This dataset can be fitted with a linear model using the [least square](https://en.wikipedia.org/wiki/Least_squares) providing us with the associated coefficients. Let's assume we do not know least squares and want to solve this using **k-NN** to perform this regression. As mentioned above, we follow the below steps:

### Step 1: 
To calculate the distances, we will use the [Euclidean distance](https://en.wikipedia.org/wiki/Euclidean_distance). Other distance metrics are also possible but for this example we will work the simplest one. For the distance calculations we ignore the *Y* matrix and only focus on the *X* matrix. 

```@example knn
using ACS



dist = ACS.dist_calc([x,x])

# Plotting the data
ACS.heatmap(dist,label = false)


```



## Practical Application



## Additional Example

