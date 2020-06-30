cdef extern from "constant.h":
    cdef double MAXWEIGHT

cdef struct link:
    int val
    double weight
    int counter
    link *next


cdef class LinkedListIter:
    cdef link *ll
    @staticmethod
    cdef LinkedListIter create(link *root_link)


cdef class AdjacencyList:
    cdef int _array_length
    cdef readonly int count
    cdef link ** _start
    cdef link ** _end
    cpdef void append(self, int index, int value, double weight=*)
    cpdef int length(self, int index)
    cpdef list as_py_list(self)
    cpdef list as_py_pairs(self)
    cpdef LinkedListIter listiter(self, int index)


cdef class MemoryViewArrayIter:
    cdef double [::1] _mv_array
    cdef int _length
    cdef int _counter


cdef class MVAIndexIter:
    cdef int[::1] _mv_array
    cdef int _length
    cdef int _counter
    cdef int _value


cdef struct qentry:
    int val
    qentry * prev
    qentry * next


cdef class Queue:
    cdef qentry * _head
    cdef qentry * _tail
    cpdef push_head(self, int val)
    cpdef int pop_head(self)
    cpdef int peek_head(self)
    cpdef push_tail(self, int val)
    cpdef int pop_tail(self)
    cpdef int peek_tail(self)
    cpdef bint empty(self)



cdef class IndexHeapPriorityQueue:
    cdef double[::1] _client_array
    cdef bint _order_asc
    cdef readonly int[::1] _index_queue
    cdef readonly int[::1] _item_position
    cdef int _length
    cdef void _insert(self, int i)
    cdef void _exchange(self, int i, int j)
    cdef bint _compare(self, int i, int j)
    cdef void fix_up(self, int k)
    cdef void fix_down(self, int k)
    cpdef bint empty(self)
    cpdef int get_next(self)
    cpdef void change(self, int k)

