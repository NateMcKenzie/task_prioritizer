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
  final TextEditingController _taskDescriptionController =
      TextEditingController();
  final TextEditingController _taskTimeEstimateController =
      TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 23, minute: 59);
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
      taskDisplay(),
      Form(
          child: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: formInputs(),
        ),
      )),
      const Padding(
        padding: EdgeInsets.fromLTRB(0, 24, 0, 24),
        child: Divider(),
      ),
      Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: Consumer<BinaryHeapModel>(builder: (context, heap, child) {
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
            })),
        Padding(
          padding: const EdgeInsets.all(8),
          child: ElevatedButton(
              onPressed: () async {
                List<Task> taskList =
                    Provider.of<BinaryHeapModel>(context, listen: false).heap;
                List<String> stringList = [];
                for (Task task in taskList) {
                  stringList.add(task.toCSV());
                }
                await prefs!.setStringList("heap", stringList);
              },
              child: const Text("Save")),
        ),
      ]))
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
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))
            ],
            controller: _taskTimeEstimateController,
          )),
      Container(
        margin: const EdgeInsets.fromLTRB(8, 16, 8, 8),
        child: Row(children: [
          const Icon(Icons.event),
          Container(
              margin: const EdgeInsets.only(left: 18),
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey))),
              child: Row(children: [
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(formatDate(selectedDate)),
                ),
                TextButton(
                    onPressed: () => _selectTime(context),
                    child: Text(formatTime(time: selectedTime))),
              ])),
        ]),
      ),
      Padding(
          padding: const EdgeInsets.fromLTRB(8, 48, 8, 8),
          child: ElevatedButton(
            onPressed: _addTask,
            child: const Text('Submit'),
          )),
    ];
  }

  Widget taskDisplay() {
    return Consumer<BinaryHeapModel>(builder: (context, heap, child) {
      if (!heap.isEmpty) {
        return Column(children: [
          taskCard(heap.peek()),
          Consumer<BinaryHeapModel>(builder: (context, heap, child) {
            if (heap.isEmpty) return Container();
            Duration taskSpent = heap.getRootSpent();
            if (taskSpent > spentUpdater) spentUpdater = taskSpent;
            return Row(
              children: [
                const Spacer(),
                Card(
                    child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(children: [
                          const Text("Progress"),
                          Row(children: [
                            Text(formatDuration(spentUpdater)),
                            Column(
                              children: [
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        spentUpdater +=
                                            const Duration(minutes: 15);
                                      });
                                    },
                                    child: const Text("+")),
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        spentUpdater -=
                                            const Duration(minutes: 15);
                                        if (spentUpdater < Duration.zero) {
                                          spentUpdater = Duration.zero;
                                        }
                                      });
                                    },
                                    child: const Text("-")),
                              ],
                            ),
                          ]),
                          Row(
                            children: [
                              Consumer<BinaryHeapModel>(
                                  builder: (context, heap, child) {
                                return ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        heap.updateRootSpent(spentUpdater);
                                        spentUpdater = heap.getRootSpent();
                                      });
                                    },
                                    child: const Text("Update"));
                              }),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Consumer<BinaryHeapModel>(
                                    builder: (context, heap, child) {
                                  return ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          if (!heap.isEmpty) heap.pop();
                                        });
                                      },
                                      child: const Text('Complete'));
                                }),
                              )
                            ],
                          )
                        ]))),
                const Spacer(),
              ],
            );
          }),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 24, 0, 24),
            child: Divider(),
          )
        ]);
      } else {
        return Container();
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2023),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _addTask() {
    Task? newTask = readInput();
    if (newTask == null) return;
    Provider.of<BinaryHeapModel>(context, listen: false).insert(newTask);
    setState(() {
      _taskNameController.clear();
      _taskDescriptionController.clear();
      _taskTimeEstimateController.clear();
      selectedDate = DateTime.now();
    });
  }

  //TODO: Fails quietly instead of telling the user their error.
  Task? readInput() {
    String taskName;
    String taskDescription;
    DateTime dueDate;
    double? taskTimeEstimate;
    Duration taskTimeDuration;

    //Read inputs into varialbes, return null if anything is wrong.
    if (_taskNameController.text.isNotEmpty) {
      taskName = _taskNameController.text;
    } else {
      return null;
    }

    taskDescription = _taskDescriptionController.text;

    dueDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
        selectedTime.hour, selectedTime.minute);

    taskTimeEstimate = double.tryParse(_taskTimeEstimateController.text);
    if (taskTimeEstimate == null) return null;

    taskTimeDuration = Duration(
        hours: taskTimeEstimate.toInt(),
        minutes: int.parse((taskTimeEstimate % 1 * 60).toStringAsFixed(0)));

    return Task(
        taskName, taskDescription, taskTimeDuration, dueDate, Duration.zero);
  }
}
