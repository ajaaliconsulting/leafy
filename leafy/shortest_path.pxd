from .graph cimport Graph

cdef class Dijkstra:
    cdef Graph _graph
    cdef int _start_node
    cdef bint _dij_run
    cdef int *_st
    cdef double *_wt
    cpdef list path(self, int sink_node)
    cpdef double weight(self, int sink_node)
    cpdef void run(self)
    cdef void _run(self)