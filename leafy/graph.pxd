from .data_structure cimport AdjacencyList, LinkedListIter, ArrayIndexIter

cdef class Graph:
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
    cdef readonly AdjacencyList adj_list
    cdef LinkedListIter nodeiter(self, int node)
    cpdef LinkedListIter py_nodeiter(self, int node)
