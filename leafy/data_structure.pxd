cdef struct link:
    int val
    int counter
    link *next


cdef class LinkedListIter:
    cdef link *ll
    @staticmethod
    cdef LinkedListIter create(link *root_link)


cdef class AdjacencyList:
    cdef int _array_length
    cdef link ** _start
    cdef link ** _end
    cdef void append(self, int index, int value)
    cdef int length(self, int index)
    cdef list as_py_list(self)
    cdef list as_py_pairs(self)
    cdef dict as_py_dict(self)
    cdef LinkedListIter listiter(self, int index)


cdef class MemoryViewArrayIter:
    cdef int [::1] _mv_array
    cdef int _length
    cdef int _counter