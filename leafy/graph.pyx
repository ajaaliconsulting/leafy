import numpy as np
cimport numpy as np
cimport cython

from data_structure cimport AdjacencyList, MemoryViewArrayIter, LinkedListIter

cdef class GraphBase:
    cpdef void add_edge(self, int v, int w):
        return


cdef class Graph(GraphBase):
    def __cinit__(self, int n, bint directed=0):
        """Graph structure for dense graphs.

        Internally uses a matrix to store the edges.  This is more efficient for dense graphs.
        We allocate the NxN matrix of ints at initalisation time.

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
        >>> print(g.matrix)
        [[0, 1],
         [1, 0]]
        >>> d = Graph(2, True)
        >>> d.add_edge(0, 1)
        >>> print(d.matrix)
        [[0, 1],
         [0, 0]]
        """
        self.dense = 1
        self.length = n
        self.directed = directed
        self.edge_count = 0
        self.adj_matrix = np.zeros((n, n), dtype=np.intc)

    @property
    def matrix(self):
        """Get a numpy ndarray of the graph adjacency matrix."""
        return np.asarray(self.adj_matrix)

    cpdef void add_edge(self, int v, int w):
        """Add an edge between the vectors v and w.
        
        Parameters
        ----------
        v : int
            index of vector v
        w : int
            index of vector w
        """
        self.edge_count += 1
        self.adj_matrix[v][w] = 1
        if not self.directed:
            self.edge_count += 1
            self.adj_matrix[w][v] = 1

    @cython.boundscheck(False)
    @cython.initializedcheck(False)
    @cython.wraparound(False)
    cpdef MemoryViewArrayIter nodeiter(self, int node):
        """ArrayIter: Iterator object over the edges of a node."""
        return MemoryViewArrayIter(self.adj_matrix[node][:], self.length)


cdef class SparseGraph(GraphBase):
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
        self.dense = 0
        self.length = n
        self.directed = directed
        self.edge_count = 0
        self.adj_list = AdjacencyList(n)

    @property
    def list(self):
        """Get a python list representation of the graph adjacency list."""
        return self.adj_list.as_py_list()

    cpdef void add_edge(self, int v, int w):
        """Add an edge between the vectors v and w.
        
        Parameters
        ----------
        v : int
            index of vector v
        w : int
            index of vector w
        """
        self.edge_count += 1
        self.adj_list.append(v, w)
        if not self.directed:
            self.edge_count += 1
            self.adj_list.append(w, v)

    cpdef LinkedListIter nodeiter(self, int node):
        return self.adj_list.listiter(node)