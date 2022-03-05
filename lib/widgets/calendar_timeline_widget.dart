import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

const kTileHeight = 50.0;
const activeTile = 0;

class CalendarTimeLine extends StatelessWidget {
  const CalendarTimeLine({Key? key}) : super(key: key);

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
          contentsBuilder: (_, __) => _EmptyContents(),
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

class _EmptyContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30.0),
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0), color: Colors.white),
    );
  }
}
