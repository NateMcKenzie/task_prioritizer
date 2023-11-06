class Task implements Comparable {
  Duration requiredEstimate;
  Duration timeSpent;
  DateTime dueDate;
  String name;
  String description;

  Task(this.name, this.description, this.requiredEstimate, this.dueDate, this.timeSpent);

  //Possibly the trickiest part of this whole thing. Experiment as needed.
  @override
  int compareTo(other) {
    return dueDate.compareTo(other.dueDate);
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
