import time

from leafy.digraph import DFS as diDFS
from leafy.search import DFS, BFS
from leafy.shortest_path import Dijkstra


def test_diagraph_time(large_dag):
    dfs = diDFS(large_dag, 0)
    t0 = time.time()
    dfs.run()
    t1 = time.time()
    def _run(node: int):
        for w, _ in large_dag.py_nodeiter(node):
            _run(w)
    py_t0 = time.time()
    _run(0)
    py_t1 = time.time()
    print(f"test_diagraph_time CYTHON {t1 - t0} PYTHON {py_t1 - py_t0}")
    assert (t1 - t0) < (py_t1 - py_t0)


def test_cyclic_time(large_weighted_graph):
    dfs = DFS(large_weighted_graph, 0)
    t0 = time.time()
    dfs.run()
    t1 = time.time()
    print(f"test_cyclic_time DFS CYTHON {t1 - t0}")
    assert (t1 - t0) < 6

    bfs = BFS(large_weighted_graph, 0)
    t0 = time.time()
    bfs.run()
    t1 = time.time()
    print(f"test_cyclic_time BFS CYTHON {t1 - t0}")
    assert (t1 - t0) < 9

    bfs = Dijkstra(large_weighted_graph, 0)
    t0 = time.time()
    bfs.run()
    t1 = time.time()
    print(f"test_cyclic_time Dijkstra CYTHON {t1 - t0}")
    assert (t1 - t0) < 90
