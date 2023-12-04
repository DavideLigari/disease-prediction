import numpy as np

def sampling(features, labels, sample_size, random_state=42):
    """
    Perform random sampling on the dataset.

    Parameters:
    - features: numpy array, input features
    - labels: numpy array, corresponding labels
    - sample_size: int, size of the sample to be generated
    - random_state: int, random seed for reproducibility

    Returns:
    - sampled_features: numpy array, sampled input features
    - sampled_labels: numpy array, corresponding sampled labels
    """
    # Set random seed for reproducibility
    np.random.seed(random_state)

    # Generate random indices for sampling
    indices = np.random.choice(len(features), size=sample_size, replace=False)

    # Perform sampling
    sampled_features = features[indices]
    sampled_labels = labels[indices]

    return sampled_features, sampled_labels