import numpy as np
from imblearn.over_sampling import RandomOverSampler
from imblearn.under_sampling import RandomUnderSampler

def sampling(features, labels, sample_size=25000, random_state=42):
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


def balanceSampling(features, labels, threshold=35):
    """
    Oversample classes with fewer than 'target_samples_per_class' samples
    and undersample classes with more than 'target_samples_per_class' samples.

    Parameters:
    - features: Input features.
    - labels: Corresponding class labels.
    - target_samples_per_class: The target number of samples for each class.
    - random_state: Random seed for reproducibility.

    Returns:
    - Sampled features and labels.
    """

    # Over-sample
    original_samples_per_class = {label: np.sum(labels == label) for label in np.unique(labels)}
    sampling_strategy = {label: max(threshold, original_samples) for label, original_samples in original_samples_per_class.items()}
    ros = RandomOverSampler(random_state=42, sampling_strategy=sampling_strategy)
    oversampled_features, oversampled_labels = ros.fit_resample(features, labels)
    # Under-sample
    updated_samples_per_class = {label: np.sum(oversampled_labels == label) for label in np.unique(labels)}
    sampling_strategy = {label: min(threshold, original_samples) for label, original_samples in updated_samples_per_class.items()}
    rus = RandomUnderSampler(random_state=42, sampling_strategy=sampling_strategy)
    undersampled_features, labels = rus.fit_resample(oversampled_features, oversampled_labels)

    return undersampled_features, labels
