import networkx as nx
import matplotlib.pyplot as plt

def plotGraph(network):
    # Calculate Kamada-Kawai layout
    pos = nx.kamada_kawai_layout(network)

    # Try different layouts

    # pos = nx.circular_layout(G)
    # pos = nx.random_layout(G)
    # pos = nx.spectral_layout(G)
    # pos = nx.shell_layout(G)
    # pos = nx.spring_layout(G)
    # pos = nx.fruchterman_reingold_layout(G)

    # Draw the bipartite graph
    plt.figure(figsize=(15, 10))  # Adjust the figure size

    num_rows = len([node for node, data in network.nodes(data=True) if data['bipartite'] == 0])
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
    nodes_A = [node for node, data in network.nodes(data=True) if data['bipartite'] == 0]
    nodes_B = [node for node, data in network.nodes(data=True) if data['bipartite'] == 1]

    # Bipartite layout
    pos = nx.bipartite_layout(network, nodes_A)

    plt.figure(figsize=(20, 20))
    # Draw nodes
    nx.draw_networkx_nodes(network, pos, nodelist=nodes_A, node_color='b', label='Partition A', node_size=10)
    nx.draw_networkx_nodes(network, pos, nodelist=nodes_B, node_color='r', label='Partition B', node_size=10)

    # Draw edges
    nx.draw_networkx_edges(network, pos, edgelist=network.edges)

    # Draw labels
    #nx.draw_networkx_labels(network, pos)

    # Display the plot
    plt.axis('off')
    plt.legend()
    plt.show()