import networkx as nx


def get_graph(adjacency_matrix):
    """
    Create a bipartite graph from an adjacency matrix.
    :param adjacency_matrix: The adjacency matrix of the bipartite graph.
    :return: A bipartite graph.
    """

    # Create a bipartite graph
    G = nx.Graph()
    num_rows, num_cols = adjacency_matrix.shape

    G.add_nodes_from(range(num_rows), bipartite=0)  # Nodes in the first partition
    G.add_nodes_from(
        range(num_rows, num_rows + num_cols), bipartite=1
    )  # Nodes in the second partition

    # Add edges to the graph based on the adjacency matrix
    for i in range(num_rows):
        for j in range(num_cols):
            if adjacency_matrix[i, j] == 1:
                G.add_edge(i, num_rows + j)

    return G


def get_weighted_graph(co_occurrence_matrix):
    """
    Create a weighted graph from a co-occurrence matrix.
    :param co_occurrence_matrix: The co-occurrence matrix of the weighted graph.
    :return: A weighted graph.
    """
    
    # Create a weighted graph directly
    G = nx.Graph()

    # Add nodes to the graph
    num_nodes = co_occurrence_matrix.shape[0]
    G.add_nodes_from(range(num_nodes))

    # Add weighted edges to the graph
    for i in range(num_nodes):
        for j in range(i+1, num_nodes):
            weight = co_occurrence_matrix[i, j]
            if weight != 0:
                G.add_edge(i, j, weight=weight)
    return G
