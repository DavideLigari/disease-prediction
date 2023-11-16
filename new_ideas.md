## 1. Sickness Prediction


**Graph Representation:**
- Bi-partite graph with two types of nodes: symptoms and diseases. The edges between these nodes represent the association between a symptom and a disease. The weight of each edge indicates the strength of this association. The graph is weighted and directed, with edges pointing from symptoms to diseases.

**Goal of the Model:**
- The goal is to predict possible sickness or diseases based on a set of input symptoms. This can be approached as a classification problem where the model predicts the likelihood of a particular disease given the observed symptoms.

**Graph-Based Analysis:**
- The graph can be used to identify the most likely diseases given a set of symptoms. The model can use the graph to identify the most relevant symptoms and diseases based on their centrality measures. The model can also use the graph to identify the most likely diseases based on the symptoms that are observed in the patient.
- Communities in the graph can be used to identify groups of symptoms that are indicative of a particular disease.

**Possible Features:**
1. **Symptom-Sickness Associations:** Calculate the strength of association between input symptoms and diseases using the edges and weights in the graph. 
2. **Symptom Frequencies:** Consider the frequency of each symptom in the dataset to account for common symptoms that might be indicative of multiple diseases.
3. **Symptom Co-occurrence Patterns:** Examine the co-occurrence patterns of symptoms in the dataset. Certain symptoms tend to occur together, which can help the model make more accurate predictions.
4. **Graph-Based Centrality Measures:** Degree centrality as Prior. Closeness centrality to determine the significance of diseases in the graph and their proximity to input symptoms.
5. **Medical History:** Consider patients' medical history, age, gender, and other relevant factors that may influence disease likelihood.

**Possible Models:**
Addressing the task as a multi-class classification problem, we can use the following models:
1. **Logistic Regression:** A simple model that can be used as a baseline. It is interpretable and can be used to identify the most important features. Regularization term in the cross-entropy can be based on the graph-based centrality measures.
2. **Random Forest:** A more complex model that can capture non-linear relationships between features and the target variable. It can also be used to identify the most important features.
3. **Kernel-SVM**
4. **Bayesian Generative Models:** Naive Bayes, Gaussian Naive Bayes, Multinomial Naive Bayes, etc.

**Dataset:**
1. [Symptom-Disease Associations](https://www.kaggle.com/itachi9604/disease-symptom-description-dataset).
   There are columns containing diseases, their symptoms , precautions to be taken, and their weights.
   This dataset can be easily cleaned by using file handling in any language. The user only needs to understand how rows and columns are arranged. 
   License: CC BY-SA 4.0
`

2. [Disease Symptoms and Patient Profile Dataset](https://www.kaggle.com/datasets/uom190346a/disease-symptoms-and-patient-profile-dataset).
Data:
   - Disease: The name of the disease or medical condition.
   - Fever: Indicates whether the patient has a fever (Yes/No).
   - Cough: Indicates whether the patient has a cough (Yes/No).
   - Fatigue: Indicates whether the patient experiences fatigue (Yes/No).
   - Difficulty Breathing: Indicates whether the patient has difficulty breathing (Yes/No).
   - Age: The age of the patient in years.
   - Gender: The gender of the patient (Male/Female).
   - Blood Pressure: The blood pressure level of the patient (Normal/High).
   - Cholesterol Level: The cholesterol level of the patient (Normal/High).
   - Outcome Variable: The outcome variable indicating the result of the diagnosis or assessment for the specific disease (Positive/Negative).
License: CC0: Public Domain
`

3. [DDXPlus Dataset](https://figshare.com/articles/dataset/DDXPlus_Dataset/20043374).
   Large-scale synthetic dataset of roughly 1.3 million patients that includes a differential diagnosis, along with the ground truth pathology, symptoms and antecedents for each patient. Unlike existing datasets which only contain binary symptoms and antecedents, this dataset also contains categorical and multi-choice symptoms and antecedents useful for efficient data collection. Moreover, some symptoms are organized in a hierarchy, making it possible to design systems able to interact with patients in a logical way. 
   License: CC-BY.

   Related Paper [DDXPlus Dataset Paper](https://arxiv.org/pdf/2205.09148.pdf)

**Sources:**
1. [Predicting Diseases from Symptoms using Graph Neural Networks](https://arxiv.org/pdf/2010.15818.pdf)
2. [Disease Prediction with Machine Learning](https://ieeexplore.ieee.org/document/9753707)
3. [Disease Prediction with KNN](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3661426)

---

