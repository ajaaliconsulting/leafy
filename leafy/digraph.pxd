from search cimport DFS as _DFS
from data_structure cimport AdjacencyList

cdef class DFS(_DFS):
    cdef int [::1] _cycle
    cdef int [::1] _rts
    cdef AdjacencyList _cross_links
