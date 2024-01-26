# Decision trees and random forrest   

## Introduction

[**Decision trees**](https://en.wikipedia.org/wiki/Decision_tree) are a modeling strategy for dealing with complex data that may include [non-linearity](https://en.wikipedia.org/wiki/Nonlinear_system) and/or non-continuity. **Decision trees** can be used for solving both regression and classification problems. **Decision trees** are easy to interpret as you can follow the data within the tree and are able to include the information from different parameters into the final model prediction. The two main disadvantages of **decision trees** are that they tend to have low accuracy and biased towards categorical variables with more levels. These shortcomings of **decision trees** are mitigated by the use of [**random forest**](https://en.wikipedia.org/wiki/Random_forest), which is an [ensemble](https://en.wikipedia.org/wiki/Ensemble_learning) approach combining the prediction of multiple **decision trees** to generate the final prediction the model. Forest based models are generally considered [black box](https://en.wikipedia.org/wiki/Black_box) approaches as they could quickly get very complicated to interpret. However, they are capable of producing reasonable prediction with lower probability of [overfitting](https://en.wikipedia.org/wiki/Overfitting). 

## How to decision tree?

In **decision trees** there are three essential entities: root node, inner node, and leaf node. The root node is a splitting point in a one of the variables where the maximum information gain is obtained. In other word, the highest level of separation is usually obtained at the root node. The inner nodes or nodes are the splitting points for each variable, where over each iteration the purity of the data increases. Finally the leaf node or leaf is the node where further splitting will not result in accuracy gain. Usually the mean of the leaf is considered the model prediction for that specific node. The main formula used for finding a splitting point is the [residual sum squares (RSS)](https://en.wikipedia.org/wiki/Residual_sum_of_squares). Here we are looking for the minimum value of RSS to be used as the splitting point.    

```math 

RSS = \sum ^{n}_{i=1} (y_{i} - f(x_{i}))^2 

```

In this equation ``f(x_{i})`` represents the mean of the data points are grouped together while the ``y_{i}`` is the each individual measurement. By calculating the *RSS* we are evaluating whether the mean of grouped data points is a good enough estimation of the data. Once one set of data points are grouped, then we use their mean (average) to represent them. This process is repeated for all the variables and data points until every measurement is a relatively pure leaf. A pure leaf is a leaf where the mean of the grouped data points is an accurate estimation of most data points. Let's see how this works. 

## Practical Example

### Univariate Case

To start we will use a two dimensional data set, where we would like to predict the relative intensity of our signal based on the injected mass of the calibrant into our mass spectrometer. 

```@example DT
using ACS

file_name = "Rel_res.csv"               # This file is available at: https://github.com/EMCMS/ACS.jl/tree/main/datasets

data = read_ACS_data(file_name)         # Importing the data using an ACS function

scatter(data[!,"Conc"],data[!,"Signal "], label=false)
xlabel!("Mass calibrant (Fg)")
ylabel!("Relative intensity (%)")


```

As you can see, our measurements are not linear and/or continuous. Thus a simple linear model will not be an adequate estimator of this data. Also our data appears to consist of five clusters for each concentration range (i.e. independent variable). Let's try to model this data using a **decision tree**.

```@example DT
using ACS

scatter(data[!,"Conc"],data[!,"Signal "], label="data")
plot!([0,90],[0,100],label="Linear model")
xlabel!("Mass calibrant (Fg)")
ylabel!("Relative intensity (%)")


```

The first step to build a **decision tree** model is to find the root node (i.e. the first splitting point). Given that we are looking at only one dependent variable (i.e. the relative intensity), we will need to find the first splitting point only in this variable. We will look at the bi-variate case later on. To find the first splitting point, we start with injected masses larger than 2 (i.e. all our measurements except the first one). This implies that we have two groups where the injected mass is either smaller than 2 or larger than two. 

```@example DT
using ACS

scatter(data[!,"Conc"],data[!,"Signal "], label="data")
plot!([0,2],[6,6],label="< 2")
plot!([2,90],[mean(data[2:end,"Signal "]),mean(data[2:end,"Signal "])],label="> 2")
xlabel!("Mass calibrant (Fg)")
ylabel!("Relative intensity (%)")


```
Here we can visually see that the group "< 2" is providing very accurate prediction (*RSS* = 0) while the second group is not able to predict the instrument response properly. To quantify this, we will use the *RSS* value for each mass of calibrant being the splitting point. It should be that for the first iteration of the splitting, we will use the point itself as we cannot calculate the mean of a single number.

```@example DT
using ACS

RSS_l = data[1,"Signal "] - data[1,"Signal "] # 

RSS_r = sum((data[2:end,"Signal "] .- mean(data[2:end,"Signal "])).^2)

RSS = RSS_l + RSS_r


```

This process is repeated for every single breaking points. For example let's repeat these calculations for a mass of 44.3 Fg (i.e. 26th point).

```@example DT
using ACS

split = 26

RSS_l = sum((data[1:split,"Signal "] .- mean(data[1:split,"Signal "])).^2) 

RSS_r = sum((data[split:end,"Signal "] .- mean(data[split:end,"Signal "])).^2)

RSS = RSS_l + RSS_r


```

```@example DT
using ACS

scatter(data[!,"Conc"],data[!,"Signal "], label="data")
plot!([0,data[!,"Conc"][split]],[mean(data[1:split,"Signal "]),mean(data[1:split,"Signal "])],label="< 44.3")
plot!([data[!,"Conc"][split],90],[mean(data[split:end,"Signal "]),mean(data[split:end,"Signal "])],label="> 44.3")
xlabel!("Mass calibrant (Fg)")
ylabel!("Relative intensity (%)")


```
We can use the below for loop to calculate the *RSS* for all potential splitting points. 

!!! warning
    Please note that this code assumes that your data is sorted and thus it does not take into 
    account the actual injected masses (i.e. the independent variable). If you want a more generic
    solution, you need to take the independent variables into account when creating right and left sides!

```@example DT
using ACS

 
RSS = zeros(length(data[!,"Signal "]))
rss_l = zeros(length(data[!,"Signal "]))
rss_r = zeros(length(data[!,"Signal "]))

for i=1:length(data[!,"Signal "])
    rss_l[i] = sum((data[1:i,"Signal "] .- mean(data[1:i,"Signal "])).^2) 

    rss_r[i] = sum((data[i:end,"Signal "] .- mean(data[i:end,"Signal "])).^2)

    RSS[i] = rss_l[i] + rss_r[i]
end 


scatter(data[!,"Conc"],RSS, label="RSS",markersize = 5)
scatter!(data[!,"Conc"],rss_l, label="RSS left", markersize = 2)
scatter!(data[!,"Conc"],rss_r, label="RSS right", markersize = 2)
xlabel!("Mass of calibrant Fg")
ylabel!("RSS")

```
In the above plot we are able to clearly see both the splitting point and the contribution of each side (i.e. the left vs right RSS). For example for all the points with injection mass of < 17, the model prediction has little to no error in it whereas the model is not accurate at all for injection masses > 17. At the moment, our model has only one splitting point.

```@example DT
using ACS

split = 10

scatter(data[!,"Conc"],data[!,"Signal "], label="data")
plot!([0,data[!,"Conc"][split]],[mean(data[1:split,"Signal "]),mean(data[1:split,"Signal "])],label="< 17")
plot!([data[!,"Conc"][split],90],[mean(data[split:end,"Signal "]),mean(data[split:end,"Signal "])],label="> 17")
xlabel!("Mass calibrant (Fg)")
ylabel!("Relative intensity (%)")


```

After the first splitting, we need to decide whether each side require further splitting. If we look at the left side the value of 6 (i.e. the model prediction) is fairly accurate prediction. However, we can further split these measurements to get even more accurate estimations. This added accuracy also comes with a high potential for overfitting. There are several methods to assess the presence of overfitting in our model. These approaches include setting a depth limit, setting a minimum number of points to a leaf, [information gain](https://en.wikipedia.org/wiki/Kullback%E2%80%93Leibler_divergence), and [Gini impurity](https://en.wikipedia.org/wiki/Decision_tree_learning#Gini_impurity). Each of these approaches have their own advantages and disadvantages and you should decide the most adequate one, based on your knowledge of the data. 

!!! tip 
    The most intuitive approach to avoid overfitting in tree based models is to set a minimum number of points in terminal leafs. This implies that if there are less than the set value points in a leaf that leaf is considered terminal and will not be considered for further splitting. This number (i.e. the minimum points per leaf) can be estimated by looking at the distribution of your data. Typically, the highest levels of accuracy and robustness is achieved by using a number between 5 and 20 points per leaf. 


Now that the root of our **decision tree** is identified and we have decided that the left leaf is not going to be further split into more leafs, we need to improve our model for the right side of the splitting point. To do so, we can exclude the left leaf from our data and repeat the *RSS* calculations for the rest of the data. 

```@example DT
using ACS

conc_1 = data[11:end,"Conc"]
sig_1 = data[11:end,"Signal "]
 
RSS1 = zeros(length(conc_1))
rss_l1 = zeros(length(conc_1))
rss_r1 = zeros(length(conc_1))

for i=1:length(conc_1)
    rss_l1[i] = sum((sig_1[1:i] .- mean(sig_1[1:i])).^2) 

    rss_r1[i] = sum((sig_1[i:end] .- mean(sig_1[i:end])).^2)

    RSS1[i] = rss_l1[i] + rss_r1[i]
end 


scatter(data[11:end,"Conc"],RSS1, label="RSS",markersize = 5)
scatter!(data[11:end,"Conc"],rss_l1, label="RSS left", markersize = 2)
scatter!(data[11:end,"Conc"],rss_r1, label="RSS right", markersize = 2)
xlabel!("Mass of calibrant Fg")
ylabel!("RSS")

```

As you can clearly see from the above plot the measurements larger than 68 Fg are grouped together and since the number of points in that leaf is smaller or equal to the set limit of 10 points, thus this is our second leaf. Currently our model has three potential predictions depending on the provided mass of the injected calibrant. For the two edge leafs, our model does very well in terms of accuracy while for the center leaf further splitting is necessary. We can perform this by repeating the above steps.  

```@example DT
using ACS

split1 = 10
split2 = 40


scatter(data[!,"Conc"],data[!,"Signal "], label="data")
plot!([0,data[!,"Conc"][split1]],[mean(data[1:split1,"Signal "]),mean(data[1:split1,"Signal "])],label="< 17")

plot!([data[!,"Conc"][split1],data[!,"Conc"][split2]],[mean(data[split1:split2,"Signal "]),mean(data[split1:split2,"Signal "])],label="17 < x  < 68")

plot!([data[!,"Conc"][split2],90],[mean(data[split2:end,"Signal "]),mean(data[split2:end,"Signal "])],label="> 68")
xlabel!("Mass calibrant (Fg)")
ylabel!("Relative intensity (%)")


```

### Multivariate Case

So far we have only looked at a univariate case. For a system with multiple variables, the process is the same as the univariate one and it is performed over each variable separately and then the minimum *RSS* value by the splitting points are compared, the variable with the smallest *RSS* value will take precedent. For example in case of our dataset, now we can use both variables in our model. 

```@example DT
using ACS

scatter(data[!,"Conc"][data[!,"Mode"] .== 1],data[!,"Signal "][data[!,"Mode"] .== 1], label="Positive mode")
scatter!(data[!,"Conc"][data[!,"Mode"] .== -1],data[!,"Signal "][data[!,"Mode"] .== -1], label="Negative mode")
xlabel!("Mass calibrant (Fg)")
ylabel!("Relative intensity (%)")

```

In this case, the mass of the calibrant will still be the root node of our tree while the second node will be related to the acquisition mode.

## Random Forest

As it was mentioned above **random forest** was introduced as a means for overcoming the issues associated with the **decision trees** namely the lack of accuracy and robustness. The basic concept behind **random forest** is the use of multiple trees and the resampling strategies such as [bootstrapping](https://en.wikipedia.org/wiki/Bootstrapping_(statistics)). Here we first generate a large number of trees (e.g. hundreds) and with each of those trees we model a bootstrap sample of the original data. This implies that no two trees have the same dataset to model and our **random forest** model has as many prediction as the number of trees. At this point the **random forest** model tallies the distribution of the predictions and outputs the prediction with the highest likelihood (i.e. the most frequent prediction). This strategy, usually, results in a much more robust and accurate models, mitigating the limitations of **decision trees**. When building **random forest** models, one can decide how to distribute the data across the trees. For example, one of the most communly used approaches to build bootstrapping samples is [bagging](https://en.wikipedia.org/wiki/Bootstrap_aggregating), where not all the variables and the measurements are given to each tree. When performing **random forest** modeling, independently from the used package, there are three [hyperparameters](https://en.wikipedia.org/wiki/Hyperparameter_(machine_learning)) that must be optimized namely: the number of trees, the minimum points per leaf, and bootstrapping conditions. Each of these parameters have their own criterion for being optimized and thus they need to be considered all together. For example, we want to keep the number of trees to the minimum while having highest possible accuracy of the [cross validation](https://en.wikipedia.org/wiki/Cross-validation_(statistics)) and [test set](https://en.wikipedia.org/wiki/Training,_validation,_and_test_data_sets). One way to deal with this is to perform [grid search](https://scikit-learn.org/stable/modules/grid_search.html), which could be computationally expensive, depending on the resolution needed. 

!!! tip 
    For the number of trees usually you are looking for the optimized number between 100 and 500 trees. Please note this is highly case dependent and may not be correct for your specific dataset. For the bootstrapping parameter, in case of classification a square root of the number of variables and for regression 1/3 of the number of variable can be used as starting points. 

!!! tip 
    When building any type of model, you need to make sure that the variables are [scaled](https://en.wikipedia.org/wiki/Feature_scaling). Otherwise, the variable with the largest magnitude will dominate your model, even though, it may not be the most relevant variable to the model.

## Packages 

The package [ScikitLearn.jl](https://github.com/cstjean/ScikitLearn.jl) which is a julia wrapper of the [python package](https://scikit-learn.org/stable/index.html) provides access to a wide variety of **random forest** implementations. Below is an example of the usage case for a classification problem.

```julia 
using ACS

@sk_import ensemble: RandomForestClassifier

data = dataset("datasets", "iris")

y = data[!,"Species"]
Y = zeros(length(y))
Y[y .== "setosa"] .= 1
Y[y .== "versicolor"] .= 2
X = Matrix(data[:,1:4]); # The first four columns are selected for this

clf = RandomForestClassifier(n_estimators=200, min_samples_leaf=5,
oob_score =true, max_features= "auto",n_jobs=-1).fit(X,Y)
accuracy_cl = clf.score(X,Y)

```

!!! warning 
    Please note that the above implementation is not following the best practices for this type of modeling as the data is not split into training set and test set. Also, no cross-validation is performed. Finally none of the hyperparameters here have been optimized.  

## Additional Resources

There are several resources (including videos on YouTube) for better understanding how **decision trees** and **random forests** work. The documentation of [SKLearn package](https://scikit-learn.org/stable/index.html) is one of the best resources for this. Additionally, you can follow this lecture by [Kilian Weinberger](https://www.youtube.com/watch?v=4EOCQJgqAOY) from Cornell. 