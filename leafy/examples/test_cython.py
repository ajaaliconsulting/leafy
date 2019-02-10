"""
Purpose:
*.
"""
from leafy.cgraph import Graph, SparseGraph

g = Graph(2)
g.add_edge(0, 1)
print(g.matrix)

d = Graph(2, True)
d.add_edge(0, 1)
print(d.matrix)

sg = SparseGraph(10)
sg.add_edge(0, 1)
sg.add_edge(0, 9)
sg.add_edge(1, 2)
sg.add_edge(1, 6)
sg.add_edge(4, 6)
sg.add_edge(4, 3)
print(sg.list)
