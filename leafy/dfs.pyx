"""
Purpose:
*.
"""
import numpy as np

from cgraph cimport GraphBase

cdef class DFS:
    """Depth First Search of a graph starting from a defined node.

    Parameters
    ----------
    graph : GraphBase
        An instance of either Graph or SparseGraph.
    node : int
        The node index to start the search from.
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
        self._pre_counter = 0
        self._post_counter = 0
        self._edge_count = 0

    cpdef void run(self):
        self._run(self._start_node, -1, -1)

    cdef void _run(self, int node, int st, int colour):
        pass
