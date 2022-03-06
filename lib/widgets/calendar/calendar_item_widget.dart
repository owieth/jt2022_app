import 'package:flutter/material.dart';

class CalendarItem extends StatefulWidget {
  final String date;
  final String day;
  final Function emitClick;

  const CalendarItem(
      {Key? key,
      required this.date,
      required this.day,
      required this.emitClick})
      : super(key: key);

  @override
  State<CalendarItem> createState() => _CalendarItemState();
}

class _CalendarItemState extends State<CalendarItem> {
  //final _dateFromat = DateFormat("dd/MM/yyyy");

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.emitClick(widget.date),
      child: Container(
        height: 80,
        width: 60.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0), color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.date),
              Text(widget.day),
            ],
          ),
        ),
      ),
    );
  }
}
