import 'package:flutter/material.dart';
import 'package:jt2022_app/models/calendar_item_model.dart';
import 'package:jt2022_app/widgets/calendar/calendar_item_widget.dart';
import 'package:jt2022_app/widgets/calendar_timeline_widget.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  String _activeDay = "09";

  final List<CalendarItemModel> _calendarItems = [
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
          Flexible(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _calendarItems.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildCalendarItem(_calendarItems[index]);
              },
            ),
          ),
          // SizedBox(
          //   height: 200,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: _calendarItems
          //         .map((item) => _buildCalendarItem(item))
          //         .toList(),
          //   ),
          // ),
          const CalendarTimeLine(),
        ],
      ),
    );
  }

  Widget _buildCalendarItem(CalendarItemModel item) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
      child: CalendarItem(
        date: item.date,
        day: item.day,
        emitClick: (date) => (setState(
          () {
            _activeDay = date;
          },
        )),
      ),
    );
  }
}
