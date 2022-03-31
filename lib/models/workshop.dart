class Workshop {
  final String id;
  final List<String> attendees;
  final String date;
  final String endTime;
  final String starTime;
  final String image;
  final String name;

  Workshop({
    required this.id,
    required this.attendees,
    required this.date,
    required this.endTime,
    required this.starTime,
    required this.image,
    required this.name,
  });
}
