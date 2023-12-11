import os
import sys
sys.path.append("./code")

from sklearn.preprocessing import MaxAbsScaler
from sklearn.model_selection import GridSearchCV
import numpy as np
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, classification_report
from scripts.sampling import balanceSampling
from scripts.features_extraction import load_features
import scripts.logger as log
import time
import joblib as joblib

start_time = time.time()

# Load data from .npz file
# names = ["symptoms"]
names = ["betweenness", "community_count", "community_size"]
features, labels = load_features(names, path= "code/prediction_model/features/")

features, labels = balanceSampling(features, labels)
log.simple_logger(f'Features size: {features.shape}')
log.simple_logger(f'Labels size: {labels.shape}')

# Split the data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(features, labels, test_size=0.2, random_state=42)

# Perform MaxAbsScaler normalization
scaler = MaxAbsScaler()
X_train = scaler.fit_transform(X_train)
X_test = scaler.transform(X_test)

# np.savez_compressed("../prediction_model/features/LR_classic_full_data", Xtest=X_test, Xtrain=X_train, Ytest=y_test, Ytrain=y_train)
#np.savez_compressed("prediction_model/features/LR_mix_full_data", Xtest=X_test, Xtrain=X_train, Ytest=y_test, Ytrain=y_train)

# Define the parameter grid to search for Logistic Regression
param_grid = {
    'C': [10],
    'max_iter': [1000],
    'penalty': ['l2'],
    'solver' : ['lbfgs'],
}

# 'solver' : [ , 'newton-cholesky', 'sag', 'saga'],
# 'penalty': ['l1','l2', 'elasticnet', None],

# Create a Logistic Regression classifier
logreg = LogisticRegression(random_state=42, verbose=3)

# Create the GridSearchCV object
grid_search = GridSearchCV(logreg, param_grid, cv=3, verbose=3, scoring='accuracy', n_jobs=-1)

# Fit the GridSearchCV object to the data
grid_search.fit(X_train, y_train)

# Get the best parameters and the corresponding model
best_params = grid_search.best_params_
best_model = grid_search.best_estimator_

print(best_model.get_params())
all_params = best_model.get_params()
# Print the parameters
for param, value in all_params.items():
    log.simple_logger(f'{param}: {value}')
print(best_model.n_iter_)

# Make predictions on the test set using the best model
predictions = best_model.predict(X_test)

# Evaluate the best model
accuracy = accuracy_score(y_test, predictions)
report = classification_report(y_test, predictions)

print('Best Parameters:', best_params)
print(f'Best Model Accuracy: {accuracy}')
# print('Classification Report:\n', report)

log.simple_logger(f'Accuracy: {accuracy}')

end_time = time.time()
execution_time = end_time - start_time

# Convert seconds to hours, minutes, and seconds
hours, remainder = divmod(execution_time, 3600)
minutes, seconds = divmod(remainder, 60)

# Format the execution time
formatted_execution_time = f'{int(hours):02}:{int(minutes):02}:{seconds:.4f}'

log.simple_logger(f'The code took {formatted_execution_time} seconds to execute.')
log.simple_logger("\n\n")



# Specify the current working directory and relative directory
current_directory = os.getcwd()
relative_save_directory = 'models'

# Create the absolute path for the directory
absolute_save_directory = os.path.join(current_directory, relative_save_directory)

# Ensure the directory exists, creating it if necessary
os.makedirs(absolute_save_directory, exist_ok=True)

# Specify the filename for the logistic regression model
# logistic_regression_model_filename = 'lLR_classic_full_data.joblib'
logistic_regression_model_filename = 'LR_mix_full_data.joblib'

# Create the absolute path for the file
logistic_regression_model_path = os.path.join(absolute_save_directory, logistic_regression_model_filename)

# Save the logistic regression model
joblib.dump(best_model, logistic_regression_model_path)

