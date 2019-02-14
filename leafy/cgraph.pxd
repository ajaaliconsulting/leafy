
cdef class GraphBase:
    cdef int vlength(self, int v)


cdef class Graph(GraphBase):
    cdef int[:,::1] adj_matrix
    cdef bint directed
    cdef readonly int length
    cdef int vlength(self, int v)
    cpdef void add_edge(self, int v, int w)


cdef struct link:
    int val
    int counter
    link *next


cdef class SparseGraph(GraphBase):
    cdef link **adj_list
    cdef link **last_link
    cdef readonly int length
    cdef bint directed
    cdef int vlength(self, int v)
    cdef _to_py_list(self)
    cdef _add_edge(self, int v, int w)
    cpdef void add_edge(self, int v, int w)
