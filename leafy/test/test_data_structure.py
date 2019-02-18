"""
Purpose:
*. Test data_structure.pyx
"""
from leafy.data_structure import Queue


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