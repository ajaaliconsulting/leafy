"""
Purpose:
*.
"""
import pytest

from leafy.graph import Graph
from leafy.digraph import DFS
from .utils import dfs_diagnostics

"""
Test DFS.is_dag
Test DFS.topological_order
Test DFS.reverse_topological_order
"""

def small_dag():
    dag = Graph(13, True)
    dag.add_edge(0, 1)
    dag.add_edge(0, 2)
    dag.add_edge(0, 3)
    dag.add_edge(0, 5)
    dag.add_edge(0, 6)
    dag.add_edge(2, 3)
    dag.add_edge(3, 4)
    dag.add_edge(3, 5)
    dag.add_edge(4, 9)
    dag.add_edge(6, 4)
    dag.add_edge(6, 9)
    dag.add_edge(7, 6)
    dag.add_edge(8, 7)
    dag.add_edge(9, 10)
    dag.add_edge(9, 11)
    dag.add_edge(9, 12)
    dag.add_edge(11, 12)
    return dag

@pytest.fixture()
def dag_dfs():
    dag = small_dag()
    dfs = DFS(dag, 0)
    dfs.run()
    return dfs


class TestDagDFS:
    def test_is_dag(self, dag_dfs):
        assert dag_dfs.is_dag is True, dfs_diagnostics(dag_dfs)

    def test_topological_sort(self, dag_dfs):
        assert list(dag_dfs.topological_order()) == [
            0, 6, 2, 3, 5, 4, 9, 11, 12, 10, 1
        ], dfs_diagnostics(dag_dfs)

    def test_reverse_topological_sort(self, dag_dfs):
        assert list(dag_dfs.reverse_topological_order()) == [
            1, 10, 12, 11, 9, 4, 5, 3, 2, 6, 0
        ], dfs_diagnostics(dag_dfs)




