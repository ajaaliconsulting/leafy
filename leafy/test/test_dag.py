from unittest import TestCase

from leafy.dag import Leafy


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
