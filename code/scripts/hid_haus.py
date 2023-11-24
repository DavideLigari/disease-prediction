import numpy as np
from scipy.sparse import csr_matrix


def hid_hous(AdjMat_rist, nn):
    """
    Compute hidden nodes in a bipartite graph using the Householder method.

    Parameters:
    - AdjMat_rist (numpy.ndarray): Adjacency matrix of the bipartite graph.
    - nn (int): Number of hidden nodes to compute.

    Returns:
    - k_d (numpy.ndarray): N metrics for each row of the adjacency matrix.
    - k_s (numpy.ndarray): N metrics for each column of the adjacency matrix.
    """
    # Initialization
    k_d = np.zeros((AdjMat_rist.shape[0], nn))
    k_s = np.zeros((AdjMat_rist.shape[1], nn))

    for n in range(1, nn + 1):
        if n == 1:
            # For the first iteration, initialize hidden nodes based on sums of rows and columns
            k_d[:, n - 1] = np.sum(AdjMat_rist, axis=1)
            k_s[:, n - 1] = np.sum(AdjMat_rist, axis=0)
        else:
            # Compute intermediate variables for hidden nodes in row partition
            a1 = np.sum(
                AdjMat_rist * np.tile(k_s[:, n - 2].T, (AdjMat_rist.shape[0], 1)),
                axis=1,
            )
            b1 = 1.0 / k_d[:, 0]

            # Handle potential division by zero or NaN values
            b1[np.isinf(b1)] = 0
            b1[np.isnan(b1)] = 0
            b1 = csr_matrix(b1)

            # Compute intermediate variables for hidden nodes in column partition
            a2 = np.sum(
                AdjMat_rist * np.tile(k_d[:, n - 2].T, (AdjMat_rist.shape[1], 1)).T,
                axis=0,
            )
            a2 = a2.T
            b2 = 1.0 / k_s[:, 0]

            # Handle potential division by zero or NaN values
            b2[np.isinf(b2)] = 0
            b2[np.isnan(b2)] = 0
            b2 = csr_matrix(b2)

            # Compute hidden nodes using the Householder method
            k_d[:, n - 1] = b1.A * a1
            k_s[:, n - 1] = b2.A * a2

    return k_d, k_s
