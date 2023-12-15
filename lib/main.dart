import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_prioritizer/binary_heap.dart';
import 'package:task_prioritizer/edit_page.dart';
import 'package:task_prioritizer/home_page.dart';
import 'package:task_prioritizer/task.dart';

void main() {
  BinaryHeapModel<Task> taskHeap = BinaryHeapModel.empty();
  runApp(ChangeNotifierProvider<BinaryHeapModel<Task>>(
    create: (context) => taskHeap,
    child: const TaskApp(),
  ));
}

class TaskApp extends StatefulWidget {
  const TaskApp({super.key});

  @override
  State<TaskApp> createState() => _TaskAppState();
}

class _TaskAppState extends State<TaskApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: Scaffold(
          appBar: AppBar(title: const Text("Task Prioritizer")),
          body: PageView(
            children: const [HomePage(), EditPage()],
          ),
        ));
  }
}
