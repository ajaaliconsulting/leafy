from cpython cimport array
import array

cdef extern from "constant.h":
    cdef double MAXWEIGHT

cdef int* int1dim(int length, int fill_val)
cdef double* double1dim(int length, double fill_val)
cdef double** double2dim(int length, int width, double fill_val)

cdef list int1dim_to_list(int length, int *arr)
cdef list double1dim_to_list(int length, double *arr)
cdef list double2dim_to_list(int length, int width, double **arr)

cdef struct link:
    int val
    double weight
    int counter
    link *next


cdef class LinkedListIter:
    cdef link *ll
    @staticmethod
    cdef LinkedListIter create(link *root_link)
    cdef (int, double) next_node(self)


cdef class AdjacencyList:
    cdef int _array_length
    cdef readonly int count
    cdef link ** _start
    cdef link ** _end
    cpdef void append(self, int index, int value, double weight=*)
    cpdef int length(self, int index)
    cpdef list as_py_list(self)
    cpdef list as_py_pairs(self)
    cdef LinkedListIter listiter(self, int index)
    cpdef LinkedListIter py_listiter(self, int index)


cdef class ArrayIter:
    cdef double *_array
    cdef int _length
    cdef int _counter


cdef ArrayIter array_iter(double *arr, int length)
cpdef ArrayIter py_array_iter(array.array arr, int length)


cdef class ArrayIndexIter:
    cdef int *_array
    cdef int _length
    cdef int _counter
    cdef int _value


cdef ArrayIndexIter array_index_iter(int *arr, int length, int value)


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
    cdef double *_client_array
    cdef bint _order_asc
    cdef int *_index_queue
    cdef int *_item_position
    cdef int _length
    cdef void insert(self, int i)
    cdef void _exchange(self, int i, int j)
    cdef bint _compare(self, int i, int j)
    cdef void fix_up(self, int k)
    cdef void fix_down(self, int k)
    cpdef bint empty(self)
    cpdef int get_next(self)
    cpdef void change(self, int k)


cdef IndexHeapPriorityQueue heap_queue(double *client_array, int length, bint order_asc)
cpdef IndexHeapPriorityQueue py_heap_queue(array.array client_array, int length, bint order_asc)
