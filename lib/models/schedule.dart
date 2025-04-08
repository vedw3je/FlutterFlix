class Schedule {
  final String time;
  final List days;

  const Schedule({
    required this.days,
    required this.time,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      time: json['time'] ?? '',
      days: List<String>.from(json['days'] ?? []),
    );
  }
}
