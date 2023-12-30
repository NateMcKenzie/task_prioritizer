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
  //Light Theme
  static const lightBase = Color.fromRGBO(175, 187, 242, 1);
  ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.normal),
          bodyLarge: TextStyle(fontSize: 18)),
      appBarTheme: const AppBarTheme(
          color: lightBase,
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(color: Colors.white)),
      colorScheme: ColorScheme.fromSeed(
        seedColor: lightBase,
        brightness: Brightness.light,
      ));

  //Dark Theme
  static const Color darkBase = Color.fromRGBO(29, 55, 175, 1);
  ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 26,
        color: Colors.white,
        fontWeight: FontWeight.normal,
      ),
      bodyLarge: TextStyle(fontSize: 18),
    ),
    appBarTheme: const AppBarTheme(
      color: darkBase,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: darkBase,
      brightness: Brightness.dark,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(title: const Text("Task Prioritizer")),
          body: PageView(
            children: const [HomePage(), EditPage()],
          ),
        ));
  }
}
