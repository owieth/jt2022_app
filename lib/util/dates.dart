import 'package:intl/intl.dart';

class Dates {
  DateTime parseDate(String date) {
    return DateFormat('d/M/y').parse('$date/09/2022');
  }

  String formatDate(DateTime date) {
    return DateFormat.Hm().format(date);
  }
}
