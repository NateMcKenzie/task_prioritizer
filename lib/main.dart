import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_prioritizer/binary_heap.dart';
import 'package:task_prioritizer/task.dart';
import 'package:task_prioritizer/task_card.dart';

void main() {
  runApp(const TaskApp());
}

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Prioritizer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red.shade200),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Task Prioritizer Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescriptionController = TextEditingController();
  final TextEditingController _taskTimeEstimateController = TextEditingController();
  final TextEditingController _taskDueDateController = TextEditingController();
  final BinaryHeap<Task> _taskHeap = BinaryHeap.empty();
  bool _editing = false;
  List<Task> _sortedTasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: ListView(children: [
          Form(
              child: Container(
            margin: const EdgeInsets.all(80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: pager(),
            ),
          )),
        ]));
  }

  List<Widget> formInputs() {
    return [
      taskDisplay(),
      Container(
        margin: const EdgeInsets.all(8),
        child: TextFormField(
          decoration: const InputDecoration(
            icon: Icon(Icons.task),
            hintText: 'What is the task?',
            labelText: 'Task Name',
          ),
          controller: _taskNameController,
        ),
      ),
      Container(
        margin: const EdgeInsets.all(8),
        child: TextFormField(
          decoration: const InputDecoration(
            icon: Icon(Icons.description_outlined),
            hintText: 'Any notes about the task',
            labelText: 'Description',
          ),
          controller: _taskDescriptionController,
        ),
      ),
      Container(
          margin: const EdgeInsets.all(8),
          child: TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.timer),
              hintText: 'How many hours will it take?',
              labelText: 'Time Estimate',
            ),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))],
            controller: _taskTimeEstimateController,
          )),
      Container(
        margin: const EdgeInsets.all(8),
        child: TextFormField(
          decoration: const InputDecoration(
            icon: Icon(Icons.calendar_today),
            hintText: 'yyyy-mm-ddThh:mm',
            labelText: 'Due Date',
          ),
          controller: _taskDueDateController,
        ),
      ),
      ElevatedButton(
        onPressed: () {
          String taskName = _taskNameController.text;
          String taskDescription = _taskDescriptionController.text;
          double taskTimeEstimate = double.parse(_taskTimeEstimateController.text);
          DateTime taskDueDate = DateTime.parse(_taskDueDateController.text);
          Duration taskTimeDuration = Duration(
              hours: taskTimeEstimate.toInt(), minutes: int.parse((taskTimeEstimate % 1 * 60).toStringAsFixed(0)));
          Task test = Task(taskName, taskDescription, taskTimeDuration, taskDueDate, Duration.zero);
          _taskHeap.insert(test);
          setState(() {
            _taskNameController.clear();
            _taskDescriptionController.clear();
            _taskTimeEstimateController.clear();
            _taskDueDateController.clear();
          });
        },
        child: const Text('Submit'),
      ),
      ElevatedButton(
        onPressed: () {
          setState(() {
            Task popped = _taskHeap.pop() as Task;
            print(popped.toString());
          });
        },
        child: const Text('Pop'),
      ),
      ElevatedButton(
        onPressed: () {
          setState(() {
            sortTasks();
            _editing = true;
          });
        },
        child: const Text('Edit Tasks'),
      )
    ];
  }

  //TODO: Not correct, but I need the state and don't want to move it yet.
  List<Widget> pager() {
    if (_editing) {
      return editPage();
    }
    return formInputs();
  }

  List<Widget> editPage() {
    List<Widget> returnValue = [];
    for (Task task in _sortedTasks) {
      returnValue.add(taskCard(task));
    }
    return returnValue;
  }

  Widget taskDisplay() {
    if (_taskHeap.isEmpty) {
      return Container(); // Empty container because there's nothing to draw.
    }
    Task topTask = _taskHeap.peek();
    return taskCard(topTask);
  }

  void sortTasks() {
    _sortedTasks = [];
    while (!_taskHeap.isEmpty) {
      _sortedTasks.add(_taskHeap.pop());
    }
  }
}
