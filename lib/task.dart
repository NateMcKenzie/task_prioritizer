class Task implements Comparable {
  Duration requiredEstimate;
  Duration timeSpent;
  DateTime dueDate;
  String name;
  String description;

  Task(this.name, this.description, this.requiredEstimate, this.dueDate,
      this.timeSpent);

  Task.parse(String string)
      : name = '',
        description = '',
        requiredEstimate = Duration.zero,
        dueDate = DateTime.now(),
        timeSpent = Duration.zero {
    List<String> items = string.split(",");
    name = items[0];
    description = items[1];
    requiredEstimate = Duration(minutes: int.parse(items[2]));
    dueDate = DateTime.parse(items[3]);
    timeSpent = Duration(minutes: int.parse(items[4]));
  }

  @override
  int compareTo(other) {
    return getPriority().compareTo(other.getPriority());
  }

  //Possibly the trickiest part of this whole thing. Experiment as needed.
  int getPriority() {
    Duration timeLeft = dueDate.difference(DateTime.now());
    int minutesLeft = timeLeft.inMinutes;
    int minutesRequired = requiredEstimate.inMinutes - timeSpent.inMinutes;
    return minutesLeft - minutesRequired;
  }

  String toCSV() {
    String returnString = '$name,';
    returnString += ('$description,');
    returnString += ('${requiredEstimate.inMinutes},');
    returnString += ('$dueDate,');
    returnString += ('${timeSpent.inMinutes},');
    return returnString;
  }

  @override
  String toString() {
    String returnString = 'Task: $name\n';
    returnString += ('Description: $description\n');
    returnString += ('Required Estimate: $requiredEstimate\n');
    returnString += ('Due Date: $dueDate\n');
    returnString += ('Time Spent: $timeSpent\n');
    return returnString;
  }
}
