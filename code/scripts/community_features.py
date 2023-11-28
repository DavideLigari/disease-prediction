import numpy as np
import matplotlib.pyplot as plt
import networkx as nx

def get_community_count(symptoms_onehot, communities):
    """
    This function takes as input a one hot vector with the symptoms and returns the number of symptoms for each community.

    Parameters:
    - symptoms_onehot (numpy.ndarray): One-hot encoded vector representing the presence of symptoms.
    - communities (list of lists): List of communities, where each community is represented as a list of indices.

    Returns:
    - numpy.ndarray: Vector representing the count of symptoms for each community.
    """

    # Initialize a vector to represent the communities
    comm_vector = np.zeros(len(communities))
    
    # Find the positions of ones in the symptoms_onehot vector
    symptom_pos = [i for i, val in enumerate(symptoms_onehot) if val == 1]
    
    # Iterate over the positions of ones in the symptoms_onehot vector
    for i in symptom_pos:
        # Iterate over the communities
        for j, community in enumerate(communities):
            # Check if the position is in the current community
            if i in community:
                # Increment the corresponding element in the comm_vector
                comm_vector[j] += 1
    
    # Return the resulting community vector
    return comm_vector


def get_community_size(symptoms_onehot, communities):
	"""
	This function takes as input a one hot vector with the symptoms and returns a vector in which each element represents the size of the corresponding community.
 
	Parameters:
	- symptoms_onehot (numpy.ndarray): One-hot encoded vector representing the presence of symptoms.
	- communities (list of lists): List of communities, where each community is represented as a list of indices.
 
	Returns:
	- numpy.ndarray: Vector having size as symptoms_onehot.shape[1] and each element represents the size of the corresponding community.
	"""
	# Initialize a vector to represent the communities
	comm_size_vector = np.zeros(symptoms_onehot.shape)
 
	# Find the positions of ones in the symptoms_onehot vector
	symptom_pos = [i for i, val in enumerate(symptoms_onehot) if val == 1]
	
	# Iterate over the positions of ones in the symptoms_onehot vector
	for i in symptom_pos:
		# Iterate over the communities
		for j, community in enumerate(communities):
			# Check if the position is in the current community
			if i in community:
				# Increment the corresponding element in the comm_vector
				comm_size_vector[i] = len(community)
	# Return the resulting community vector
	return comm_size_vector


# function to plot graph with node colouring based on communities
def visualize_communities(graph, communities, i):
    """
    Visualize communities in a graph using networkx.

    Parameters:
    - graph (networkx.Graph): The graph to visualize.
    - communities (list of lists): List of communities, where each community is represented as a list of node indices.
    - i (int): Index for subplot placement.

    Returns:
    - None
    """
    
    # Create node colors based on communities
    node_colors = create_community_node_colors(graph, communities)
    
    # Calculate modularity of the communities
    modularity = round(nx.community.modularity(graph, communities), 6)
    
    # Set up plot title
    title = f"Community Visualization of {len(communities)} communities with modularity of {modularity}"
    
    # Define node positions using spring layout
    pos = nx.spring_layout(graph, k=0.3, iterations=50, seed=2)
    
    # Create subplot
    plt.subplot(3, 1, i)
    
    # Set subplot title
    plt.title(title)
    
    # Draw the graph with community colors
    nx.draw(
        graph,
        pos=pos,
        node_size=70,
        node_color=node_colors,
        with_labels=False,
        font_size=20,
        font_color="black",
        width=0.15,
    )


def create_community_node_colors(graph, communities):
    """
    Create a list of node colors based on communities for visualization.

    Parameters:
    - graph (networkx.Graph): The graph for which node colors are generated.
    - communities (list of lists): List of communities, where each community is represented as a list of node indices.

    Returns:
    - list: List of node colors for visualization.
    """
    number_of_colors = len(graph.nodes)
    cmap = plt.get_cmap('Paired') 
    colors = [cmap(i) for i in np.linspace(0, 1, number_of_colors)]
    node_colors = []

    # Iterate over nodes in the graph
    for node in graph:
        current_community_index = 0

        # Iterate over communities
        for community in communities:
            # Check if the node belongs to the current community
            if node in community:
                # Append the color corresponding to the current community
                node_colors.append(colors[current_community_index])
                break

            current_community_index += 1

    return node_colors