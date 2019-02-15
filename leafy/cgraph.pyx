import numpy as np
cimport numpy as np
from cpython.mem cimport PyMem_Malloc, PyMem_Free



cdef class GraphBase:
    cdef int vlength(self, int v):
        return 0

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
        self.adj_matrix = np.zeros((n, n), dtype=np.intc)
        self.directed = directed
        self.length = n

    @property
    def matrix(self):
        """Get a numpy ndarray of the graph adjacency matrix."""
        return np.asarray(self.adj_matrix)

    cdef int vlength(self, int v):
        """Get the length of the vector array"""
        return self.length

    cpdef void add_edge(self, int v, int w):
        """Add an edge between the vectors v and w.
        
        Parameters
        ----------
        v : int
            index of vector v
        w : int
            index of vector w
        """
        self.adj_matrix[v][w] = 1
        if not self.directed:
            self.adj_matrix[w][v] = 1


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
        self.length = n
        self.directed = directed
        self.adj_list = <link **> PyMem_Malloc(n * sizeof(link*))
        self.last_link = <link **> PyMem_Malloc(n * sizeof(link*))
        for i in range(self.length):
            self.adj_list[i] = self.last_link[i] = NULL

    def __dealloc__(self):
        cdef link *al
        cdef link *next_al
        for i in range(self.length):
            al = self.adj_list[i]
            while al is not NULL:
                next_al = al.next
                PyMem_Free(al)
                al = next_al

    @property
    def list(self):
        """Get a python list representation of the graph adjacency list."""
        return self._to_py_list()

    cdef int vlength(self, int v):
        """Get the length of the vector array"""
        return self.last_link[v].counter + 1

    cdef list _to_py_list(self):
        cdef link *al
        ret_list = []
        for i in range(self.length):
            i_list = []
            al = self.adj_list[i]
            while al is not NULL:
                i_list.append(al.val)
                al = al.next
            ret_list.append(i_list)
        return ret_list

    cdef void _add_edge(self, int v, int w):
        if self.adj_list[v] is NULL:
            self.adj_list[v] = create_link(w, NULL)
            self.last_link[v] = self.adj_list[v]
        else:
            self.last_link[v] = create_link(w, self.last_link[v])

    cpdef void add_edge(self, int v, int w):
        """Add an edge between the vectors v and w.
        
        Parameters
        ----------
        v : int
            index of vector v
        w : int
            index of vector w
        """
        self._add_edge(v, w)
        if not self.directed:
            self._add_edge(w, v)
