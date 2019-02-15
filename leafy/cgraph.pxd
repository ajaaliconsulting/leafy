from data_structure cimport AdjacencyList

cdef class GraphBase:
    cdef readonly int length
    cdef bint directed
    cpdef void add_edge(self, int v, int w)


cdef class Graph(GraphBase):
    cdef int[:,::1] adj_matrix


cdef class SparseGraph(GraphBase):
    cdef AdjacencyList adj_list
