"""
Purpose:
*.
"""
from cgraph cimport GraphBase, Graph

cdef class DFS:
    cdef GraphBase graph

    def __cinit__(self, GraphBase graph not None):
        self.graph = graph
        print(self.something())

    cdef int something(self):
        return self.graph.vlength(1)
