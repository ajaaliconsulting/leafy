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
        if builder is not None and value is not None:
            raise AttributeError("You must either supply a builder or a value not both.")

        self._dag = dag
        self._id = node_id
        self._value = value
        self._builder = builder
        self._shifted_value = None
        self._shifted_builder = None
        self._expired = True
        self._shifted = False

    @property
    def value(self):
        """Get the value of the node."""
        if self._shifted:
            if self._shifted_builder:
                self._shifted_value = self._build_from_depends(self._shifted_builder)
            return self._shifted_value
        if self._expired:
            if self._builder is not None:
                self._value = self._build_from_depends(self._builder)
                self._expired = False
        return self._value

    def _build_from_depends(self, func):
        depends = [d.value for d in self._dag.get_depends(self.id)]
        return func(*depends)

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

    def shifted_builder(self, shifted_builder):
        """Temporeraly change the builder function to a shifted builder"""
        self._shifted_builder = shifted_builder
        self._shifted = True

    def set_value(self, value):
        """Permenantly change the value of the node to a new value."""
        self._value = value
        self._expired = False

    def expire(self):
        """Expire the value of the node and force it to recalculate"""
        if self._builder is not None:
            self._value = None
        self._expired = True

    def reset(self):
        """If the node is shifted reset it to it's original value"""
        self._shifted_value = None
        self._shifted_builder = None
        self._shifted = False


