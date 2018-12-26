"""
Purpose:
*.
"""
from collections import defaultdict

from tabulate import tabulate


class Graph:

    def __init__(self):
        self._nodes = defaultdict(list)
        self._builders = {}
        self._values = {}

        self._index = {}
        self._ordered_nodes = None
        self._len = 0
        self._pre = []
        self._st = []
        self._post = []
        self._lows = []
        self._pre_counter = 0
        self._post_counter = 0
        self._edge_count = 0
        self._cycle = []
        self._colour = []
        self._tree_links = {}
        self._back_links = {}
        self._down_links = {}
        self._parent_links = {}

    def add(self, node_id, depends=None):
        self._index[node_id] = self._len
        self._len += 1

        if depends:
            current_depends = self._nodes.get(node_id, [])
            current_depends.extend(depends)
            self._nodes[node_id] = current_depends
            for depend in depends:
                self._nodes[depend].append(node_id)

    def add_edge(self, node_id_1, node_id_2):
        current_depends = self._nodes.get(node_id_1, [])
        current_depends.append(node_id_2)
        self._nodes[node_id_1] = current_depends

    def set_value(self, node_id, value):
        self._values[node_id] = value

    def simple_path(self, node_id_1, node_id_2):
        idx_n1 = self._index[node_id_1]
        idx_n2 = self._index[node_id_2]
        path = []

        self.dfs(node_id_1)

        st = self._st[idx_n2]
        path.append(idx_n2)
        while st != idx_n1:
            path.append(st)
            st = self._st[st]
        path.append(st)

        return [self.ordered_nodes[p][1] for p in reversed(path)]

    @property
    def ordered_nodes(self):
        if self._ordered_nodes is None:
            self._ordered_nodes = sorted((v, k) for k, v in self._index.items())
        return self._ordered_nodes

    def dfs(self, node_id, st=None, clr=0):
        if st is None:
            self._pre_counter = 0
            self._post_counter = 0
            self._edge_count = 0
            self._ordered_nodes = None
            self._pre = [None] * self._len
            self._st = [None] * self._len
            self._post = [None] * self._len
            self._colour = [None] * self._len
            self._tree_links = defaultdict(list)
            self._back_links = defaultdict(list)
            self._down_links = defaultdict(list)
            self._parent_links = defaultdict(list)
            self._lows = [None] * self._len

        idx = self._index[node_id]

        self._st[idx] = st
        self._colour[idx] = clr
        self._pre[idx] = self._pre_counter
        self._lows[idx] = self._pre_counter
        self._pre_counter += 1

        for depend in self._nodes[node_id]:
            depend_idx = self._index[depend]
            self._edge_count += 1
            if self._pre[depend_idx] is None:
                self._tree_links[idx].append(depend_idx)
                self.dfs(depend, idx, abs(clr - 1))
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
        print(tabulate(table, headers=[''] + [f"{i[1]} ({i[0]})" for i in self.ordered_nodes]))
        print("Edge Count:", self._edge_count)

        two_colourability = True
        colour_edges = []
        for n in self._nodes:
            idx_n = self._index[n]
            clr_n = self._colour[idx_n]
            for d in self._nodes[n]:
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
                    bridges.append((self._st[idx], idx))
        print("Bridges:", bridges)
