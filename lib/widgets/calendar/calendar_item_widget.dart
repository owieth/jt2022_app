import 'package:flutter/material.dart';

class CalendarItem extends StatefulWidget {
  const CalendarItem({Key? key}) : super(key: key);

  @override
  State<CalendarItem> createState() => _CalendarItemState();
}

class _CalendarItemState extends State<CalendarItem> {
  //final _dateFromat = DateFormat("dd/MM/yyyy");

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 60.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0), color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateTime.parse("2022-09-09").toString()),
            const Text('Fri'),
          ],
        ),
      ),
    );
  }
}
