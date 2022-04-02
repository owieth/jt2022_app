class Workshop {
  final String id;
  final List<String> attendees;
  final String description;
  final String date;
  final String endTime;
  final String startTime;
  final String image;
  final String name;

  Workshop({
    required this.id,
    required this.attendees,
    required this.description,
    required this.date,
    required this.endTime,
    required this.startTime,
    required this.image,
    required this.name,
  });
}
