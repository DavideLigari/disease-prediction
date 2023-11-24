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
