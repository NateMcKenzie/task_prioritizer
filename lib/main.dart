import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_prioritizer/binary_heap.dart';
import 'package:task_prioritizer/home_page.dart';
import 'package:task_prioritizer/task.dart';

void main() {
  runApp(ChangeNotifierProvider<BinaryHeapModel<Task>>(
    create: (context) => BinaryHeapModel.empty(),
    child: const TaskApp(),
  ));
}

class TaskApp extends StatefulWidget {
  const TaskApp({super.key});

  @override
  State<TaskApp> createState() => _TaskAppState();
}

class _TaskAppState extends State<TaskApp> {
  late HomePage homePage;
  // EditPage editPage;

  _TaskAppState() {
    homePage = const HomePage(title: "Tasks");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: homePage,
    );
  }
}
