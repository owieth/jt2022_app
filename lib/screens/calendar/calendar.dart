import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/widgets/calendar_timeline_widget.dart';

class Calendar extends StatelessWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(35.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          SizedBox(
            height: 100,
            child: DatePicker(
              DateTime.now(),
              initialSelectedDate: DateTime.now(),
              selectionColor: Colors.black,
              dayTextStyle: TextStyle(color: Colors.white),
              monthTextStyle: TextStyle(color: Colors.white),
              dateTextStyle: TextStyle(color: Colors.white),
              daysCount: 3,
              onDateChange: (date) {},
            ),
          ),
          const CalendarTimeLine(),
        ],
      ),
    );

    // CalendarTimeline(
    //   initialDate: DateTime.now(),
    //   firstDate: DateTime.now(),
    //   lastDate: DateTime.now().add(const Duration(days: 3)),
    //   monthColor: Colors.white,
    //   dayColor: Colors.teal[200],
    //   activeDayColor: Colors.white,
    //   activeBackgroundDayColor: Colors.redAccent[100],
    //   dotsColor: const Color(0xFF333A47),
    //   locale: 'de',
    //   onDateSelected: (DateTime? _) => {},
    // ),
    //
  }
}
