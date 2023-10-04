from cpython.mem cimport PyMem_Malloc, PyMem_Free
cimport cython

PYMAXWEIGHT = MAXWEIGHT


cdef int* int1dim(int length, int fill_val):
    cdef int *x = <int *> PyMem_Malloc(sizeof(int)*length)
    for i in range(length):
        x[i] = fill_val
    return x


cdef double* double1dim(int length, double fill_val):
    cdef double *x = <double *> PyMem_Malloc(sizeof(double)*length)
    for i in range(length):
        x[i] = fill_val
    return x


cdef double** double2dim(int length, int width, double fill_val):
    cdef double **x = <double **> PyMem_Malloc(sizeof(double*) * length)
    for i in range(length):
        x[i] = <double *> PyMem_Malloc(sizeof(double) * width)
    for l in range(length):
        for w in range(width):
            x[l][w] = fill_val
    return x


cdef list int1dim_to_list(int length, int *arr):
    cdef list ret_list = []
    for i in range(length):
        ret_list.append(arr[i])
    return ret_list


cdef list double1dim_to_list(int length, double *arr):
    cdef list ret_list = []
    for i in range(length):
        ret_list.append(arr[i])
    return ret_list


cdef list double2dim_to_list(int length, int width, double **arr):
    cdef list ret_list = [[] for l in range(length)]
    for l in range(length):
        for w in range(width):
            ret_list[l].append(arr[l][w])
    return ret_list


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
        PyMem_Free(self._start)
        PyMem_Free(self._end)

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

    cdef LinkedListIter listiter(self, int index):
        return LinkedListIter.create(self._start[index])

    cpdef LinkedListIter py_listiter(self, int index):
        return LinkedListIter.create(self._start[index])


cdef class LinkedListIter:
    @staticmethod
    cdef LinkedListIter create(link *root_link):
        cdef LinkedListIter lli = LinkedListIter()
        lli.ll = root_link
        return lli

    cdef (int, double) next_node(self):
        cdef (int, double) val
        if self.ll is not NULL:
            val = (self.ll.val, self.ll.weight)
            self.ll = self.ll.next
            return val
        return -100, MAXWEIGHT

    def __iter__(self):
        return self

    def __next__(self):
        cdef (int, double) val
        if self.ll is not NULL:
            val = (self.ll.val, self.ll.weight)
            self.ll = self.ll.next
            return val
        raise StopIteration


cdef class ArrayIter:
    def __iter__(self):
        return self

    @cython.boundscheck(False)
    @cython.initializedcheck(False)
    @cython.wraparound(False)
    def __next__(self):
        while self._counter < self._length -1:
            self._counter += 1
            if self._array[self._counter] < MAXWEIGHT:
                return self._counter, self._array[self._counter]
        raise StopIteration


cdef ArrayIter array_iter(double *arr, int length):
    cdef ArrayIter aiter = ArrayIter.__new__(ArrayIter)
    aiter._length = length
    aiter._array = arr
    aiter._counter = -1
    return aiter


cpdef ArrayIter py_array_iter(array.array arr, int length):
    return array_iter(arr.data.as_doubles, length)


cdef class ArrayIndexIter:
    """Array iterator returning the index of the value matches"""
    def __iter__(self):
        return self

    @cython.boundscheck(False)
    @cython.initializedcheck(False)
    @cython.wraparound(False)
    def __next__(self):
        while self._counter < self._length -1:
            self._counter += 1
            if self._array[self._counter] == self._value:
                return self._counter
        raise StopIteration


cdef ArrayIndexIter array_index_iter(int *arr, int length, int value):
    cdef ArrayIndexIter indexiter = ArrayIndexIter.__new__(ArrayIndexIter)
    indexiter._length = length
    indexiter._array = arr
    indexiter._value = value
    indexiter._counter = -1
    return indexiter


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
    def __dealloc__(self):
        if self._index_queue is not NULL:
            PyMem_Free(self._index_queue)
        if self._item_position is not NULL:
            PyMem_Free(self._item_position)

    cdef void insert(self, int i):
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
        while k > 1 and self._compare(int(k/2), k):
            self._exchange(k, int(k/2))
            k = int(k/2)

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


cdef IndexHeapPriorityQueue heap_queue(double *client_array, int length, bint order_asc):
    cdef IndexHeapPriorityQueue pqueue = IndexHeapPriorityQueue.__new__(IndexHeapPriorityQueue)
    pqueue._client_array = client_array
    pqueue._order_asc = order_asc
    pqueue._index_queue = int1dim(length+1, -1)
    pqueue._item_position = int1dim(length, -1)
    pqueue._length = 0
    for i in range(length):
        pqueue.insert(i)
    return pqueue

cpdef IndexHeapPriorityQueue py_heap_queue(array.array client_array, int length, bint order_asc):
    return heap_queue(client_array.data.as_doubles, length, order_asc)
