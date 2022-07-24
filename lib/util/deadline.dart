class Deadline {
  bool isDeadline() {
    DateTime now = DateTime.now();
    DateTime deadline = DateTime(2022, 08, 02, 18, 00, 00);

    if (now.isAtSameMomentAs(deadline) || now.isAfter(deadline)) return true;

    return false;
  }
}
