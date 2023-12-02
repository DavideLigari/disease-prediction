# Workflow 
The idea is to conduct a network analysis, defining metrics on nodes and identifying potential communities, with a dual objective. The first is to generate a useful descriptive analysis of the symptom-disease interaction. The second is to identify potential features to introduce into the predictive model to enhance its performance.

## 1. Read Research Papers about the Topic
Explore the literature:
  1) To have a complete and deep understanding of network theory and disease prediction
  2) To search for previous work regarding this topic, establishing a baseline to follow
  3) To have the means to explain the results obtained from the analysis of the network

## 1a. Possible Sources for Report:
    .. [1] Newman, M. E. J. "Networks: An Introduction", page 224
       Oxford University Press 2011.
    .. [2] Clauset, A., Newman, M. E., & Moore, C.
       "Finding community structure in very large networks."
       Physical Review E 70(6), 2004.
    .. [3] Reichardt and Bornholdt "Statistical Mechanics of Community
       Detection" Phys. Rev. E74, 2006.
    .. [4] Newman, M. E. J."Analysis of weighted networks"
       Physical Review E 70(5 Pt 2):056131, 2004.
    .. [1] ARF_layout "Self-Organization Applied to Dynamic Network Layout", M. Geipel,
       International Journal of Modern Physics C, 2007, Vol 18, No 10, pp. 1537-1549.
       https://doi.org/10.1142/S0129183107011558 https://arxiv.org/abs/0704.1748



## 2. Exploratory Data Analysis
### 2a. Dataset
Choose a dataset between:

smaller (5k lines):    https://www.kaggle.com/datasets/itachi9604/disease-symptom-description-dataset?select=Symptom-severity.csv

larger (250k lines):    https://www.kaggle.com/datasets/dhivyeshrk/diseases-and-symptoms-dataset?select=Final_Augmented_dataset_Diseases_and_Symptoms.csv

### 2b. Data cleaning
- Check number of distinct values
- Check Missing Values
- Switch to One Hot Encoding


## 3. Network analysis
Decide the network structure (e.g. bipartite, weighted...). Define useful metrics, test their statistical significance and analyze their results.
Identify different communities through clustering algorithms.

### 3a. Structure:

1. Bipartite network with 2 type of nodes (symptoms and disease)
2. Non-weighted links (either 0 or 1 in the adjacency matrix)
3. Structure investigation
4. Unipartite projections

### 3b. General network metrics

1. **Degree distribution**
P(k) = N(degree == k)/N
Plot for symptoms and for diseases in log scale P(k) versus k.
To fit a power law, use logarithmic binning.

2. **Clustering coefficient**
Interpretation for symptom nodes: it reflects whether certain symptoms tend to co-occur within multiple diseases.
Interpretation for disease nodes: it measures how connected diseases are in terms of their symptom overlap.

3. **Betweenness centrality**
High betweenness symptom nodes act as bridges connecting different diseases in the network.
Identifying hub diseases or symptoms can be relevant in the context of diagnosis.
Diseases that act as hubs may represent conditions with broad symptomatology, while symptoms that act as hubs may indicate manifestations that are commonly shared across multiple diseases.

### 3c. Node importance metrics:

1. **S1**: Symptom Occurrence. It's the degree of each symptom `s`. Computed as \[ \sum_{d} \text{nonzeroAdj}(s, d) \].

2. **S2**: Symptom Commonality: Measures if a symptom is present in diseases which are affected by many other symptoms or in disease which are affected by only few symptoms.

3. **D1**: Disease Occurrence.  It's the degree of each disease `d`. Computed as \[ \sum_{s} \text{nonzeroAdj}(s, d) \].

4. **D2**: Disease Commonality: Measures if a disease presents symptoms which affect many other diseases or symptoms which affect only few diseases.

#### Statistical Significance:

1. Create a configuration model to use as a null model. The configuration model is a random network that preserves the number of nodes, links, and the degree of each node (eg link swapping).
2. Compute the z-score of the S2 and D2 metrics to determine which observed structural properties are not simply explained by the constraint specifying the null model itself.

### 3d. Community Detection
[ChatGPT chat](https://chat.openai.com/share/d771039a-788d-4b0c-abaf-787d96d1b002)
  1) transform the adjacency matrix into a co-occurrence matrix disease-disease
  2) clustering algorithm
  3) check results using a modularity measure


## 4. Feature definition

Some of the metrics defined so far can be used as features for prediction in conjunction with symptom occurrence.

Features:
- Feature vector of symptoms
- Symptom occurrence
- Symptom commonality

Alternative features:
- Community clustering in place of the symptoms vector


## 5. Model creation
- Features Extraction (Andrea)
  
- Train, Test and Validation split (or crossvalidation)
  
- Models Fitting using 'greedy' approach based on severity/onehot features: (Cristian)
  - Logistic Regression
  - Random Forest
  - Multi Layer Perceptron

- Pick the best model and improve it using the other features: (Matteo)
  - Symptoms Commonality (S2)
  - Community Symptom Count
  - Community Symptom Size

  - Symptoms Degree (S1)
  - Symptoms Betweenness


## 6. Model's results visualization
- Confusion Matrix
- ROC Curve
- Precision Recall Curve
- Feature Importance
