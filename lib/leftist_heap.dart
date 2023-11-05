class LeftistHeap<T> {
  late Node root;

  LeftistHeap(T rootValue) {
    root = Node(rootValue);
  }

  T pop() {
    return root.value;
  }
}

class Node<T> {
  Node? left;
  Node? right;
  T value;

  Node(this.value);
}
