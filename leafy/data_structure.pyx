from cpython.mem cimport PyMem_Malloc


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
