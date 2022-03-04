import 'package:flutter/material.dart';
import 'package:jt2022_app/screens/workshop/workshops.dart';
import 'package:jt2022_app/widgets/avatar_widget.dart';
import 'package:jt2022_app/widgets/text_overlay_widget.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  final int _workshopCount = 4;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(35, 70, 35, 0),
          child: Row(
            children: [
              const Avatar(radius: 30),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello there,',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      'Nina',
                      style: Theme.of(context).textTheme.subtitle1,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 50.0),
        Padding(
          padding: const EdgeInsets.only(left: 35),
          child: Text(
            'Workshops',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        const SizedBox(height: 20.0),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _workshopCount,
            itemBuilder: (BuildContext context, int index) {
              final _padding = index != _workshopCount - 1
                  ? const EdgeInsets.only(left: 35)
                  : const EdgeInsets.symmetric(horizontal: 35);

              return Stack(
                children: [
                  Padding(
                    padding: _padding,
                    child: Workshops(index: index),
                  ),
                  //const TextOverlay()
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 50.0),
        Padding(
          padding: const EdgeInsets.only(left: 35),
          child: Text(
            'Trending Workshops',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 20),
                scrollDirection: Axis.vertical,
                itemCount: 2,
                itemBuilder: (BuildContext context, int index) {
                  return Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 35),
                        height: 200,
                        //width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                          image: DecorationImage(
                              image: AssetImage('assets/images/church.jpeg'),
                              fit: BoxFit.cover),
                        ),
                      ),
                      const TextOverlay()
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
