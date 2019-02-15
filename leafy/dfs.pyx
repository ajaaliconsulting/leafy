"""
Purpose:
*.
"""
import numpy as np

from cgraph cimport GraphBase
from data_structure cimport AdjacencyList

cdef class DFS:
    """Depth First Search of a graph starting from a defined node.

    Parameters
    ----------
    graph : GraphBase
        An instance of either Graph or SparseGraph.
    node : int
        The node index to start from.
    """

    def __cinit__(self, GraphBase graph not None, int start_node):
        assert -1 < start_node < graph.length

        self._graph = graph
        self._start_node = start_node

        self._pre = np.full(self._graph.length, -1, dtype=np.intc)
        self._st = np.full(self._graph.length, -1, dtype=np.intc)
        self._post = np.full(self._graph.length, -1, dtype=np.intc)
        self._lows = np.full(self._graph.length, -1, dtype=np.intc)
        self._cycle = np.full(self._graph.length, -1, dtype=np.intc)
        self._colour = np.full(self._graph.length, -1, dtype=np.intc)
        self._art = np.full(self._graph.length, -1, dtype=np.intc)
        self._bridges = np.full(self._graph.length, -1, dtype=np.intc)

        self._tree_links = AdjacencyList(self._graph.length)
        self._back_links = AdjacencyList(self._graph.length)
        self._down_links = AdjacencyList(self._graph.length)
        self._parent_links = AdjacencyList(self._graph.length)

        self._pre_counter = 0
        self._post_counter = 0
        self._edge_count = 0

    cpdef void run(self):
        return
        # self._run(self._start_node, -1, -1)

    cdef void _run_sparse(self, int v, int st, int colour):
        pass

    cdef void _run_dense(self, int v, int st, int colour):
        cdef int w
        #
        # self._st[v] = st
        # self._colour = colour
        # self._pre[v] = self._pre_counter
        # self._lows[v] = self._pre_counter
        # self._pre_counter += 1
        #
        # for w in range(self._graph.length):
        #     if self._graph.adj_matrix[v][w] != 0:
        #         continue
        #
        #     self._edge_count += 1
        #     if self._pre[w] == -1:
        #         self._tree_links
        #
        #
        #
        #
        # pass
