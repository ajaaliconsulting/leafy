# Leafy Graph Library
Leafy is a python graph library written in cython. This mix gives the speed of writing
the library in c with the benefit of python bindings.

## Usage

### Graph Objects
Leafy supports two types of graphs: Dense and Sparse. These are represented by the 
classes `leafy.graph.Graph` and `leafy.graph.SparseGraph`.

To instantiate a graph object we need to know the number of nodes (verticies) in the
graph, and if the graph is directed. Graphs defualt to undirected.

```python
>>> from leafy.graph import Graph
>>> g = Graph(4)
>>> g.add_edge(0, 1)
>>> g.add_edge(2, 3)
>>> g.add_edge(2, 1)
>>> g.matrix
array([[0, 1, 0, 0],
       [1, 0, 1, 0],
       [0, 1, 0, 1],
       [0, 0, 1, 0]], dtype=int32)
```

the same edges can be defined as a directed `SparseGraph`

```python
>>> from leafy.graph import SparseGraph
>>> g = SparseGraph(4, True)
>>> g.add_edge(0, 1)
>>> g.add_edge(2, 3)
>>> g.add_edge(2, 1)
>>> g.list
[[1], [], [3, 1], []]
```

### Search

Leafy can run Depth First Search (DFS) and Breadth First Search (BFS) on a graph and
return the graph search properties.

To run a search we need to define the graph to search and the node to start from.
Before you can view the properties we must call `.run()`.

```python
>>> from leafy.search import DFS
>>> graph = small_graph(request.param)
>>> dfs = DFS(graph, 0)
>>> dfs.run()
>>> dfs.simple_path(12)
[0, 1, 2, 11, 12]
>>> dfs.bridges
[(1, 3), (3, 4), (3, 5), (2, 11), (11, 12)]
```

### Digraphs

For diagraphs leafy supports DFS which can be imported from `leafy.digraph`

```python
>>> from leafy.digraph import DFS
>>> dag = small_dag()
>>> dfs = DFS(dag, 0)
>>> dfs.run()
>>> dfs.is_dag
True
>>> dfs.topological_order()
[0, 6, 2, 3, 5, 4, 9, 11, 12, 10, 1]
```
