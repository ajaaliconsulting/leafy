from cpython.mem cimport PyMem_Free
cimport cython

from graph cimport GraphBase
from data_structure cimport (IndexHeapPriorityQueue, MAXWEIGHT, int1dim, double1dim,
int1dim_to_list, double1dim_to_list, heap_queue)


cdef class Dijkstra:
    """Dijkstra's shortest path algorithm.

    Shortest path algorithm to find the shortest path for weighted directed graphs (networks).
    By running this you'll find out:
    - The list of nodes that constitute the shortest path from a source to sink node.
    - The total weight of that path.

    Parameters
    ----------
    graph : GraphBase
        An instance of either Graph or SparseGraph.
    start_node : int
        The node index to start from.

    Examples
    --------
    Before you're able to interogate the graph structure you have to run the DFS.

    >>> g = Graph(200, True)
    >>> g.add(0, 1, 0.1)
    >>> g.add(1, 2, 0.2)
    >>> dij = Dijkstra(g, 0)
    >>> dij.run()

    Once the algorithm has run you can then query dij the shortest path:
    >>> dij.shotest_path(2)
    [0, 1, 2]

    >>> dij.total_weight(2)
    0.3

    """

    def __cinit__(self, GraphBase graph not None, int start_node):
        assert -1 < start_node < graph.length, "DFS start node must be on the graph."
        assert graph.directed == True

        self._graph = graph
        self._start_node = start_node
        self._dij_run = 0

        self._st = int1dim(self._graph.length, -1)  # Shortest path parent
        self._wt = double1dim(self._graph.length, MAXWEIGHT)  # Shortest path total wight

    def __dealloc__(self):
        PyMem_Free(self._st)
        PyMem_Free(self._wt)

    @property
    def diagnostics(self):
        """dict of string to lists of ints: DFS internal indexing by metric."""
        return {
            'st': int1dim_to_list(self._graph.length, self._st),
            'wt': double1dim_to_list(self._graph.length, self._wt)
        }

    cpdef list path(self, int sink_node):
        """List of nodes from sink node to start node constituting the shortest path"""
        assert self._dij_run == 1, "You need to run first."
        cdef int i = sink_node
        cdef list sp = []
        while self._st[i] != -1:
            sp.append(i)
            i = self._st[i]
        if i != self._start_node:
            return []
        sp.append(self._start_node)
        return sp

    cpdef double weight(self, int sink_node):
        """Total weight of the shortest path from start_node to sink_node"""
        assert self._dij_run == 1, "You need to run first."
        return self._wt[sink_node]

    cpdef void run(self):
        if self._dij_run == 0:
            self._dij_run = 1
            self._run()

    @cython.boundscheck(False)
    @cython.initializedcheck(False)
    @cython.wraparound(False)
    cdef void _run(self):
        self._wt[self._start_node] = 0.0
        cdef IndexHeapPriorityQueue pqueue = heap_queue(self._wt, self._graph.length, True)
        while pqueue.empty() == False:
            v = pqueue.get_next()
            if self._wt[v] != MAXWEIGHT:
                for i, weight in self._graph.nodeiter(v):
                    if (self._wt[v] + weight) < self._wt[i]:
                        self._wt[i] = self._wt[v] + weight
                        self._st[i] = v
                        pqueue.change(i)
