cimport numpy
import numpy as np
from cpython.mem cimport PyMem_Malloc, PyMem_Free
cimport cython

PYMAXWEIGHT = MAXWEIGHT

cdef link *create_link(int v, link *prev_link, double weight):
    cdef link *x = <link *> PyMem_Malloc(sizeof(link))
    x.val = v
    x.next = NULL
    x.weight = weight
    if prev_link is not NULL:
        prev_link.next = x
        x.counter = prev_link.counter + 1
    else:
        x.counter = 0
    return x


cdef link ** linked_list(int length):
    cdef int i
    cdef link ** link_list = <link **> PyMem_Malloc(length * sizeof(link*))
    for i in range(length):
        link_list[i] = NULL
    return link_list


cdef class AdjacencyList:
    """Adjacency list data structure which is an array of linked lists."""
    def __cinit__(self, int length):
        self._array_length = length
        self._start = linked_list(length)
        self._end = linked_list(length)
        self.count = 0

    def __dealloc__(self):
        cdef link *al
        cdef link *next_al
        for i in range(self._array_length):
            al = self._start[i]
            while al is not NULL:
                next_al = al.next
                PyMem_Free(al)
                al = next_al

    cpdef void append(self, int index, int value, double weight=0.0):
        assert 0 <= index < self._array_length
        self.count += 1
        if self._start[index] is NULL:
            self._start[index] = create_link(value, NULL, weight)
            self._end[index] = self._start[index]
        else:
            self._end[index] = create_link(value, self._end[index], weight)

    cpdef int length(self, int index):
        assert 0 <= index < self._array_length
        return self._end[index].counter + 1

    cpdef list as_py_list(self):
        cdef link *al
        cdef int i
        ret_list = []
        for i in range(self._array_length):
            i_list = []
            al = self._start[i]
            while al is not NULL:
                i_list.append(al.val)
                al = al.next
            ret_list.append(i_list)
        return ret_list

    cpdef list as_py_pairs(self):
        cdef link *al
        cdef int i
        cdef list ret_list = []
        cdef (int, int) pair
        for i in range(self._array_length):
            al = self._start[i]
            while al is not NULL:
                pair = (i, al.val)
                ret_list.append(pair)
                al = al.next
        return ret_list

    cpdef LinkedListIter listiter(self, int index):
        return LinkedListIter.create(self._start[index])


cdef class LinkedListIter:
    @staticmethod
    cdef LinkedListIter create(link *root_link):
        cdef LinkedListIter lli = LinkedListIter()
        lli.ll = root_link
        return lli

    def __iter__(self):
        return self

    def __next__(self):
        cdef (int, double) val
        if self.ll is not NULL:
            val = (self.ll.val, self.ll.weight)
            self.ll = self.ll.next
            return val
        raise StopIteration


cdef class MemoryViewArrayIter:
    def __cinit__(self, double [::1] mv, int length):
        self._length = length
        self._mv_array = mv
        self._counter = -1

    def __iter__(self):
        return self

    @cython.boundscheck(False)
    @cython.initializedcheck(False)
    @cython.wraparound(False)
    def __next__(self):
        while self._counter < self._length -1:
            self._counter += 1
            if self._mv_array[self._counter] < MAXWEIGHT:
                return self._counter, self._mv_array[self._counter]
        raise StopIteration


cdef class MVAIndexIter:
    """Memory View Array iterator returning the index of the value matches"""
    def __cinit__(self, int [::1] mv, int length, int value):
        self._length = length
        self._mv_array = mv
        self._value = value
        self._counter = -1

    def __iter__(self):
        return self

    @cython.boundscheck(False)
    @cython.initializedcheck(False)
    @cython.wraparound(False)
    def __next__(self):
        while self._counter < self._length -1:
            self._counter += 1
            if self._mv_array[self._counter] == self._value:
                return self._counter
        raise StopIteration


cdef class Queue:
    def __cinit__(self):
        self._head = NULL
        self._tail = NULL

    def __dealloc__(self):
        cdef qentry * entry = self._head
        cdef qentry * next
        while entry != NULL:
            next = entry.next
            PyMem_Free(entry)
            entry = next

    cpdef bint empty(self):
        if self._head == self._tail == NULL:
            return 1
        return 0

    cpdef push_head(self, int val):
        cdef qentry * e = <qentry *>PyMem_Malloc(sizeof(qentry))
        e.val = val

        if self._head is NULL:
            self._head = e
            e.prev = NULL
            if self._tail is NULL:
                self._tail = e
                e.next = NULL
            else:
                e.next = self._tail
        else:
            self._head.prev = e
            e.next = self._head
            self._head = e

    cpdef int pop_head(self):
        assert self.empty() == 0, "Queue is empty"
        cdef int val = self._head.val
        cdef qentry * h = self._head
        if self._head == self._tail:
            self._head = NULL
            self._tail = NULL
        else:
            self._head = self._head.next
            self._head.prev = NULL
        PyMem_Free(h)
        return val

    cpdef int peek_head(self):
        assert self.empty() == 0, "Queue is empty"
        return self._head.val

    cpdef push_tail(self, int val):
        cdef qentry * e = <qentry *>PyMem_Malloc(sizeof(qentry))
        e.val = val

        if self._tail is NULL:
            self._tail = e
            e.next = NULL
            if self._head is NULL:
                self._head = e
                e.prev = NULL
            else:
                e.prev = self._head
        else:
            self._tail.next = e
            e.prev = self._tail
            self._tail = e

    cpdef int pop_tail(self):
        assert self.empty() == 0, "Queue is empty"
        cdef int val = self._tail.val
        cdef qentry * t = self._tail
        if self._tail == self._head:
            self._tail = NULL
            self._head = NULL
        else:
            self._tail = self._tail.prev
            self._tail.next = NULL
        PyMem_Free(t)
        return val

    cpdef int peek_tail(self):
        assert self.empty() == 0, "Queue is empty"
        return self._tail.val


cdef class IndexHeapPriorityQueue:
    def __cinit__(self, double[::1] mv_client, bint order_asc):
        self._client_array = mv_client
        self._order_asc = order_asc
        self._index_queue = np.empty(len(mv_client)+1, dtype=np.intc)
        self._item_position = np.empty(len(mv_client), dtype=np.intc)
        self._length = 0
        for i in range(len(self._client_array)):
            self._insert(i)

    cdef void _insert(self, int i):
        self._length = self._length + 1
        self._index_queue[self._length] = i
        self._item_position[i] = self._length
        self.fix_up(self._length)

    cdef void _exchange(self, int i, int j):
        cdef int ti = self._index_queue[i]
        cdef int tj = self._index_queue[j]
        self._index_queue[i] = tj
        self._item_position[tj] = i

        self._index_queue[j] = ti
        self._item_position[ti] = j

    cdef bint _compare(self, int i, int j):
        if self._order_asc:
            return self._client_array[self._index_queue[i]] > self._client_array[self._index_queue[j]]
        return self._client_array[self._index_queue[i]] < self._client_array[self._index_queue[j]]

    cdef void fix_up(self, int k):
        while k > 1 and self._compare(k/2, k):
            self._exchange(k, k/2)
            k = k/2

    cdef void fix_down(self, int k):
        cdef int j
        while 2 * k <= self._length-1:
            j = 2 * k
            if j < self._length-1 and self._compare(j, j+1):
                j = j + 1
            if self._compare(k, j) == 0:
                break
            self._exchange(k, j)
            k = j

    cpdef bint empty(self):
        return self._length == 0

    cpdef int get_next(self):
        self._exchange(1, self._length)
        cdef ret_index = self._index_queue[self._length]
        self._length = self._length - 1
        self.fix_down(1)
        return ret_index

    cpdef void change(self, int i):
        self.fix_up(self._item_position[i])
        self.fix_down(self._item_position[i])


