import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_prioritizer/binary_heap.dart';
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
    BinaryHeapModel originalHeap = Provider.of<BinaryHeapModel>(context, listen: false);
    BinaryHeapModel cloneHeap = originalHeap.clone();
    while (!cloneHeap.isEmpty) {
      taskCards.add(editTaskCard(cloneHeap.pop()));
    }
    return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300.0, minHeight: 400.0),
        child: ListView(
          children: taskCards,
        ));
  }
}
