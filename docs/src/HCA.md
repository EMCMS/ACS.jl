# Hierarchical Cluster Analysis (HCA) 

## Introduction

The [**HCA**](https://en.wikipedia.org/wiki/Hierarchical_clustering) is an unsupervised clustering approach mainly based on the distances of the measurements from each other. It is an agglomerative approach, thus starting with each individual measurement as a cluster and then grouping them to build a final cluster that includes all the measurements.   

## How? 

The approach taken in **HCA** is very simple from programming point of view. The algorithm starts with the assumption that every individual measurement is a unique cluster. Then it calculates the pairwise distances between the measurements. The two measurements with the smallest distance are grouped together to form the first agglomerative cluster. In the next iteration, the newly generated cluster is then represented by either its mean, minimum or its maximum for the distance calculations. It should be noted that there are several ways to calculate the distance between two measurements (e.g. [Euclidean distance](https://en.wikipedia.org/wiki/Euclidean_distance) and [Mahalanobis distance](https://en.wikipedia.org/wiki/Mahalanobis_distance)). For simplicity, we are only going to look at the "Euclidean distance" here.   

In a one dimensional space, the distance between points ``x_{n}`` and ``x_{m}`` is calculated by subtracting the two points from each other.

```math 

d_{m,n} = x_{n} - x_{m}

```

Assuming the below dataset with vectors *X* and *Y* as the coordinates. 

```@example hcax
using ACS

# Generating the data

cx1 = 1 .+ (2-1) .* rand(5) # 5 random values between 1 and 2 
c1 = 5 .* rand(5)           # 5 random values around 5
cx2 = 4 .+ (6-4) .* rand(5) # 5 random values between 4 and 6
c2 = 10 .* rand(5)          # 5 random values around 10

Y = vcat(c1[:],c2[:])       # building matrix Y
X = vcat(cx1[:],cx2[:])     # building the matrix X

# Plotting the data
scatter(cx1,c1,label = "Cluster 1")
scatter!(cx2,c2,label = "Cluster 2")
xlabel!("X")
ylabel!("Y")

```
We first plot the data in the one dimensional data. In other words, we are setting the y values to zero in our data matrix. Below you can see how this is done.

```@example hcax
using ACS

# Plotting the data

scatter(X,zeros(length(X[:])),label = "Data")

xlabel!("X")
ylabel!("Y")

```

The next step is to calculate the distances in the x domain. For that we are using the Euclidean distances. Here we need to calculate the distance between each point in the *X* and all the other values in the same matrix. This implies that we will end up with a square distance matrix (i.e. *dist*). The *dist* matrix has a zero diagonal, given that the values on the diagonal represent the distance between each point and itself. Also it is important to note that we are interested only in the magnitude of the distance but not its direction. Thus, you can use the [*abs.(-)*](https://docs.julialang.org/en/v1/base/math/#Base.abs) to convert all the distances to their absolute values. Below you can see an example of a function for these calculations.

```@example hcax
using ACS

function dist_calc(data)

    dist = zeros(size(data,1),size(data,1))      # A square matrix is initiated 
	for i = 1:size(data,1)-1                     # The nested loops create two unaligned vectors by one member
		for j = i+1:size(data,1)
			dist[j,i] = data[j,1] - data[i,1]    # The generated vectors are subtracted from each other 
		end
	end

	dist += dist'                                # The upper diagonal is filled 
	return abs.(dist)                            # Make sure the order of subtraction does not affect the distances

end 

dist = dist_calc(X)

```

In the next step we need to find the points in the *X* that have the smallest distance and should be grouped together as the first cluster. To do so we need to use the *dist* matrix. However, as you see in the *dist* matrix the smallest values are zero and are found in the diagonal. A way to deal with this is to set the diagonal to for example to *Inf*. 

```@example hcax
using ACS

#dist = dist_calc(X) 
dist[ACS.diagind(dist)] .= Inf                   # Set the diagonal to inf, which is very helpful when searching for minimum distance
dist

```

Now that we have the complete distances matrix, we can use the function [*argmin(-)*](https://docs.julialang.org/en/v1/base/collections/#Base.argmin) to find the coordinates of the points with the minimum distance in the *X*. 

```@example hcax
using ACS

cl_temp = argmin(dist)

```

The selected points in the *X* are the closest to each other, indicating that they should be grouped into one cluster. In the next step, we will assume this cluster as a single point and thus we can repeat the distance calculations. For simplicity, we assume that the average of the two points is representative of that cluster. This process is called [linkage](https://en.wikipedia.org/wiki/Hierarchical_clustering#Linkage_criteria) and can be done using different approaches. Using the mean, in particular, is called centroid linkage. With centroid method, we are replacing these points with their average. This process can be repeated until all data points are grouped into one single cluster.

```@example hcax
using ACS

X1 = deepcopy(X)
X1[cl_temp[1]] = mean([X[cl_temp[1]],X[cl_temp[2]]])
X1[cl_temp[2]] = mean([X[cl_temp[1]],X[cl_temp[2]]])

[X,X1]


```

```@example hcax
using ACS


scatter(X,zeros(length(X[:])),label = "Original data")
scatter!(X1,0.01 .* ones(length(X1[:])),label = "Data after clustering",fillalpha = 0.5)
ylims!(-0.01,0.1)
xlabel!("X")
ylabel!("Y")


```


So far, we have done all our calculations based on one dimensional data. Now we can move towards two and more dimension. One of the main things to consider when increasing the number of dimensions is the distance calculations. In the above examples, we have use the [Euclidean distance](https://en.wikipedia.org/wiki/Euclidean_distance), which is one of many [distance metrics](https://en.wikipedia.org/wiki/Hierarchical_clustering#Similarity_metric). In general terms the Euclidean distance can be expressed as below, where ``d_{m,n}`` represents the distance between points *m* and *n*. This is based on the [Pythagorean distance](https://en.wikipedia.org/wiki/Euclidean_distance). 

```math
d_{m,n} = \sqrt{\sum (x_{m} - x_{n})^{2}}}.

```

Let's try to move to a two dimensional space rather than uni-dimensional one. 

```@example hcax
using ACS

# Plotting the data
scatter(cx1,c1,label = "Cluster 1")
scatter!(cx2,c2,label = "Cluster 2")
xlabel!("X")
ylabel!("Y")

```
The very first step to do so is to convert our 1D distances to 2D ones, using the below equation. If we replace the ``dist[j,i] = data[j,1] - data[i,1]`` with the below equation in our distance function, we will be able to generate the distance matrix for our two dimensional dataset. 

```math
d_{m,n} = \sqrt{(x_{m} - x_{n})^{2} + (y_{m} - y_{n})^{2}}.

```

```@example hcax
using ACS

function dist_calc(data)

    dist = zeros(size(data,1),size(data,1))      # A square matrix is initiated 
	for i = 1:size(data,1)-1                     # The nested loops create two unaligned vectors by one member
		for j = i+1:size(data,1)
			dist[j,i] = sqrt(sum((data[i,:] .- data[j,:]).^2))    # The generated vectors are subtracted from each other 
		end
	end

	dist += dist'                                # The upper diagonal is filled 
	return abs.(dist)                            # Make sure the order of subtraction does not affect the distances

end 

data = hcat(X,Y)								# To generate the DATA matrix

dist = dist_calc(data) 							# Calculating the distance matrix
dist[ACS.diagind(dist)] .= Inf                   # Set the diagonal to inf, which is very helpful when searching for minimum distance
dist

```

```@example hcax
using ACS

cl_temp = argmin(dist)

data1 = deepcopy(data)

data1[cl_temp[1],1] = mean([data[cl_temp[1],1],data[cl_temp[2],1]])
data1[cl_temp[1],2] = mean([data[cl_temp[1],2],data[cl_temp[2],2]])
data1[cl_temp[2],1] = mean([data[cl_temp[1],1],data[cl_temp[2],1]])
data1[cl_temp[2],2] = mean([data[cl_temp[1],2],data[cl_temp[2],2]])

data1

```

```@example hcax
using ACS

scatter(data[:,1],data[:,2],label = "Original data")
scatter!(data1[:,1],data1[:,2],label = "Data after clustering")
xlabel!("X")
ylabel!("Y")


```
As it can be seen in the figure, there are two blue points and one red point in the middle of those points. These blue dots represent the two closest data points that are clustered together to form the centroid in between them. If we repeat this process multiple times, we eventually end up having all data points into one large cluster. The HCA clustering generates an array of clustered data points that can be visualized via a [dendrogram](https://en.wikipedia.org/wiki/Dendrogram) or a [heatmap](https://en.wikipedia.org/wiki/Heat_map). 

```@example hcax
using ACS

dist = dist_calc(data) 

hc = hclust(dist, linkage=:average)
#ACS.sp.plot(1:10)

```


## Practical example 

Let's look at the iris dataset and perform HCA 


## Applications 



## Additional example

If you are interested in practicing more, you can use the [NIR.csv](https://github.com/EMCMS/ACS.jl/blob/main/datasets/NIR.csv) file provided in the [folder dataset](https://github.com/EMCMS/ACS.jl/tree/main/datasets) of the package [*ACS.jl* github repository](https://github.com/EMCMS/ACS.jl). Please note that this is an *SVR* problem, where you can first use **SVD** for the dimension reduction and then use the selected *SVs* for the regression. 

If you are interested in math behind **SVD** and would like to know more you can check this [MIT course material](https://ocw.mit.edu/courses/18-065-matrix-methods-in-data-analysis-signal-processing-and-machine-learning-spring-2018/resources/lecture-6-singular-value-decomposition-svd/).  