from .graph cimport Graph
from .data_structure cimport AdjacencyList

cdef class DFS:
    cdef Graph _graph
    cdef int _start_node
    cdef int _sink_node
    cdef int *_pre
    cdef int *_st
    cdef int *_post
    cdef int *_lows
    cdef int *_colour
    cdef int *_art
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


cdef class BFS:
    cdef Graph _graph
    cdef int _start_node
    cdef int _sink_node
    cdef int *_pre
    cdef int *_st
    cdef int _pre_counter
    cdef bint _bfs_run
    cdef int _edge_count
    cdef AdjacencyList _tree_links
    cdef AdjacencyList _back_links
    cdef AdjacencyList _down_links
    cdef AdjacencyList _parent_links
    cpdef list shortest_path(self, int sink_node)
    cpdef void run(self)
