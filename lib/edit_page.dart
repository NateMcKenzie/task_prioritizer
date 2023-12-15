import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_prioritizer/binary_heap.dart';
import 'package:task_prioritizer/task.dart';
import 'package:task_prioritizer/task_card.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> taskCards = [];
    BinaryHeapModel<Task> originalHeap =
        Provider.of<BinaryHeapModel<Task>>(context, listen: false);
    BinaryHeapModel<Task> cloneHeap = originalHeap.clone();
    while (!cloneHeap.isEmpty) {
      taskCards.add(taskCard(cloneHeap.pop()));
    }
    return ListView(
      children: taskCards,
    );
  }
}
