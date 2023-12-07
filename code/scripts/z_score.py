import networkx as nx
import numpy as np


def generate_null_model(bipartite_graph):
    """
    Generate a random graph with preserved degrees for a given bipartite graph.

    Parameters:
    - bipartite_graph (nx.Graph): The input bipartite graph.

    Returns:
    - nx.Graph: A random graph with preserved degrees for both bipartite sets.
    """
    # Get the degree sequences for both bipartite sets
    top_nodes, bottom_nodes = nx.bipartite.sets(bipartite_graph)

    top_degrees = bipartite_graph.degree(top_nodes)
    top_degrees = [degree for _, degree in top_degrees]

    bottom_degrees = bipartite_graph.degree(bottom_nodes)
    bottom_degrees = [degree for _, degree in bottom_degrees]

    # Generate a configuration model random graph
    return nx.bipartite.configuration_model(top_degrees, bottom_degrees)


def calculate_z_score(real_values, null_model_values):
    """
    Calculate z-scores for a set of real values with respect to a null model.

    Parameters:
    - real_values (numpy.ndarray): The real values to calculate z-scores for.
    - null_model_values (numpy.ndarray): Null model values for comparison.

    Returns:
    - numpy.ndarray: Z-scores for each element in real_values.
    """
    # Calculate means and standard deviations along each column (axis=0)
    means = np.mean(null_model_values, axis=0)
    stds = np.std(null_model_values, axis=0)

    # Avoid division by zero by replacing zero standard deviations with 1
    stds = np.where(stds == 0, 1, stds)

    # Calculate z-scores using the formula: (real_value - mean) / standard_deviation
    z_scores = (real_values - means) / stds

    return z_scores
