import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:jt2022_app/models/calendar_item_model.dart';
import 'package:jt2022_app/widgets/calendar/calendar_item_widget.dart';
import 'package:jt2022_app/widgets/calendar_timeline_widget.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  String _activeDay = "10";

  final List<CalendarItemModel> _calendarItems = [
    CalendarItemModel("08", "Thu"),
    CalendarItemModel("09", "Fri"),
    CalendarItemModel("10", "Sat"),
    CalendarItemModel("11", "Sun"),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 35.0, top: 70.0, right: 35.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "September $_activeDay",
            style: Theme.of(context).textTheme.headline1,
          ),
          SizedBox(
            height: 125,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _calendarItems
                  .mapIndexed((index, item) => _buildCalendarItem(index, item))
                  .toList(),
            ),
          ),
          CalendarTimeLine(
            date: _activeDay,
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarItem(int index, CalendarItemModel item) {
    return CalendarItem(
      isActive: _calendarItems[index].date == _activeDay,
      date: item.date,
      day: item.day,
      emitClick: (date) => setState(() => _activeDay = date),
    );
  }
}
