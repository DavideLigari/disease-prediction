# Workflow 
The idea is to conduct a network analysis, defining metrics on nodes and identifying potential communities, with a dual objective. The first is to generate a useful descriptive analysis of the symptom-disease interaction. The second is to identify potential features to introduce into the predictive model to enhance its performance.

## 1. Read Research Papers about the Topic
   Explore the literature to have a complete and deep understanding of network theory and disease prediction
   
## 2. Exploratory Data Analysis
### 2a. Dataset
Choose a dataset between:

smaller:    https://www.kaggle.com/datasets/itachi9604/disease-symptom-description-dataset?select=Symptom-severity.csv

larger, but artificially generated:    https://www.kaggle.com/datasets/dhivyeshrk/diseases-and-symptoms-dataset?select=Final_Augmented_dataset_Diseases_and_Symptoms.csv

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
2. Weighted links (occurrence of a symptom in the disease: from 0 to 1 or just in absolute value)

### 3b. Node importance metrics:

1. **Degree SS1**: Symptom Specificity. For each `s`, calculate the sum over `d` of all non-zero entries in the adjacency matrix, represented as
   \[ \sum_{d} \text{nonzeroAdj}(s, d) \]. The lower the value, the higher the specificity.

2. **Strength SO1**: Symptom Occurrence. For each `s` sum all the weights over `d`. Computed as \[ \sum_{d} \text{nonzeroAdj}(s, d) \].

3. **SC2**: Symptom Commonality: Measures if a symptom is present in diseases which are affected by many other symptoms or in disease which are affected by only few symptoms.


4. **Degree DS1**: Disease Specificity. For each `d`, calculate the sum over `s` of all non-zero entries in the adjacency matrix, represented as
   \[ \sum_{s} \text{nonzeroAdj}(s, d) \]. The lower the value, the higher the specificity.

5. **Strength DO1**: Disease Occurrence. For each `d` sum all the weights over `s`. It tells how many times a disease occurs across the dataset. Computed as \[ \sum_{s} \text{nonzeroAdj}(s, d) \].

6. **DC2**: Disease Commonality: Measures if a disease presents symptoms which affect many other diseases or symptoms which affect only few diseases.

   #### - Statistical Significance

   Null Model with Random Network?

### 3c. General metrics

1. **Clustering coefficient**
2. **Assortativity**
3. **Betweenness centrality**

### 3d. Analyze metrics

- Plot weight distribution
- Analyze correlation between degrees and strengths (SS1 - S01 | DS1 - DO1) --> Beta coefficient
- Analyze correlation of weights of two nodes and their degrees --> Theta coefficient

- Clustering coefficient comparison (weighted vs unweighted)
- Assortativity comparison (weighted vs unweighted)

- Power Law distribution (Log-Log)
- Z-score

### 3e. Community Detection

   - Identify possible communities and similarities between diseases, this information could be useful in prediction explanation. 
   - Communities could have significant predictive properties. See [ChatGPT chat](https://chat.openai.com/share/d771039a-788d-4b0c-abaf-787d96d1b002)
   - Modularity can be used to asses soundness and compare different partitions

## 4. Data cleaning

Remove outliers and fix invalid values.


## 5. Feature definition

Define which features will be used to make predictions.
Network features

## 6. Model creation

Train different model with different parameters to find the best one

## 7. Comparison between models

Compare model with network features and the model without them.
