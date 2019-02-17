from data_structure cimport AdjacencyList

cdef class GraphBase:
    cdef readonly int length
    cdef readonly int edge_count
    cdef bint directed
    cdef bint dense
    cpdef void add_edge(self, int v, int w)


cdef class Graph(GraphBase):
    cdef readonly int[:,::1] adj_matrix


cdef class SparseGraph(GraphBase):
    cdef readonly AdjacencyList adj_list
