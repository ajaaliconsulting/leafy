"""
Purpose:
*. Leafy is a Dynamic Directed Acyclic Graph library in python.  It is dynamic as nodes can be
added and removed from the graph at runtime.
"""
from collections import defaultdict
from uuid import uuid4


class Leafy:

    def __init__(self):
        self._node_depends = defaultdict(list)
        self._node_by_id = {}

    def add(self, value, depends=None, node_id=None):
        if node_id is None:
            node_id = uuid4()

        if callable(value):
            node = Node(self, node_id, builder=value)
        else:
            node = Node(self, node_id, value=value)

        self._node_by_id[node_id] = node

        if depends is not None:
            for dependency in depends:
                if isinstance(dependency, Node):
                    try:
                        self._node_depends[node_id].append(self[dependency.id].id)
                    except KeyError:
                        raise AttributeError(
                            "Dependency %s not registered as a DAG child." % dependency.id
                        )
                else:
                    try:
                        self._node_depends[node_id].append(self[dependency].id)
                    except KeyError:
                        raise AttributeError(
                            "Dependency %s not registered as a DAG child" % dependency
                        )
        return node

    def __getitem__(self, node_id):
        return self._node_by_id[node_id]

    def get_depends(self, node_id):
        return (self[d_id] for d_id in self._node_depends[node_id])

    def pop(self, node_id):
        pass

    def apply(self):
        pass


class Node:

    def __init__(self, dag, node_id, builder=None, value=None):
        self._dag = dag
        self._id = node_id
        self._value = value
        self._shifted_value = None
        self._builder = builder
        self._expired = True
        self._shifted = False

    @property
    def value(self):
        """Get the value of the node."""
        if self._shifted:
            return self._shifted_value
        if self._value:
            return self._value
        elif self._builder is not None:
            depends = [d.value for d in self._dag.get_depends(self.id)]
            self._value = self._builder(*depends)
            self._expired = False
        return self._value

    @property
    def id(self):
        """Get the id of the node."""
        return self._id

    @property
    def is_shifted(self):
        return self._shifted

    def shift(self, value):
        """Temporarely change the value of the node to a new value"""
        self._shifted_value = value
        self._shifted = True

    def set_value(self, value):
        """Permenantly change the value of the node to a new value."""
        self._value = value

    def expire(self):
        """Expire the value of the node and force it to recalculate"""
        pass

    def reset(self):
        """If the node is shifted reset it to it's original value"""
        self._shifted_value = None
        self._shifted = False


