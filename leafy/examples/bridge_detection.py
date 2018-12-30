"""
Purpose:
*.
"""
from leafy.graph import Graph, DFS

g = Graph()
g.add_edge(0, 5)
g.add_edge(0, 1)
g.add_edge(0, 6)
g.add_edge(1, 2)
g.add_edge(2, 6)
g.add_edge(3, 4)
g.add_edge(4, 9)
g.add_edge(4, 11)
g.add_edge(5, 4)
g.add_edge(5, 3)
g.add_edge(6, 7)
g.add_edge(7, 8)
g.add_edge(7, 10)
g.add_edge(8, 10)
g.add_edge(9, 11)
g.add_edge(11, 12)

dfs = DFS(g)
dfs.run(0)
dfs.pprint_dfs_results()