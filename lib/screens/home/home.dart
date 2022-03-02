import 'package:flutter/material.dart';
import 'package:jt2022_app/screens/workshop/workshops.dart';
import 'package:jt2022_app/widgets/avatar_widget.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  final int _workshopCount = 4;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(35, 70, 35, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                // onTap: () => Navigator.pushNamed(context, '/profile'),
                onTap: () {},
                child: const Avatar(radius: 30),
              ),
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
          const SizedBox(height: 50.0),
          Text(
            'Workshops',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(height: 20.0),
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
          const SizedBox(height: 50.0),
          Text(
            'Trending Workshops',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(height: 20.0),
          Container(
            //margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              color: Colors.black,
              image: DecorationImage(
                  image: AssetImage('assets/images/church.jpeg'),
                  fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}
