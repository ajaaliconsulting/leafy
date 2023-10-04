import time

from leafy.digraph import DFS


def test_diagraph_time(large_dag):
    dfs = DFS(large_dag, 0)
    t0 = time.time()
    dfs.run()
    t1 = time.time()
    print(f"CYTHON {t1 - t0}")

    def _run(node: int):
        for w, _ in large_dag.nodeiter(node):
            _run(w)
    py_t0 = time.time()
    _run(0)
    py_t1 = time.time()
    print(f"CYTHON {t1 - t0} PYTHON {py_t1 - py_t0}")

