from graph cimport GraphBase
from data_structure cimport AdjacencyList

cdef class DFS:
    cdef GraphBase _graph
    cdef int _start_node
    cdef int _sink_node
    cdef int [::1] _pre
    cdef int [::1] _st
    cdef int [::1] _post
    cdef int [::1] _lows
    cdef int [::1] _cycle
    cdef int [::1] _colour
    cdef int [::1] _art
    cdef int _pre_counter
    cdef int _post_counter
    cdef int _edge_count
    cdef bint _dfs_run
    cdef bint _bipirtite
    cdef AdjacencyList _bridges
    cdef AdjacencyList _tree_links
    cdef AdjacencyList _back_links
    cdef AdjacencyList _down_links
    cdef AdjacencyList _parent_links
    cpdef list simple_path(self, int sink_node)
    cpdef void run(self)
    cdef void _run(self, int node, int st, int colour)
