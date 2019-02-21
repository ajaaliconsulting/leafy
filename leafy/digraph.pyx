cimport numpy
import numpy as np
cimport cython

from graph cimport GraphBase
from data_structure cimport AdjacencyList
from search cimport DFS as _DFS


cdef class DFS(_DFS):
    """Depth First Search of a digraph starting from a defined node.
    Apart from the properties for the undirected graph DFS, this gives the following:
    - Is it a DAG: Is the digraph clear of back links, therefore, it's a dag.
    - Topological sort: Sort the nodes in order of dependency from source to destination.
    - Reverse Topological sort: Sort the nodes in order of dependency from destination to source.

    Parameters
    ----------
    graph : GraphBase
        An instance of either Graph or SparseGraph.
    start_node : int
        The node index to start from.
    sink_node : int, optional
        The node to stop searching at.

    Examples
    --------
    Before you're able to interogate the graph structure you have to run the DFS.

    >>> g = Graph(200)
    >>> g.add(1, 0)
    >>> dfs = DFS(g, 0)
    >>> dfs.run()

    Once the algorithm has run you can ask the dfs for it's attributes:
    >>> dfs.bipirtite
    False

    """

    def __cinit__(self, GraphBase graph not None, int start_node, int sink_node=-1):
        self._rts = np.full(self._graph.length, -1, dtype=np.intc) # Reverse topological sort
        self._cycle = np.full(self._graph.length, -1, dtype=np.intc)
        self._cross_links = AdjacencyList(self._graph.length)

    @property
    def diagnostics(self):
        """dict of string to lists of ints: DFS internal indexing by metric."""
        diag = super().diagnostics
        diag['art'] = list(self._art)
        return diag

    @property
    def cross_links(self):
        """dict of int to list of int: All the ancestor nodes visited for the from each node."""
        assert self._dfs_run != 0, "Run the DFS before calling results."
        return self._cross_links.as_py_pairs()

    @property
    def is_dag(self):
        """Bool: Is a diagraph a dag. Only valid for direcected graphs."""
        assert self._dfs_run != 0, "Run the DFS before calling results."
        return self._back_links.count == 0

    def topological_order(self):
        """Rearrange the nodes on a horizontal line such that all directed edges
        point from left to right.

        This returns the nodes in precedence order. origin first

        Returns
        -------
        Generator of ints
            The node indices topologically sorted.
        """
        assert self._dfs_run != 0, "Run the DFS before calling results."
        cdef int counter = self._graph.length
        while counter > 0:
            i = self._rts[counter-1]
            counter -= 1
            if i == -1:
                continue
            yield i

    def reverse_topological_order(self):
        """Rearrange the nodes on a horizontal line such that all directed edges point
        from right to left.

        This returns the nodes in reverse precedence order. dependent first.

        Returns
        -------
        Generator of ints
            The node indices reverse topologically sorted.
        """
        assert self._dfs_run != 0, "Run the DFS before calling results."
        for i in self._rts:
            if i == -1:
                continue
            yield i

    @cython.boundscheck(False)
    @cython.initializedcheck(False)
    @cython.wraparound(False)
    cdef void _run(self, int v, int st, int colour):
        if v == self._sink_node:
            return

        cdef int w

        self._st[v] = st
        self._colour[v] = colour
        self._pre[v] = self._pre_counter
        self._lows[v] = self._pre_counter
        self._pre_counter += 1

        for w in self._graph.nodeiter(v):
            self._edge_count += 1
            if self._pre[w] == -1:
                self._tree_links.append(v, w)
                self._run(w, v, abs(colour - 1))
                self._lows[v] = min(self._lows[v], self._lows[w])
                if self._lows[w] >= self._pre[v] and st != -1:
                    self._art[v] = 1
            else:
                if self._pre[v] < self._pre[w] and self._post[v] > self._post[w]:
                    self._down_links.append(v, w)
                elif self._pre[v] > self._pre[w] and self._post[v] < self._post[w]:
                    self._back_links.append(v, w)
                    if self._colour[v] == self._colour[w]:
                        self._bipirtite = 0
                    self._lows[v] = min(self._lows[v], self._pre[w])
                elif self._pre[v] > self._pre[w] and self._post[v] > self._post[w]:
                    self._cross_links.append(v, w)

        if self._pre[v] == 0 and self._tree_links.length(v) > 1:
            self._art[v] = 1

        if self._pre[v] == self._lows[v] and st != -1:
            self._bridges.append(st, v)

        self._post[v] = self._post_counter
        self._rts[self._post_counter] = v
        self._post_counter += 1