class Deadline {
  bool isDeadline() {
    DateTime now = DateTime.now();
    DateTime deadline = DateTime(2022, 07, 31, 12, 00, 00);

    if (now.isAtSameMomentAs(deadline) || now.isAfter(deadline)) return true;

    return false;
  }
}
