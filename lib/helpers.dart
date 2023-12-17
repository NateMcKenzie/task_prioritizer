String formatDuration(Duration duration) {
  int hours = duration.inHours;
  int minutes = (duration.inMinutes % 60).toInt();

  String formattedDuration = '$hours h $minutes min';
  return formattedDuration;
}
