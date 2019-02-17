"""
Purpose:
*. Test cases for search.py
"""
import pytest

from leafy.cgraph import Graph, SparseGraph
from leafy.search import DFS


def small_graph(graph_type):
    graph_cls = Graph if graph_type == 'dense' else SparseGraph
    graph = graph_cls(21)
    graph.add_edge(0, 1)
    graph.add_edge(0, 2)
    graph.add_edge(1, 2)
    graph.add_edge(1, 3)
    graph.add_edge(3, 4)
    graph.add_edge(3, 5)
    graph.add_edge(5, 6)
    graph.add_edge(5, 7)
    graph.add_edge(5, 8)
    graph.add_edge(7, 8)
    graph.add_edge(2, 9)
    graph.add_edge(9, 10)
    graph.add_edge(2, 11)
    graph.add_edge(11, 12)
    graph.add_edge(2, 13)
    graph.add_edge(14, 15)
    graph.add_edge(15, 10)
    graph.add_edge(16, 17)
    graph.add_edge(16, 18)
    graph.add_edge(17, 20)
    graph.add_edge(17, 19)
    graph.add_edge(19, 20)
    return graph


@pytest.fixture(params=['dense']) #, 'sparse'])
def small_graph_dfs(request):
    graph = small_graph(request.param)
    dfs = DFS(graph, 0)
    dfs.run()
    return dfs


class TestDFS:
    def test_simple_path(self, small_graph_dfs):
        assert small_graph_dfs.simple_path(12) == [0, 1, 2, 11, 12]
        assert small_graph_dfs.simple_path(8) == [0, 1, 3, 5, 7, 8]

    def test_simple_path_unconnected_graph(self, small_graph_dfs):
        with pytest.raises(AssertionError):
            small_graph_dfs.simple_path(20)