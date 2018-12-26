"""
Purpose:
*.
"""
from leafy.graph import Graph

g = Graph()
g.add(0, [5, 1, 6])
g.add(1, [2])
g.add(2, [6])
g.add(3, [4])
g.add(4, [9, 11])
g.add(5, [4, 3])
g.add(6, [7])
g.add(7, [8, 10])
g.add(8, [10])
g.add(9, [11])
g.add(10)
g.add(11, [12])
g.add(12)

g.dfs(0)
g.pprint_dfs_results()