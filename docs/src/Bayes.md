# Bayesian Statistics  

## Introduction

[**Bayesian Statistics**](https://en.wikipedia.org/wiki/Bayesian_statistics) is a statistical approach based on the **Bayes Theorem**, where the probability of an event is expressed as the degree of belief. A major difference between **Bayesian Statistics** and the [**frequentist**](https://en.wikipedia.org/wiki/Frequentist_probability) approach is the inclusion of the prior knowledge of the system into the probability calculations. One of the main differences between **Bayesian Statistics** and conventional [**t-test**](https://en.wikipedia.org/wiki/Student%27s_t-test) or [**ANOVA**](https://en.wikipedia.org/wiki/Analysis_of_variance) is that the **Bayesian Statistics** considers the probability of both sides of the [null-hypothesis](https://en.wikipedia.org/wiki/Null_hypothesis). 

## Bayes Theorem 

In **Bayes Theorem** the probability of an even occurring is updated by the degree of belief (i.e. prior knowledge). The **Bayes Theorem** is mathematically express as follows: 

```math 

P(A \mid B) = \frac{P(B \mid A)P(A)}{P(B)}.

```

The term *``P(A \mid B)``* is the posterior probability of *A* given *B*, implying that *A* and *B* are true given that *B* is true. The second term in this formula is the conditional probability of *``P(B \mid A)``*. The term *P(A)* is defined as the *prior probability*, which enables the incorporation of prior knowledge into the probability distribution of even occurring. Finally, *P(B)* is the marginal probability, which is used as a normalizing factor in this equation and it must be > 0. To put these terms into context, let's look at the following example. 

There is a new test for the detection of a new variant of COVID-19. We want to calculate the probability of a person being actually sick given a positive test (i.e. the posterior probability *``P(A \mid B)``*). The conditional probability (*``P(B \mid A)``*) in this case is the rate of true positive for the test. In other words the percentage of sick people who tested positive. The prior probability (*P(A)*) in this case is the probability of people getting sick while the marginal probability (*P(B)*) is all people who test positive independently from their health status.   

### Bayes Formula

The derivation of **Bayes Theorem** is very simple and can be done with simple knowledge of probability and arithmetics. Let's first write the two conditional probabilities (i.e. the posterior and conditional probabilities) as functions of their [joint probabilities](https://en.wikipedia.org/wiki/Joint_probability_distribution). 

```math 

P(A \mid B) = \frac{P(A \cap B)}{P(B)} \\
P(B \mid A) = \frac{P(B \cap A)}{P(A)}

```
Given that ``P(A \cap B) = P(B \cap A)`` and is is unknown, one can solve the above equations as a function of this unknown joint probability. 

```math 

P(A \cap B) = P(A \mid B)P(B) \\
P(A \cap B) = P(B \mid A)P(A)

```

This means that the right sides of these equations can be assumed equal as the left sides are equal, thus: 

```math 

P(A \mid B)P(B) = P(B \mid A)P(A).

```
Now if we divide both sides of this equation by *P(B)*, we will end up with the **Bayes Theorem**.

```math 

P(A \mid B) = \frac{P(B \mid A)P(A)}{P(B)}.

```

## Practical Example

This is a very simple example where we work together to calculate the joint probabilities which are needed for the conditional probability calculations. 

We have a classroom with 40 students. We asked them to fill out a survey about whether they like football, rugby, or none of them. The results of our survey show that 30 students like football, 10 students like rugby, and 5 do not like these sports. As you can see, the total number of votes is larger than 40, implying that 5 students like both sports.  

```@example bayes
using ACS

plot([1,1],[1,6],label=false,color = :blue)
plot!([1,9],[1,1],label=false,color =:blue)
plot!([9,9],[1,6],label=false,color =:blue)
plot!([1,9],[6,6],label="All students",color =:blue)
plot!([3,3],[1,6],label=false,color =:red)
plot!([1,3],[3.5,3.5],label=false,color =:green)
plot!([3,5],[3.5,3.5],label=false,color =:orange)
plot!([5,5],[3.5,6],label=false,color =:orange)
annotate!(2,5,"Rugby Only")
annotate!(4,5,"Both")
annotate!(2,2,"None")
annotate!(6,2,"Football Only")

```

Now lets generate the associated [contingency table](https://en.wikipedia.org/wiki/Contingency_table) based on the survey results. Our table is a two by two one, given the number of questions asked. The contingency table will help us to calculate the joint probabilities. The structure of our table will be the following:

|    | Y Football | N Football|
|:--- | :---: | ---: |
|Y Rugby |    |      |
|N Rugby |    |      |

After filling the table with the correct frequencies, we will end up with the following: 

|    | Y Football | N Football|
|:--- | :---: | ---: |
|Y Rugby |  5  |   5   |
|N Rugby |  25  |   5   |

These numbers can also be expressed in terms of probabilities rather than frequencies. 

|    | Y Football | N Football|
|:--- | :---: | ---: |
|Y Rugby |  5/40 = 0.125  |   5/40 = 0.125   |
|N Rugby |  25/40 = 0.625  |   5/40 = 0.125   |

We can now further expand our table to include total cases of football and rugby fans amongst the students. 

|    | Y Football | N Football| Rugby total|
|:--- | :---: | :---: | ---: |
|Y Rugby |  5/40 = 0.125  |   5/40 = 0.125   | 10/40 = 0.25 |
|N Rugby |  25/40 = 0.625  |   5/40 = 0.125   | 30/40 = 0.75 |
Football total | 30/40 = 0.75 | 10/40 = 0.25 | |


We can use the same table for calculating conditional probabilities, for example *``P(A \mid B)``* or expanded to *``P(A \& B \mid B)``*. Let's remind ourselves the formula for this: 

```math 

P(A \mid B) = \frac{P(A \cap B)}{P(B)}.

```
For this example we want to calculate the probability of a student liking football given that they are carrying a rugby ball (i.e. they like rugby). So now we can write the above formula using the annotation related to this question. 

```math 

P(Football \& Rugby \mid Rugby) = \frac{P(Football \cap Rugby)}{P(Total Rugby)}.

```

Now we can plug in the numbers from our contingency table to calculate the needed probability. 

```math 

P(Football \& Rugby \mid Rugby) = \frac{0.125}{0.25} = 0.5

```

Another way to express these probabilities is using the [probability trees](https://www.mathsisfun.com/data/probability-tree-diagrams.html). Each branch in a tree represents one set of conditional probabilities.   


## Applications

**Bayesian Statistics** has several applications from [uncertainty assessment](https://en.wikipedia.org/wiki/Monte_Carlo_method) to [network analysis](https://en.wikipedia.org/wiki/Bayesian_network) as well as simple regression and classification. Here we will discuss  classification (i.e. [Naive Bayes](https://en.wikipedia.org/wiki/Naive_Bayes_classifier)), uncertainty assessment, and regression. 

### Naive Bayes

```@example bayes
using ACS 

x = [2.11170571
4.654611177
2.058684377
9.118890998
6.482271164
1.741767743
0.423550831
3.930361297
8.394899978
2.720184918
4.642679068
0.698396604
10.60195845
9.949609087
9.788688087
9.275078609
3.71104968
3.048191598
7.131314198
2.696493503]

histogram(x,bins=5,normalize=:probability)

```