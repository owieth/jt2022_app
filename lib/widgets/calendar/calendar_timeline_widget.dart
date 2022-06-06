import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:jt2022_app/constants/colors.dart';
import 'package:jt2022_app/constants/houses.dart';
import 'package:jt2022_app/models/workshop.dart';
import 'package:jt2022_app/services/workshops/workshops_service.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:timelines/timelines.dart';

const activeTile = 0;

class CalendarTimeLine extends StatelessWidget {
  final String date;

  const CalendarTimeLine({Key? key, required this.date}) : super(key: key);

  Future<List<Workshop>> _getCalendarEntries() {
    final _user = FirebaseAuth.instance.currentUser;
    return WorkshopsService().getUserWorkshopsByDay(date, _user!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getCalendarEntries(),
      builder: (BuildContext context, AsyncSnapshot<List<Workshop>> workshop) {
        if (workshop.connectionState == ConnectionState.waiting) {
          SVProgressHUD.show();
          return Container();
        }

        final _itemCount = workshop.data?.length ?? 0;

        SVProgressHUD.dismiss();

        return _itemCount == 0
            ? Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Image.asset('assets/images/empty.jpeg'),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Keine Termine gefunden!",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    )
                  ],
                ),
              )
            : Flexible(
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
                    connectorBuilder: (_, __, ___) =>
                        const SolidLineConnector(),
                    indicatorBuilder: (_, index) =>
                        const DotIndicator(color: Colors.white),
                    itemExtent: 150,
                    itemCount: _itemCount,
                  ),
                ),
              );
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
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 40.w),
                  child: SingleChildScrollView(
                    child: Text(
                      workshop.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    width: 60,
                    height: 25,
                    color: CustomColors.primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            workshop.attendees.length.toString(),
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          const Icon(
                            LineIcons.user,
                            size: 16,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      LineIcons.mapMarker,
                      size: 16,
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 30.w),
                      child: SingleChildScrollView(
                        child: Text(
                          "${Houses().houses.firstWhere((house) => house['key'] == workshop.house)['value']}",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                Text("${workshop.startTime} - ${workshop.endTime}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
