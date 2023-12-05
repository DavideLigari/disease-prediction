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
    .. [1] Unbalanced Data [Kaggle](https://www.kaggle.com/code/klospascal/under-oversampling-recall-and-precision)
    .. [1] Over and Under Sampling [Kaggle](https://www.kaggle.com/code/residentmario/undersampling-and-oversampling-imbalanced-data/notebook)
    .. [1] Clutsering "Latapy, Matthieu, Clémence Magnien, and Nathalie Del Vecchio (2008).
        Basic notions for the analysis of large two-mode networks.
        Social Networks 30(1), 31--48".



## 2. Exploratory Data Analysis
### 2a. Dataset
Choose a dataset between:

smaller (5k lines):    https://www.kaggle.com/datasets/itachi9604/disease-symptom-description-dataset?select=Symptom-severity.csv

larger (250k lines):    https://www.kaggle.com/datasets/dhivyeshrk/diseases-and-symptoms-dataset?select=Final_Augmented_dataset_Diseases_and_Symptoms.csv

### 2b. Data cleaning
- Check number of distinct values
- Check Missing Values
- Switch to One Hot Encoding
- Deal with unbalanced classes
  - Remove classes with < 3 samples
  - Oversampling and Undersampling until 34 samples per class


## 3. Network creation and metrics
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


## 4. Network Analysis
#### 4a. Hidalgo Haussmann Metrics
Divide the ***symptoms*** nodes into 4 classes:
- **High L1 - High L2**: Symptoms with high degree and high L2. These symptoms are the less important for prediction since they contribute to many classes (diseases) and
  those classes are also connected to many other symptoms.
- **High L1 - Low L2**: Symptoms with high degree and low L2
- **Low L1 - High L2**: Symptoms with low degree and high L2
- **Low L1 - Low L2**: Symptoms with low degree and low L2. These symptoms are the most important for prediction since they contribute to few classes (diseases) and
  those classes are also connected to few other symptoms.

The division can be done using a threshold on the L1 and L2 metrics. An example are the quartiles of the L1 and L2 distributions or we can empirically choose other ones.
This approach considering both L1 and L2 should improve some problems of the L1 metric alone. For example, a symptom with High L1 (degree) may be considered as not important
since it is not enough discriminative. However, if the symptom is connected with diseases that have few symptoms, we risk to lose important information, also considering
that a model doesn't focus on a single symptom but on the combination of present symptoms.
This division can be used both for the **prediction** and for the **interpretation** of the results in the initial analysis section.

The same approach can be used for the ***diseases*** nodes. In this case the diseases of class 1 are the most challenging to predict since they are connected to many symptoms
and those symptoms are also connected to many other diseases. On the other hand, the diseases of class 4 are the easiest to predict since they are connected to few symptoms
and those symptoms are also connected to few other diseases.

#### 4b. Betweenness Centrality
From an informative point of view, the betweenness centrality provides a measure that embeds both the L1 and L2 metrics. Indeed, in our bipartite network, a symptom
is only connected to diseases and no interconnection between symptoms is possible. Therefore, the betweenness centrality of a symptom measures how many shortest paths 
between any symptom and any disease pass through that symptom. Thereby a symptom which is connected to many diseases (L1) and those diseases are connected to few symptoms (L2), so that the symptom is the only path between those diseases, will have a high betweenness centrality. 

Under the diseases point of view, a disease node has high centrality if it is connected to many symptoms (L1) and those symptoms are connected to few diseases (L2), so that the disease is the only path between those symptoms.


## 5. Feature definition

Some of the metrics defined so far can be used as features for prediction in conjunction with symptom occurrence.

Features:
- Feature vector of symptoms
- Symptom occurrence
- Symptom commonality

Alternative features:
- Community clustering in place of the symptoms vector


## 6. Model creation
- Features Extraction (Andrea)
  
- Train, Test and Validation split (or crossvalidation)
  
- Models to test
  - Logistic Regression
  - Random Forest
  - Multi Layer Perceptron

- select best parameters for symptoms one hot only
  - select best parameters for combination of other features (best combination is chosen with random parameters looking at the accuracy)
  - train for each model the two version above with optimal parameters
  - pick the best model according to accuracy


## 7. Model's results visualization
- Confusion Matrix (data divided in 4 classes according to the values of L1 and L2)
- ROC PR Curve
- Feature Importance
- Compare model with only symptoms and one with combination of other features
- Compare computational complexity
