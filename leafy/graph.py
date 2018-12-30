"""
Purpose:
*.
"""
from collections import defaultdict
from queue import Queue

from tabulate import tabulate


class Graph:

    def __init__(self):
        self.edges = defaultdict(list)

    def add_edge(self, node_id_1, node_id_2):
        self.edges[node_id_1].append(node_id_2)
        self.edges[node_id_2].append(node_id_1)


class DFS:
    def __init__(self, graph):
        self._graph = graph
        self._index, self._ordered_nodes = self._get_ordered_nodes(graph)
        self._len = len(self._ordered_nodes)

        self._pre = [None] * self._len  # preordering index
        self._st = [None] * self._len  # structure index
        self._post = [None] * self._len  # postordering index
        self._lows = [None] * self._len  # lowest preordering index
        self._cycle = [None] * self._len
        self._colour = [None] * self._len
        self._pre_counter = 0
        self._post_counter = 0
        self._edge_count = 0
        self._tree_links = defaultdict(list)
        self._back_links = defaultdict(list)
        self._down_links = defaultdict(list)
        self._parent_links = defaultdict(list)

    def _get_ordered_nodes(self, graph):
        index = {}
        ordered_nodes = []
        for e, node in enumerate(graph.edges):
            index[node] = e
            ordered_nodes.append(node)
        return index, ordered_nodes

    def simple_path(self, to_node):
        idx_n2 = self._index[to_node]
        path = []
        st = self._st[idx_n2]
        path.append(idx_n2)
        while st is not None:
            path.append(st)
            st = self._st[st]

        return [self._ordered_nodes[p] for p in reversed(path)]

    def run(self, node, st=None, clr=0):
        idx = self._index[node]
        self._st[idx] = st
        self._colour[idx] = clr
        self._pre[idx] = self._pre_counter
        self._lows[idx] = self._pre_counter
        self._pre_counter += 1

        for depend in self._graph.edges[node]:
            depend_idx = self._index[depend]
            self._edge_count += 1
            if self._pre[depend_idx] is None:
                self._tree_links[idx].append(depend_idx)
                self.run(depend, idx, abs(clr - 1))
                self._lows[idx] = min(self._lows[idx], self._lows[depend_idx])

            else:

                if self._pre[idx] < self._pre[depend_idx]:
                    self._down_links[idx].append(depend_idx)
                else:
                    self._back_links[idx].append(depend_idx)

                if depend_idx != st:
                    self._lows[idx] = min(self._lows[idx], self._pre[depend_idx])
                else:
                    self._parent_links[idx].append(depend_idx)

        self._post[idx] = self._post_counter
        self._post_counter += 1

    def pprint_dfs_results(self):

        table = [
            ['pre'] + self._pre,
            ['lows'] + self._lows,
            ['post'] + self._post,
            ['st'] + self._st,
            ['colour'] + self._colour

        ]
        print(tabulate(table,
                       headers=[''] + [f"{i} ({self._index[i]})" for i in self._ordered_nodes]))
        print("Edge Count:", self._edge_count)

        two_colourability = True
        colour_edges = []
        for n in self._graph.edges:
            idx_n = self._index[n]
            clr_n = self._colour[idx_n]
            for d in self._graph.edges[n]:
                idx_d = self._index[d]
                clr_d = self._colour[idx_d]
                if clr_n == clr_d:
                    two_colourability = False
                colour_edges.append([f"{n}-{d}", clr_n, clr_d])

        # print(tabulate(colour_edges, headers=['Edge[w-v]', 'Colour[w]', 'Colour[v]']))
        print("Two Colourability:", two_colourability)

        print("TreeLinks:", dict(self._tree_links))
        print("Parentinks:", dict(self._parent_links))
        print("DownLinks:", dict(self._down_links))
        print("BackLinks:", dict(self._back_links))

        bridges = []
        for n, idx in self._index.items():
            if self._pre[idx] == self._lows[idx]:
                if self._st[idx] is not None:
                    bridges.append((self._ordered_nodes[self._st[idx]], n))
        print("Bridges:", bridges)


class BFS(DFS):
    def __init__(self, graph):
        super().__init__(graph)
        self._queue = Queue()

    def run(self, node):
        self._queue.put(node)

        while not self._queue.empty():
            node = self._queue.get()
            idx = self._index[node]
            self._pre[idx] = self._pre_counter
            self._pre_counter += 1

            for depend in self._graph.edges[node]:
                depend_idx = self._index[depend]
                self._edge_count += 1
                if self._pre[depend_idx] is None:
                    self._st[depend_idx] = idx
                    self._tree_links[idx].append(depend_idx)
                    self._queue.put(depend)
                else:
                    if self._pre[idx] < self._pre[depend_idx]:
                        self._down_links[idx].append(depend_idx)
                    else:
                        self._back_links[idx].append(depend_idx)

                    if depend_idx == idx:
                        self._parent_links[idx].append(depend_idx)
