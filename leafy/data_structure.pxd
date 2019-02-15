cdef struct link:
    int val
    int counter
    link *next


cdef class AdjacencyList:
    cdef int _array_length
    cdef link ** _start
    cdef link ** _end
    cdef void append(self, int index, int value)
    cdef int length(self, int index)
    cdef list as_py_list(self)
