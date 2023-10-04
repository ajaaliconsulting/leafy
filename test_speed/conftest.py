import sys
import time

import pytest

from leafy import SparseGraph

sys.setrecursionlimit(1_000_000)

node_counter = 0
def get_next_node():
    global node_counter
    node_counter += 1
    return node_counter


@pytest.fixture
def large_dag():
    global node_counter
    node_counter = 0
    deep: int = 9
    width: int = 7
    max_nodes: int = 100_000_000
    graph: SparseGraph = SparseGraph(max_nodes, True)
    t0 = time.time()
    add_children(graph, 0, width, 0, deep, max_nodes)
    t1 = time.time()

    nodes = 1
    for d in range(deep):
        nodes += width ** (d + 1)

    print(f"Large DAG: N:{nodes}, E:{graph.edge_count} Time:{t1-t0}s")
    yield graph


def add_children(graph: SparseGraph, parent_node: int, width: int, depth: int, max_depth: int, max_nodes: int):
    if depth == max_depth or parent_node == max_nodes:
        return
    for child_i in range(width):
        child_node = get_next_node()
        graph.add_edge(parent_node, child_node)
        add_children(graph, child_node, width, depth + 1, max_depth, max_nodes)

