import 'package:calendar_timeline/calendar_timeline.dart';
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
          CalendarTimeline(
            initialDate: DateTime(2022, 9, 8),
            firstDate: DateTime(2022, 9, 8),
            lastDate: DateTime(2022, 9, 11),
            monthColor: Colors.white,
            dayColor: Colors.teal[200],
            activeDayColor: Colors.white,
            activeBackgroundDayColor: Colors.redAccent[100],
            //dotsColor: const Color(0xFF333A47),
            locale: 'de',
            onDateSelected: (DateTime? _) => {},
          ),
          const CalendarTimeLine(),
        ],
      ),
    );

    // return Padding(
    //   padding: const EdgeInsets.all(35.0),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.end,
    //     children: [
    //       SizedBox(
    //         height: 200,
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: const <Widget>[
    //             CalendarItem(),
    //             SizedBox(width: 50),
    //             CalendarItem(),
    //             SizedBox(width: 50),
    //             CalendarItem(),
    //           ],
    //         ),
    //       ),
    //       const CalendarTimeLine(),
    //     ],
    //   ),
    // );

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
