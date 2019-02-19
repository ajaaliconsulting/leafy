from cpython.mem cimport PyMem_Malloc, PyMem_Free
cimport cython

cdef link *create_link(int v, link *prev_link):
    cdef link *x = <link *> PyMem_Malloc(sizeof(link))
    x.val = v
    x.next = NULL
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

    cdef void append(self, int index, int value):
        assert 0 <= index < self._array_length
        self.count += 1
        if self._start[index] is NULL:
            self._start[index] = create_link(value, NULL)
            self._end[index] = self._start[index]
        else:
            self._end[index] = create_link(value, self._end[index])

    cdef int length(self, int index):
        assert 0 <= index < self._array_length
        return self._end[index].counter + 1

    cdef list as_py_list(self):
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

    cdef list as_py_pairs(self):
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

    cdef dict as_py_dict(self):
        cdef dict py_dict = dict(self.as_py_pairs())
        return py_dict

    cdef LinkedListIter listiter(self, int index):
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
        cdef int val
        if self.ll is not NULL:
            val = self.ll.val
            self.ll = self.ll.next
            return val
        raise StopIteration


cdef class MemoryViewArrayIter:
    def __cinit__(self, int [::1] mv, int length):
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
            if self._mv_array[self._counter] != 0:
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






