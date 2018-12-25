
from leafy.graph import Graph

graph = Graph()
graph.add("A", ['B', 'C'])
graph.add("B", ['D'])
graph.add("C", ['E'])
graph.add("D")
graph.add("E")

# Run DFS
graph.dfs('D')
graph.pprint_dfs_results()

# Find a simple path
p = graph.simple_path('D', 'E')
print("Path D-E:", p)

# Adding a cycle
graph.add_edge("E", 'A')
p = graph.simple_path('A', 'A')
print("Path A-A:", p)

