"""
Purpose:
*.
"""
import numpy as np

from cgraph cimport GraphBase

cdef class DFS:

    def __cinit__(self, GraphBase graph not None, int start_node):
        self._graph = graph
        self._start_node = start_node
        self._pre = np.full(self.graph.length, -1, dtype=np.intc)
        self._st = np.full(self.graph.length, -1, dtype=np.intc)
        self._post = np.full(self.graph.length, -1, dtype=np.intc)
        self._lows = np.full(self.graph.length, -1, dtype=np.intc)
        self._cycle = np.full(self.graph.length, -1, dtype=np.intc)
        self._colour = np.full(self.graph.length, -1, dtype=np.intc)
        self._art = np.full(self.graph.length, -1, dtype=np.intc)
        self._bridges = np.full(self.graph.length, -1, dtype=np.intc)
        self._pre_counter = 0
        self._post_counter = 0
        self._edge_count = 0

    
