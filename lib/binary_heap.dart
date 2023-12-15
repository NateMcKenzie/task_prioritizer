class BinaryHeap<T extends Comparable> {
  List<T> _heap = [];

  BinaryHeap.fromList(List<T> list){
    this._heap = List.from(list);
  }

  BinaryHeap.empty();

  T? pop() {
    if (_heap.isEmpty) {
      return null;
    }

    // Pop root, move last element to root
    T returnValue = _heap[0];
    _swap(0, _heap.length - 1);
    _heap.removeLast();

    // Swap down until heapified
    int pivot = 0;
    int leftChild = _leftChild(pivot);
    int rightChild = _rightChild(pivot);
    bool heapified = false;

    while (!heapified) {
      // Determine if pivot is smaller than children (if it has children)
      bool leftSmall = false;
      if (leftChild < _heap.length) {
        leftSmall = _heap[pivot].compareTo(_heap[leftChild]) >= 0;
      }
      bool rightSmall = false;
      if (rightChild < _heap.length) {
        rightSmall = _heap[pivot].compareTo(_heap[rightChild]) >= 0;
      }

      // Swap if pivot is larger than either child
      if (leftSmall || rightSmall) {
        //Swap with smallest child, move pivot pointer
        if ((leftSmall && !rightSmall) || _heap[leftChild].compareTo(_heap[rightChild]) < 0) {
          _swap(leftChild, pivot);
          pivot = leftChild;
        } else {
          _swap(rightChild, pivot);
          pivot = rightChild;
        }
        //Update child pointers
        leftChild = _leftChild(pivot);
        rightChild = _rightChild(pivot);
      } else {
        heapified = true;
      }
    }

    return returnValue;
  }

  T? peek(){
    return _heap[0];
  }

  void insert(T value) {
    // Insert at end of array always
    _heap.add(value);

    // Swap up until heapified
    int pivot = _heap.length - 1;
    int parent = _parent(pivot);
    while (_heap[pivot].compareTo(_heap[parent]) < 0) {
      _swap(pivot, parent);
      pivot = parent;
      parent = _parent(pivot);
    }
  }

  void _swap(int index1, int index2) {
    T temp = _heap[index1];
    _heap[index1] = _heap[index2];
    _heap[index2] = temp;
  }

  int _parent(int index) {
    return (index - 1) ~/ 2;
  }

  int _leftChild(int index) {
    return (index * 2) + 1;
  }

  int _rightChild(int index) {
    return (index * 2) + 2;
  }

}
