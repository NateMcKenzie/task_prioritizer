import 'package:task_prioritizer/skew_heap.dart';
import 'package:test/test.dart';

void main() {
  test("SkewHeap", () {
    priorityQueue();
  });
}

void priorityQueue() {
  List<int> unsorted = [
    33, 12, 24, 5, 42, 49, 36, 17, 29, 3, 41,
    25, 6, 7, 16, 21, 9, 38, 31, 46, 45, 4, 15,
    28, 32, 14, 40, 22, 26, 20, 35, 19, 10, 27,
    48, 30, 23, 8, 11, 1, 2, 47, 34, 18, 37, 44,
    43, 39, 13, 50 ];
  List<int> sorted = [
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,
    14, 15, 16, 17, 18, 19, 20, 21, 22, 23,
    24, 25, 26, 27, 28, 29, 30, 31, 32, 33,
    34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 
    44, 45, 46, 47, 48, 49, 50 ];
  SkewHeap<int> heap = SkewHeap();
  for (int i in unsorted) {
    heap.insert(i);
  }
  for (int i in sorted) {
    assert(heap.pop() == i);
  }
}
