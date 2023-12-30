import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_prioritizer/binary_heap.dart';
import 'package:task_prioritizer/edit_page.dart';
import 'package:task_prioritizer/home_page.dart';

void main() {
  BinaryHeapModel taskHeap = BinaryHeapModel.empty();
  runApp(ChangeNotifierProvider<BinaryHeapModel>(
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
    const baseColor = Color.fromRGBO(175, 187, 242, 1);
    return MaterialApp(
        theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            textTheme: const TextTheme(
                displayLarge:
                    TextStyle(fontSize: 26, fontWeight: FontWeight.normal),
                bodyLarge: TextStyle(fontSize: 18, color: Colors.black)),
            appBarTheme: const AppBarTheme(
                color: baseColor,
                titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
                iconTheme: IconThemeData(color: Colors.white)),
            colorScheme: ColorScheme.fromSeed(seedColor: baseColor)),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(title: const Text("Task Prioritizer")),
          body: PageView(
            children: const [HomePage(), EditPage()],
          ),
        ));
  }
}
