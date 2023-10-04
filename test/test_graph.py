"""
Purpose:
*.
"""
import pytest

from leafy.data_structure import PYMAXWEIGHT
from leafy.graph import Graph


@pytest.fixture()
def small_dag():
    dag = Graph(13, True)
    dag.add_edge(0, 1, 0.5)
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


def test_source_sink(small_dag):
    assert list(small_dag.sources) == [0, 8]
    assert list(small_dag.sinks) == [1, 5, 10, 12]


def test_graph_weights(small_dag):
    assert small_dag.edge_weight(0, 1) == 0.5
    assert small_dag.edge_weight(0, 2) == 1.0
    assert small_dag.edge_weight(2, 4) == PYMAXWEIGHT
