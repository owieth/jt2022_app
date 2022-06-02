import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CalendarItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => emitClick(date),
      child: Container(
        height: 10.h,
        width: 15.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: isActive ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(
                day,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
