cdef struct link:
    int val
    int counter
    link *next

cdef link *create_link(int v, link *prev_link)