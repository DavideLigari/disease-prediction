import numpy as np
import pandas as pd

def get_x_y(to_be_transformed, data_onehot, store_path = None):
     
     """ 
     This function takes as input a list of values of same length as the number of columns of data_onehot.
     Where data_onehot is the matrix of the one-hot encoding of the dataset.
     It returns the data_onehot matrix with the values of the list in the columns where the value is 1.
     """
     
     features = []
     
     data_onehot = data_onehot.drop("Unnamed: 0", axis=1)
     data_onehot_y = data_onehot["Disease"].values
     data_onehot_x = data_onehot.drop("Disease", axis=1).values
     
     for i in range(data_onehot_x.shape[0]):
          tmp = [to_be_transformed[j] if data_onehot_x[i][j] == 1 else 0 for j in range(len(to_be_transformed))]
          features.append(tmp)
     data_onehot_features = np.vstack(features)
     
     if store_path:
          np.savez_compressed(store_path, X = data_onehot_features, y = data_onehot_y)
          
     return data_onehot_features, data_onehot_y
     

def load_features(names, path = "features/"):

     labels = np.load(path + names[0] + ".npz")['y']
     features = np.load(path + names[0] + ".npz")['X']
     for filename in names[1:]:
          file_path = path + filename + ".npz"
          data = np.load(file_path)
          feature_matrix = data['X']
          features = np.concatenate((features, feature_matrix), axis=1)

     return features, labels
