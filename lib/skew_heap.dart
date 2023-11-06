class SkewHeap<T extends Comparable> {
  Node<T>? root;

  SkewHeap() {
    root = null;
  }

  T? pop() {
    if (root == null) {
      return null;
    }
    T value = root!.value;
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

  Node<T>? merge(Node<T>? n1, Node<T>? n2) {
    if (n1 == null) return n2;
    if (n2 == null) return n1;
    Node<T> small = n2;
    Node<T> large = n1;
    if (n1.compareTo(n2) <= 0) {
      small = n1;
      large = n2;
    }
    small.right = merge(small.right, large);
    small.swapChildren();
    return small;
  }

  List<T?> topThree() {
    if (root == null) return [];
    List<T?> topThree = [];
    while (topThree.length < 3) {
      topThree.add(pop());
    }
    for (int i = 0; i < 3; i++) {
      if (topThree[i] == null) break;
      insert(topThree[i]!);
    }

    return topThree;
  }
}

class Node<T extends Comparable> implements Comparable {
  Node<T>? left;
  Node<T>? right;
  T value;

  Node(this.value);

  @override
  int compareTo(other) {
    return value.compareTo(other.value);
  }

  void swapChildren() {
    Node<T>? temp = left;
    left = right;
    right = temp;
  }

  @override
  String toString() {
    return value.toString();
  }
}
