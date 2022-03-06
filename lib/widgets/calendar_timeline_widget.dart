import 'package:flutter/material.dart';
import 'package:jt2022_app/widgets/avatar_widget.dart';
import 'package:timelines/timelines.dart';

const kTileHeight = 50.0;
const activeTile = 0;
const _defaultColor = Colors.white;

class CalendarTimeLine extends StatelessWidget {
  const CalendarTimeLine({Key? key}) : super(key: key);

  final _test = Colors.white;

  @override
  Widget build(BuildContext context) {
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
          contentsBuilder: (_, __) => _CalendarEntry(),
          connectorBuilder: (_, index, __) {
            return const SolidLineConnector();
          },
          indicatorBuilder: (_, index) {
            if (index == activeTile) {
              return const OutlinedDotIndicator(
                color: Colors.white,
              );
            }

            return const DotIndicator(color: Colors.white);
          },
          itemExtent: 200,
          itemCount: 4,
        ),
      ),
    );
  }
}

class _CalendarEntry extends StatelessWidget {
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
                const Text("Speeddating"),
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    width: 60,
                    height: 25,
                    color: Colors.blue[200],
                    child: const Center(
                      child: Text("64"),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Avatar(radius: 15),
                Text("09:00 - 10:00"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
