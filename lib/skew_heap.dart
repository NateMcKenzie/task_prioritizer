class SkewHeap<T extends Comparable> {
  Node? root;

  SkewHeap() {
    root = null;
  }

  Comparable<dynamic> pop() {
    if (root == null) {
      throw Exception('Heap is empty');
    }
    Comparable<dynamic> value = root!.value;
    root = merge(root!.left, root!.right);
    return value;
  }

  void insert(T value) {
    Node<T> node = Node(value);
    if (root == null) {
      root = node;
    } else {
      root = merge(root, node);
    }
  }

  Node? merge(Node? n1, Node? n2) {
    if (n1 == null) return n2;
    if (n2 == null) return n1;
    Node small = n2;
    Node large = n1;
    if (n1.compareTo(n2) <= 0) {
      small = n1;
      large = n2;
    }
    small.right = merge(small.right, large);
    return small.swapChildren();
  }
}

class Node<T extends Comparable> implements Comparable {
  Node? left;
  Node? right;
  T value;

  Node(this.value);

  @override
  int compareTo(other) {
    return value.compareTo(other.value);
  }

  Node<Comparable>? swapChildren() {
    Node? temp = left;
    left = right;
    right = temp;
    return this;
  }
}
