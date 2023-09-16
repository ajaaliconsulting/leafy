from .search cimport DFS as _DFS
from .data_structure cimport AdjacencyList

cdef class DFS(_DFS):
    cdef int *_cycle
    cdef int *_rts
    cdef AdjacencyList _cross_links


