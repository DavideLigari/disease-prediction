# Workflow 
The idea is to conduct a network analysis, defining metrics on nodes and identifying potential communities, with a dual objective. The first is to generate a useful descriptive analysis of the symptom-disease interaction. The second is to identify potential features to introduce into the predictive model to enhance its performance.

## 1. Read Research Papers about the Topic
   Explore the literature to have a complete and deep understanding of network theory and disease prediction
   
## 2. Exploratory Data Analysis
### 2a. Dataset
Choose a dataset between:

smaller, faster:    https://www.kaggle.com/datasets/itachi9604/disease-symptom-description-dataset?select=Symptom-severity.csv

larger, cooler:    https://www.kaggle.com/datasets/dhivyeshrk/diseases-and-symptoms-dataset?select=Final_Augmented_dataset_Diseases_and_Symptoms.csv

### 2b. Analysis
- Structure investigation
- One Hot Encoding (if needed)
- Check Missing Values
- Check number of distinct values
- Train, Test and Validation split
- Symptoms distribution for each disease

## 3. Network analysis
Decide the network structure (e.g. bipartite, weighted...). Define useful metrics, test their statistical significance and analyze their results.
Retrieve communities.

### 3a. Structure:

1. Bipartite network with 2 type of nodes (symptoms and disease)
2. Non-weighted links (either 0 or 1 in the adjacency matrix)

### 3b. Node importance metrics:

#### For Symptoms:

1. **S1**: Symptom Occurrence. It's the degree of each symptom `s`. Computed as \[ \sum_{d} \text{nonzeroAdj}(s, d) \].

2. **S2**: Symptom Commonality: Measures if a symptom is present in diseases which are affected by many other symptoms or in disease which are affected by only few symptoms.

#### For Diseases:

3. **Strength D1**: Disease Occurrence.  It's the degree of each disease `d`. Computed as \[ \sum_{s} \text{nonzeroAdj}(s, d) \].

4. **D2**: Disease Commonality: Measures if a disease presents symptoms which affect many other diseases or symptoms which affect only few diseases.

### 3c. General metrics

1. **Clustering coefficient**
2. **Assortativity**
3. **Betweenness centrality**



### 3d. Analyze metrics

- Plot weight distribution
- Analyze correlation between degrees and strengths (S1 - S1 | D1 - D1) --> Beta coefficient
- Analyze correlation of weights of two nodes and their degrees --> Theta coefficient

- Clustering coefficient comparison (weighted vs unweighted)
- Assortativity comparison (weighted vs unweighted)

- Power Law distribution (Log-Log)
- Z-score

### 3e. Community Detection
1) transform the adjacency matrix into a co-occurrence matrix disease-disease
2) clustering algorithm
3) check results using a modularity measure

   - Identify possible communities and similarities between diseases, this information could be useful in prediction explanation. 
   - Communities could have significant predictive properties. See [ChatGPT chat](https://chat.openai.com/share/d771039a-788d-4b0c-abaf-787d96d1b002)
   - Modularity can be used to asses soundness and compare different partitions

#### - Statistical Significance

Create a null model: use a configuration model, which is a random network that preserves the nummber of nodes, links, and the degree of each node (eg link swapping)
Compute the z-score of the S2 and D2 metrics.

## 4. Data cleaning

Remove outliers and fix invalid values.


## 5. Feature definition

Some of the metrics defined so far can be used as features for prediction in conjunction with symmptom occurrence.

Features:
    -Feature vector of symptoms (one-hot encoding)
    -Symptom occurrence
    -Symptom commonality
Alternative features:
    -Community clustering in place of the symptoms vector

## 6. Model creation

Create a neural network which predicts the disease

## 7. Comparison between models

Compare model with network features and the model without them. 
In particular, compare the model using the one-hot encoding of the symptoms against the network leveraging the spatial reduction given by the community clustering.
