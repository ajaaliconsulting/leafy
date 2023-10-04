"""
Purpose:
*. Test cases for search.py
"""
import pytest

from leafy.graph import Graph
from leafy.search import DFS, BFS
from .utils import disanostics_table

@pytest.fixture
def small_graph():
    graph = Graph(22)
    graph.add_edge(0, 1)
    graph.add_edge(0, 2)
    graph.add_edge(1, 2)
    graph.add_edge(1, 3)
    graph.add_edge(3, 4)
    graph.add_edge(3, 5)
    graph.add_edge(5, 6)
    graph.add_edge(5, 7)
    graph.add_edge(5, 8)
    graph.add_edge(6, 8)
    graph.add_edge(7, 8)
    graph.add_edge(2, 9)
    graph.add_edge(9, 10)
    graph.add_edge(2, 11)
    graph.add_edge(11, 12)
    graph.add_edge(2, 13)
    graph.add_edge(13, 14)
    graph.add_edge(14, 15)
    graph.add_edge(15, 10)
    graph.add_edge(16, 17)
    graph.add_edge(16, 18)
    graph.add_edge(17, 19)
    graph.add_edge(17, 20)
    graph.add_edge(19, 20)
    graph.add_edge(20, 21)
    graph.add_edge(17, 21)
    return graph


@pytest.fixture
def graph_dfs(small_graph):
    dfs = DFS(small_graph, 0)
    dfs.run()
    return dfs


@pytest.fixture
def graph_bfs(small_graph):
    bfs = BFS(small_graph, 0)
    bfs.run()
    return bfs


@pytest.fixture
def small_graph_dfs(small_graph):
    dfs = DFS(small_graph, 16)
    dfs.run()
    return dfs


@pytest.fixture
def small_graph_bfs(small_graph):
    bfs = BFS(small_graph, 16)
    bfs.run()
    return bfs


class TestDFS:
    def test_simple_path(self, graph_dfs):
        assert graph_dfs.simple_path(12) == [0, 1, 2, 11, 12]
        assert graph_dfs.simple_path(8) == [0, 1, 3, 5, 6, 8]

    def test_simple_path_unconnected_graph(self, graph_dfs):
        with pytest.raises(AssertionError):
            graph_dfs.simple_path(20)

    def test_visited(self, graph_dfs):
        assert graph_dfs.visited == list(range(16))
        assert graph_dfs.unvisited == list(range(16, 22))

    def test_bridges(self, graph_dfs):
        assert set(graph_dfs.bridges) == {
            (1, 3), (3, 4), (3, 5), (2, 11), (11, 12)
        }, f"\n{disanostics_table(graph_dfs.diagnostics)}"

    def test_articulation_points(self, graph_dfs):
        assert set(graph_dfs.articulation_points) == {
            1, 2, 3, 5, 11
        }, f"\n{disanostics_table(graph_dfs.diagnostics)}"

    def test_articulation_points_small_graph(self, small_graph_dfs):
        assert set(small_graph_dfs.articulation_points) == {
            16, 17
        }, f"\n{disanostics_table(small_graph_dfs.diagnostics)}"

    def test_visited_edge_count(self, graph_dfs):
        assert graph_dfs.visited_edge_count == 38

    def test_bipirtite(self, graph_dfs):
        assert graph_dfs.bipirtite is False

        g = Graph(4)
        g.add_edge(0, 1)
        g.add_edge(1, 2)
        g.add_edge(2, 3)
        dfs = DFS(g, 0)
        dfs.run()
        assert dfs.bipirtite is True

    def test_links(self, small_graph_dfs):
        assert set(small_graph_dfs.tree_links) == {(16, 17), (17, 19), (19, 20), (20, 21), (16, 18)}
        assert set(small_graph_dfs.back_links) == {(20, 17), (21, 17)}
        assert set(small_graph_dfs.down_links) == {(17, 20), (17, 21)}
        assert set(small_graph_dfs.parent_links) == {
            (21, 20), (19, 17), (18, 16), (20, 19), (17, 16)
        }


class TestBFS:
    def test_shortest_path(self, graph_bfs):
        assert graph_bfs.shortest_path(12) == [
            0, 2, 11, 12
        ], f"\n{disanostics_table(graph_bfs.diagnostics)}"
        assert graph_bfs.shortest_path(8) == [
            0, 1, 3, 5, 8
        ], f"\n{disanostics_table(graph_bfs.diagnostics)}"

    def test_links(self, small_graph_bfs):
        assert set(small_graph_bfs.tree_links) == {(16, 17), (16, 18), (17, 20), (17, 19), (17, 21)}
        assert set(small_graph_bfs.back_links) == {(21, 20), (20, 19)}
        assert set(small_graph_bfs.down_links) == {(20, 21), (19, 20)}
        assert set(small_graph_bfs.parent_links) == {
            (19, 17), (18, 16), (21, 17), (17, 16), (20, 17)
        }

    def test_visited_edge_count(self, graph_bfs):
        assert graph_bfs.visited_edge_count == 38

    def test_simple_path_unconnected_graph(self, graph_bfs):
        with pytest.raises(AssertionError):
            graph_bfs.shortest_path(20)

    def test_visited(self, graph_bfs):
        assert graph_bfs.visited == list(range(16))
        assert graph_bfs.unvisited == list(range(16, 22))