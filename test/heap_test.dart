//import 'package:task_prioritizer/skew_heap.dart';
import 'package:task_prioritizer/binary_heap.dart';
import 'package:test/test.dart';

void main() {
  test("BinaryHeap", () {
    priorityQueue();
  });
}

/// Test that the skew heap functions effectively as a priority queue.
void priorityQueue() {
  List<int> unsorted = [33,95,54,47,67,54,47,24,42,87,43,73,0,38,89,76,86,5,40,27,91,42,27,37,14,
  18,16,70,74,85,55,84,20,64,82,17,93,62,53,10,83,46,69,10,44,41,32,98,64,88,67,11,22,87,20,32,4,
  46,52,15,34,49,54,53,93,15,9,45,86,94,42,88,32,58,69,74,18,39,29,69,85,38,91,71,27,54,41,37,25,
  34,13,40,81,29,65,29,61,53,10,65,22,23,5,30,3,69,83,37,55,41,28,54,36,82,60,85,72,78,64,76];

  List<int> sorted = [0,3,4,5,5,9,10,10,10,11,13,14,15,15,16,17,18,18,20,20,22,22,23,24,25,27,27,
  27,28,29,29,29,30,32,32,32,33,34,34,36,37,37,37,38,38,39,40,40,41,41,41,42,42,42,43,44,45,46,46,
  47,47,49,52,53,53,53,54,54,54,54,54,55,55,58,60,61,62,64,64,64,65,65,67,67,69,69,69,69,70,71,72,
  73,74,74,76,76,78,81,82,82,83,83,84,85,85,85,86,86,87,87,88,88,89,91,91,93,93,94,95,98];

  BinaryHeapModel<int> heap = BinaryHeapModel.empty();
  for (int i in unsorted) {
    heap.insert(i);
  }
  for (int i in sorted) {
    assert(heap.pop() == i);
  }
}
