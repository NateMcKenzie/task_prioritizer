import 'package:flutter/material.dart';
import 'package:task_prioritizer/task.dart';

class BinaryHeapModel extends ChangeNotifier {
  List<Task> _heap = [];
  get isEmpty => _heap.isEmpty;
  get heap => _heap;

  BinaryHeapModel.empty();

  BinaryHeapModel.fromList(List<Task> list) {
    _heap = List.from(list);
  }

  BinaryHeapModel clone() {
    return BinaryHeapModel.fromList(_heap);
  }

  void loadList(List<String>? stringList) {
    if (stringList == null) return;
    _heap = [];
    for (String line in stringList) {
      _heap.add(Task.parse(line));
    }
  }

  Task pop() {
    if (_heap.isEmpty) {
      throw StateError('Heap is empty. Cannot extract minimum element.');
    }

    // Pop root, move last element to root
    Task returnValue = _heap[0];
    _swap(0, _heap.length - 1);
    _heap.removeLast();

    percolateDown();

    return returnValue;
  }

  Task peek() {
    if (_heap.isEmpty) {
      throw StateError('Heap is empty. Cannot extract minimum element.');
    }

    return _heap[0];
  }

  void insert(Task value) {
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
    notifyListeners();
  }

  void percolateDown() {
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

    notifyListeners();
  }

  void updateRootSpent(Duration hoursSpent) {
    _heap[0].timeSpent = hoursSpent;
    if (_heap[0].requiredEstimate - _heap[0].timeSpent <= Duration.zero) {
      pop();
    } else {
      percolateDown();
    }
  }

  Duration getRootSpent() {
    return _heap[0].timeSpent;
  }

  void _swap(int index1, int index2) {
    Task temp = _heap[index1];
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
