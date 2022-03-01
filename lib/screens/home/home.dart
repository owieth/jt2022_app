import 'package:flutter/material.dart';
import 'package:jt2022_app/screens/workshops.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  final int _workshopCount = 4;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 35, top: 70),
          child: Row(
            children: [
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/profile'),
                child: const CircleAvatar(
                    backgroundColor: Colors.black, radius: 30),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [Text('Hello there,'), Text('Nina')],
              )
            ],
          ),
        ),
        Text('Workshops'),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _workshopCount,
            itemBuilder: (BuildContext context, int index) {
              return Workshops(index: index);
            },
          ),
        ),
        Text('Trending Workshops'),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          height: 200,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
