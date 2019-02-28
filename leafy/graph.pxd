from data_structure cimport AdjacencyList, MemoryViewArrayIter, LinkedListIter, MVAIndexIter

cdef class GraphBase:
    cdef readonly int length
    cdef readonly int edge_count
    cdef bint directed
    cdef bint dense
    cdef readonly int[::1] in_degrees
    cdef readonly int[::1] out_degrees
    cpdef void add_edge(self, int v, int w)
    cdef MVAIndexIter sources(self)
    cdef MVAIndexIter sinks(self)


cdef class Graph(GraphBase):
    cdef readonly int[:,::1] adj_matrix
    cpdef MemoryViewArrayIter nodeiter(self, int node)


cdef class SparseGraph(GraphBase):
    cdef readonly AdjacencyList adj_list
    cpdef LinkedListIter nodeiter(self, int node)
