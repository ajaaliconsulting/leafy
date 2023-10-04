import pytest

from leafy.graph import Graph
from leafy.shortest_path import Dijkstra
from .utils import disanostics_table


@pytest.fixture
def simple_network():
    graph = Graph(8, True)
    graph.add_edge(0, 1, 0.4)
    graph.add_edge(1, 2, 1.3)
    graph.add_edge(2, 4, 1.7)
    graph.add_edge(2, 7, 0.3)
    graph.add_edge(4, 5, 0.3)
    graph.add_edge(5, 6, 0.5)
    graph.add_edge(6, 3, 0.1)
    graph.add_edge(7, 3, 0.6)
    return graph


def test_shortest_path(simple_network):
    dij = Dijkstra(simple_network, 0)
    dij.run()
    assert dij.path(3) == [3, 7, 2, 1, 0], f"\n{disanostics_table(dij.diagnostics)}"
    assert dij.weight(3) == 2.6, f"\n{disanostics_table(dij.diagnostics)}"

