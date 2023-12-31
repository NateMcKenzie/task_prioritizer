import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_prioritizer/binary_heap.dart';
import 'package:task_prioritizer/task.dart';
import 'package:task_prioritizer/task_card.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  SharedPreferences? prefs;

  _EditPageState() {
    loadPrefs();
  }

  Future<void> loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BinaryHeapModel>(builder: (context, heap, child) {
    List<Widget> taskCards = [];
    BinaryHeapModel originalHeap =
        Provider.of<BinaryHeapModel>(context, listen: false);
    BinaryHeapModel cloneHeap = originalHeap.clone();
    while (!cloneHeap.isEmpty) {
      taskCards.add(taskCard(cloneHeap.pop()));
    }
    return ListView(children: [
      Column(
        children: taskCards + [const Padding(
        padding: EdgeInsets.fromLTRB(0, 24, 0, 24),
        child: Divider(),
      ),
      Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: 
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (prefs != null) {
                        List<String>? list = prefs!.getStringList("heap");
                        heap.loadList(list);
                      }
                    });
                  },
                  child: const Text("Load"))
            ),
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
      ]))],
      ),
    ]);
  });
  }
}
