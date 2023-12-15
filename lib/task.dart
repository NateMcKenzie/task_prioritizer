class Task implements Comparable {
  Duration requiredEstimate;
  Duration timeSpent;
  DateTime dueDate;
  String name;
  String description;

  Task(this.name, this.description, this.requiredEstimate, this.dueDate,
      this.timeSpent);

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