"""
Purpose:
*. Test data_structure.pyx
"""
import numpy as np
import pytest

from leafy.data_structure import Queue, AdjacencyList, PYMAXWEIGHT, MemoryViewArrayIter


@pytest.fixture
def simple_adj_list():
    adjlist = AdjacencyList(4)
    adjlist.append(0, 1)
    adjlist.append(1, 2, 1.2)
    adjlist.append(1, 3, 1.3)
    adjlist.append(2, 3, 2.3)
    return adjlist


def test_adjacencylist(simple_adj_list):
    assert simple_adj_list.length(1) == 2
    assert simple_adj_list.as_py_list() == [
        [1],
        [2, 3],
        [3],
        []
    ]
    assert simple_adj_list.as_py_pairs() == [
        (0, 1), (1, 2), (1, 3), (2, 3)
    ]


def test_linkedlistiter(simple_adj_list):
    assert [(2, 1.2), (3, 1.3)] == [i for i in simple_adj_list.listiter(1)]


def test_memoryviewiter():
    arr = np.array([
        [PYMAXWEIGHT, 1.0,         PYMAXWEIGHT, PYMAXWEIGHT],
        [PYMAXWEIGHT, PYMAXWEIGHT, 1.2,         1.3],
        [PYMAXWEIGHT, PYMAXWEIGHT, PYMAXWEIGHT, 2.3],
        [PYMAXWEIGHT, PYMAXWEIGHT, PYMAXWEIGHT, PYMAXWEIGHT],
    ])
    mv_iter = MemoryViewArrayIter(arr[1][:], 4)
    assert [(2, 1.2), (3, 1.3)] == [i for i in mv_iter]


class TestQueue:
    def test_push_head_pop_head_peak_head(self):
        q = Queue()
        assert q.empty()
        q.push_head(1)
        assert not q.empty()
        q.push_head(2)
        q.push_head(3)
        assert q.pop_head() == 3
        q.push_head(4)
        assert q.peek_head() == 4
        assert q.pop_head() == 4
        assert q.pop_head() == 2
        assert q.pop_head() == 1
        assert q.empty()

    def test_push_tail_pop_tail_peak_tail(self):
        q = Queue()
        assert q.empty()
        q.push_tail(1)
        assert not q.empty()
        q.push_tail(2)
        q.push_tail(3)
        assert q.pop_tail() == 3
        q.push_tail(4)
        assert q.peek_tail() == 4
        assert q.pop_tail() == 4
        assert q.pop_tail() == 2
        assert q.pop_tail() == 1
        assert q.empty()

    def test_fifo_queue(self):
        q = Queue()
        q.push_head(1)
        q.push_head(2)
        q.push_head(3)
        q.push_head(4)
        assert q.pop_tail() == 1
        assert q.pop_tail() == 2
        assert q.pop_tail() == 3
        assert q.pop_tail() == 4
        assert q.empty()
