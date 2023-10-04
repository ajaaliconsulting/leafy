from cpython.mem cimport PyMem_Free
cimport cython

from .data_structure cimport (
    AdjacencyList, LinkedListIter, array_index_iter, MAXWEIGHT, int1dim,
    int1dim_to_list
)

cdef class Graph:
    def __cinit__(self, int n, bint directed=0):
        """Graph structure for sparse graphs.

        Internally uses an array of linked lists to store the edges.
        This is more effiecient for sparse graphs as the full NxN matrix
        is not allocated at initialisation time

        Parameters
        ----------
        n : int
            The number of vectors in the graph
        directed : bool
            Defines if the graph has directed edges. Defaults to undirected.

        Examples
        --------
        >>> g = Graph(2)
        >>> g.add_edge(0, 1)
        >>> print(g.list)
        [[1],
        [0]]

        >>> d = Graph(2, True)
        >>> d.add_edge(0, 1)
        >>> print(g.list)
        [[1],
        []]
        """
        self.length = n
        self.directed = directed
        self.edge_count = 0
        self._in_degrees = int1dim(n, 0)
        self._out_degrees = int1dim(n, 0)
        self.dense = 0
        self.adj_list = AdjacencyList(n)

    def __dealloc__(self):
        PyMem_Free(self._in_degrees)
        PyMem_Free(self._out_degrees)

    @property
    def sources(self):
        """List of ints: All nodes which have an in-degree of zero."""
        return self.sources()

    @property
    def sinks(self):
        """List of ints: All nodes which have an out-degree of zero."""
        return self.sinks()

    cdef ArrayIndexIter sources(self):
        return array_index_iter(self._in_degrees, self.length, 0)

    cdef ArrayIndexIter sinks(self):
        return array_index_iter(self._out_degrees, self.length, 0)

    @property
    def in_degrees(self):
        return int1dim_to_list(self.length, self._in_degrees)

    @property
    def out_degrees(self):
        return int1dim_to_list(self.length, self._out_degrees)

    @property
    def list(self):
        """Get a python list representation of the graph adjacency list."""
        return self.adj_list.as_py_list()

    cpdef void add_edge(self, int v, int w, double weight=1.0):
        """Add an edge between the vectors v and w.

        Parameters
        ----------
        v : int
            index of vector v
        w : int
            index of vector w
        weight: float
            The weight associated to the added edge, defaults to 1.
        """
        self.edge_count += 1
        self._out_degrees[v] +=1
        self._in_degrees[w] +=1
        self.adj_list.append(v, w, weight)
        if not self.directed:
            self.edge_count += 1
            self._out_degrees[w] +=1
            self._in_degrees[v] +=1
            self.adj_list.append(w, v, weight)

    cdef LinkedListIter nodeiter(self, int node):
        return self.adj_list.listiter(node)

    cpdef LinkedListIter py_nodeiter(self, int node):
        return self.adj_list.listiter(node)

    cpdef double edge_weight(self, int v, int w):
        for i, weight in self.adj_list.listiter(v):
            if i == w:
                return weight
        return MAXWEIGHT