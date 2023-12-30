import 'package:flutter/material.dart';
import 'package:task_prioritizer/task.dart';
import 'package:task_prioritizer/helpers.dart';

Widget taskCard(Task task) {
  return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 350.0),
      child: Card(
        elevation: 4.0, // You can adjust the elevation for a shadow effect
        margin: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.name,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(task.description),
              const SizedBox(height: 8.0),
              Text(textAlign:TextAlign.right, "${formatDate(task.dueDate)}  ${formatTime(dateTime:task.dueDate)}"),
              const SizedBox(height: 8.0),
              Center(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: Column(
                      children: [
                        Text("${formatDuration(task.timeSpent)} of ${formatDuration(task.requiredEstimate)} | ${formatDuration(task.requiredEstimate - task.timeSpent)} remaining"),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ));
}
