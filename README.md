# Leafy Graph Library
Leafy is a python graph library written in cython. This mix gives the speed of writing
the library in c with the benefit of python bindings.

## Usage

### Graph Objects
Leafy supports Sparse Graphs, these create Adjacencey lists underneath.

To instantiate a graph object we need to know the number of nodes (verticies) in the
graph, and if the graph is directed. Graphs defualt to undirected.

```python
from leafy import Graph
g = Graph(4, True)
g.add_edge(0, 1)
g.add_edge(2, 3)
g.add_edge(2, 1)
g.list
```

### Search

Leafy can run Depth First Search (DFS) and Breadth First Search (BFS) on a graph and
return the graph search properties.

To run a search we need to define the graph to search and the node to start from.
Before you can view the properties we must call `.run()`.

```python
from leafy.search import DFS
dfs = DFS(g, 0)
dfs.run()
dfs.simple_path(12)
dfs.bridges
```

### Digraphs

For diagraphs leafy supports DFS which can be imported from `leafy.digraph`

```python
from leafy.digraph import DFS
dfs = DFS(g, 0)
dfs.run()
dfs.is_dag
dfs.topological_order()
```

### Shortest Distance

For network shortest path leafy supports single source Dijkstra which can be imported from `leafy.shortest_path`

```python
from leafy.shortest_path import Dijkstra
dij = Dijkstra(g, 0)
dij.run()
dij.path(3)
```
