import 'package:flutter/material.dart';

class CalendarItem extends StatefulWidget {
  final bool isActive;
  final String date;
  final String day;
  final Function emitClick;

  const CalendarItem({
    Key? key,
    required this.isActive,
    required this.date,
    required this.day,
    required this.emitClick,
  }) : super(key: key);

  @override
  State<CalendarItem> createState() => _CalendarItemState();
}

class _CalendarItemState extends State<CalendarItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.emitClick(widget.date),
      child: Container(
        height: 80.0,
        width: 60.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: widget.isActive ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.date,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(
                widget.day,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
