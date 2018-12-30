
from leafy.graph import Graph, DFS

graph = Graph()
graph.add_edge("A", "B")
graph.add_edge("A", "C")
graph.add_edge("B", "D")
graph.add_edge("C", "E")

# Run DFS
dfs = DFS(graph)
dfs.run("D")
dfs.pprint_dfs_results()

# Find a simple path
p = dfs.simple_path('D', 'E')
print("Path D-E:", p)


