import networkx as nx
import matplotlib.pyplot as plt
import numpy as np


def plotGraph(network):
    # Calculate Kamada-Kawai layout
    pos = nx.arf_layout(network)

    # Try different layouts

    # pos = nx.kamada_kawai_layout(network)
    # pos = nx.circular_layout(G)
    # pos = nx.random_layout(G)
    # pos = nx.spectral_layout(G)
    # pos = nx.shell_layout(G)
    # pos = nx.spring_layout(G)
    # pos = nx.fruchterman_reingold_layout(G)

    # Draw the bipartite graph
    plt.figure(figsize=(15, 10))  # Adjust the figure size

    num_rows = len(
        [node for node, data in network.nodes(data=True) if data["bipartite"] == 0]
    )
    nx.draw(
        network,
        pos,
        with_labels=False,
        font_weight="bold",
        node_size=70,  # Adjust the node size
        width=0.15,  # Adjust the edge width
        node_color=[
            "blue" if n in range(num_rows) else "lightcoral" for n in network.nodes
        ],
    )
    plt.show()


def plotBipartiteGraph(network):
    # Extract nodes from each partition
    nodes_A = [
        node for node, data in network.nodes(data=True) if data["bipartite"] == 0
    ]
    nodes_B = [
        node for node, data in network.nodes(data=True) if data["bipartite"] == 1
    ]

    # Bipartite layout
    pos = nx.bipartite_layout(network, nodes_A)

    plt.figure(figsize=(20, 20))
    # Draw nodes
    nx.draw_networkx_nodes(
        network,
        pos,
        nodelist=nodes_A,
        node_color="b",
        label="Partition A",
        node_size=10,
    )
    nx.draw_networkx_nodes(
        network,
        pos,
        nodelist=nodes_B,
        node_color="r",
        label="Partition B",
        node_size=10,
    )

    # Draw edges
    nx.draw_networkx_edges(network, pos, edgelist=network.edges)

    # Draw labels
    # nx.draw_networkx_labels(network, pos)

    # Display the plot
    plt.axis("off")
    plt.legend()
    plt.show()
    
    
# -------------------------- Community plots --------------------------

def top_common_entity(communities, adjacency_matrix, diseases_list, entity, top=20):
     """
     This function plots the top common diseases/symptoms in each community
     :param communities: list of communities
     :param adjacency_matrix: adjacency matrix
     :param diseases_list: list of diseases names
     :param entity: 'disease' or 'symptom'
     :param top: number of diseases/symptoms to plot
     :return: None
     """

     if entity == 'disease':
          adjacency_matrix = adjacency_matrix.T
     
     num_communities = len(communities)
     for i in range(num_communities):
          comm = [label for index, label in enumerate(communities[i])]
          adjacency_matrix_filtered = adjacency_matrix[:, comm]
          avg_num = adjacency_matrix_filtered.sum(axis=1).mean()
          num_for = adjacency_matrix_filtered.sum(axis=1)
          num_for_sorted = np.argsort(num_for)[::-1][:top]
          adjacency_matrix_ = adjacency_matrix_filtered[num_for_sorted, :]
          num_for_top = adjacency_matrix_.sum(axis=1)

          plotting_array = np.array([diseases_list[num_for_sorted], num_for_top])
          plt.bar(x=plotting_array[0], height=plotting_array[1])
          plt.plot(plotting_array[0], [avg_num] * len(num_for_top), color='red', label='Average')
          plt.xticks(rotation=90)
          
          if entity == 'symptom':
               plt.title(f'Number of symptoms for the top diseases in the community {i+1}')
               plt.ylabel('Number of symptoms')
               plt.xlabel('Diseases')
          else:
               plt.title(f'Number of diseases for the top symptoms in the community {i+1}')
               plt.ylabel('Number of diseases')
               plt.xlabel('Symptoms')
               
          plt.legend()
          #plt.tight_layout()
          plt.show()
