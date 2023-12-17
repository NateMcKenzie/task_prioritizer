import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_prioritizer/binary_heap.dart';
import 'package:task_prioritizer/task.dart';
import 'package:task_prioritizer/helpers.dart';
import 'package:task_prioritizer/task_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescriptionController = TextEditingController();
  final TextEditingController _taskTimeEstimateController = TextEditingController();
  final TextEditingController _taskDueDateController = TextEditingController();
  SharedPreferences? prefs;
  Duration spentUpdater = Duration.zero;

  _HomePageState() {
    loadPrefs();
  }

  Future<void> loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Column(children: [
        taskDisplay(),
        Consumer<BinaryHeapModel>(builder: (context, heap, child) {
          if (heap.isEmpty) return Container();
          Duration taskSpent = heap.getRootSpent();
          if (taskSpent > spentUpdater) spentUpdater = taskSpent;
          return Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      spentUpdater += const Duration(minutes: 15);
                      if (spentUpdater < Duration.zero) spentUpdater = Duration.zero;
                    });
                  },
                  child: const Text("-")),
              Text(formatDuration(spentUpdater)),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      spentUpdater += const Duration(minutes: 15);
                    });
                  },
                  child: const Text("+")),
              Consumer<BinaryHeapModel>(builder: (context, heap, child) {
                return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        heap.updateRootSpent(spentUpdater);
                        spentUpdater = heap.getRootSpent();
                      });
                    },
                    child: const Text("Update"));
              }),
            ],
          );
        }),
      ]),
      Form(
          child: Container(
        margin: const EdgeInsets.all(80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: formInputs(),
        ),
      )),
      ElevatedButton(
          onPressed: () async {
            List<Task> taskList = Provider.of<BinaryHeapModel>(context, listen: false).heap;
            List<String> stringList = [];
            for (Task task in taskList) {
              stringList.add(task.toCSV());
            }
            await prefs!.setStringList("heap", stringList);
          },
          child: const Text("Save")),
      Consumer<BinaryHeapModel>(builder: (context, heap, child) {
        return ElevatedButton(
            onPressed: () {
              setState(() {
                if (prefs != null) {
                  List<String>? list = prefs!.getStringList("heap");
                  heap.loadList(list);
                }
              });
            },
            child: const Text("Load"));
      })
    ]);
  }

  List<Widget> formInputs() {
    return [
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
          _addTask();
        },
        child: const Text('Submit'),
      ),
      Consumer<BinaryHeapModel>(builder: (context, heap, child) {
        return ElevatedButton(
            onPressed: () {
              setState(() {
                heap.pop();
              });
            },
            child: const Text('Pop'));
      }),
    ];
  }

  Widget taskDisplay() {
    return Consumer<BinaryHeapModel>(builder: (context, heap, child) {
      if (!heap.isEmpty) {
        return taskCard(heap.peek());
      } else {
        return Container();
      }
    });
  }

  void _addTask() {
    String taskName = _taskNameController.text;
    String taskDescription = _taskDescriptionController.text;
    double taskTimeEstimate = double.parse(_taskTimeEstimateController.text);
    DateTime taskDueDate = DateTime.parse(_taskDueDateController.text);
    Duration taskTimeDuration =
        Duration(hours: taskTimeEstimate.toInt(), minutes: int.parse((taskTimeEstimate % 1 * 60).toStringAsFixed(0)));
    Task newTask = Task(taskName, taskDescription, taskTimeDuration, taskDueDate, Duration.zero);
    Provider.of<BinaryHeapModel>(context, listen: false).insert(newTask);
    setState(() {
      _taskNameController.clear();
      _taskDescriptionController.clear();
      _taskTimeEstimateController.clear();
      _taskDueDateController.clear();
    });
  }
}
