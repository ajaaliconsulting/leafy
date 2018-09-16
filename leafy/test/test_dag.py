from unittest import TestCase
from unittest.mock import Mock

from leafy.dag import Leafy, Node


class NodeTestCase(TestCase):

    def mock_node(self):
        return Node(Mock(), 'a', value=12)

    def mock_sum_node(self):
        builder = lambda x, y: x + y

        nx = Node(Mock(), 'x', value=12)
        ny = Node(Mock(), 'y', value=13)

        dag = Mock()
        dag.get_depends = Mock(return_value=[nx, ny])

        return Node(dag, 'sum', builder=builder)

    def test_id(self):
        n1 = Node(Mock(), 'a')
        self.assertEqual('a', n1.id)
        self.assertEqual(None, n1.value)

    def test_value(self):
        n1 = self.mock_node()
        self.assertEqual(12, n1.value)

    def test_value_with_builder(self):
        nsum = self.mock_sum_node()
        self.assertEqual(25, nsum.value)

    def test_shift_and_reset(self):
        n1 = self.mock_node()
        self.assertEqual(12, n1.value)
        n1.shift(13)
        self.assertEqual(13, n1.value)
        self.assertTrue(n1.is_shifted)
        n1.reset()
        self.assertEqual(12, n1.value)
        self.assertFalse(n1.is_shifted)

        #Tests with builder
        nsum = self.mock_sum_node()
        self.assertEqual(25, nsum.value)
        nsum.shift(36)
        self.assertEqual(36, nsum.value)
        nsum.reset()
        self.assertEqual(25, nsum.value)














class LeafyTestCase(TestCase):

    def test_dag_creation_with_leafs(self):
        dag = Leafy()
        n1 = dag.add(12, node_id="n1")
        self.assertEqual(12, n1.value)
        self.assertEqual(n1, dag['n1'])

    def test_dag_simple_tree(self):
        dag = Leafy()
        n1 = dag.add(12)
        n2 = dag.add(13)
        n3 = dag.add(lambda x,y: x+y, depends=[n1, n2])
        self.assertEqual(25, n3.value)
