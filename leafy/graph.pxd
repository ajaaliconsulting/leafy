from .data_structure cimport AdjacencyList, ArrayIter, LinkedListIter, ArrayIndexIter

cdef class GraphBase:
    cdef readonly int length
    cdef readonly int edge_count
    cdef bint directed
    cdef bint dense
    cdef int *_in_degrees
    cdef int *_out_degrees
    cpdef void add_edge(self, int v, int w, double weight=*)
    cdef ArrayIndexIter sources(self)
    cdef ArrayIndexIter sinks(self)
    cpdef double edge_weight(self, int v, int w)


cdef class Graph(GraphBase):
    cdef double** adj_matrix
    cpdef ArrayIter nodeiter(self, int node)


cdef class SparseGraph(GraphBase):
    cdef readonly AdjacencyList adj_list
    cpdef LinkedListIter nodeiter(self, int node)
