import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/models/workshop.dart';
import 'package:jt2022_app/services/workshops/workshops_service.dart';
import 'package:jt2022_app/util/dates.dart';
import 'package:jt2022_app/widgets/shared/avatar_widget.dart';
import 'package:timelines/timelines.dart';

const activeTile = 0;

class CalendarTimeLine extends StatefulWidget {
  final String date;

  const CalendarTimeLine({Key? key, required this.date}) : super(key: key);

  @override
  State<CalendarTimeLine> createState() => _CalendarTimeLineState();
}

class _CalendarTimeLineState extends State<CalendarTimeLine> {
  Stream<List<Workshop>> _getCalendarEntries() {
    DateTime _formatedDate = Dates().parseDate(widget.date);
    final _user = FirebaseAuth.instance.currentUser;
    return WorkshopsService().getUserWorkshopsByDay(_formatedDate, _user!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _getCalendarEntries(),
      builder: (BuildContext context, AsyncSnapshot<List<Workshop>> workshop) {
        if (workshop.connectionState == ConnectionState.done) {
          return Flexible(
            child: Timeline.tileBuilder(
              theme: TimelineThemeData(
                nodePosition: 0,
                connectorTheme: const ConnectorThemeData(
                  color: Colors.white,
                ),
                indicatorTheme: const IndicatorThemeData(
                  size: 15.0,
                ),
              ),
              builder: TimelineTileBuilder.connected(
                contentsBuilder: (_, index) =>
                    CalendarEntry(workshop: workshop.data![index]),
                connectorBuilder: (_, __, ___) => const SolidLineConnector(),
                indicatorBuilder: (_, index) {
                  if (index == activeTile) {
                    return const OutlinedDotIndicator(
                      color: Colors.white,
                    );
                  }

                  return const DotIndicator(color: Colors.white);
                },
                itemExtent: 150,
                itemCount: workshop.data?.length ?? 0,
              ),
            ),
          );
        } else {
          // TODO Emtpy State?
          return const Text("jdsflökjasdölf");
        }
      },
    );
  }
}

class CalendarEntry extends StatelessWidget {
  final Workshop workshop;

  const CalendarEntry({Key? key, required this.workshop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30.0),
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0), color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(workshop.name),
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    width: 60,
                    height: 25,
                    color: Colors.blue[200],
                    child: Center(
                        child: Text(
                      workshop.attendees.length.toString(),
                    )),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Avatar(radius: 15),
                Text("${workshop.startTime} - ${workshop.endTime}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
