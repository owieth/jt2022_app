import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:jt2022_app/models/numbers.dart';
import 'package:jt2022_app/models/user.dart';
import 'package:jt2022_app/services/users/users_service.dart';
import 'package:jt2022_app/widgets/shared/avatar_widget.dart';
import 'package:jt2022_app/widgets/shared/navigation_button_widget.dart';

class Members extends StatefulWidget {
  const Members({Key? key}) : super(key: key);

  @override
  State<Members> createState() => _MembersState();
}

class _MembersState extends State<Members> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leadingWidth: 150,
        leading: NavigationButton(
          icon: Icons.arrow_back_ios_new,
          onPressedButton: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35.0),
        child: ListView(
          children: [
            const SizedBox(height: 30.0),
            Text(
              'Wichtige Nummern',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 15.0),
            SizedBox(
              height: 200,
              child: Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildImportantNumbers(),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Text(
              'C4MP Teilnehmer',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 15.0),
            FutureBuilder(
              future: UserService().getAllUsers(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<CustomUser>> snapshot) {
                if (snapshot.hasData) {
                  SVProgressHUD.dismiss();
                  List<CustomUser> users = snapshot.data!;
                  return Column(
                    children: List.from(
                      users.map(
                        (user) => Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ListTile(
                            leading: Avatar(
                              radius: user.photoUrl != '' ? 30 : 28,
                              image: user.photoUrl != '' ? user.photoUrl : null,
                            ),
                            title: Text(user.name),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                SVProgressHUD.show();
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildImportantNumbers() {
    final List<ImportantNumbers> _numbers = [
      ImportantNumbers("Feuerwehr", "118"),
      ImportantNumbers("Polizei", "117"),
      ImportantNumbers("Sanität", "144"),
      ImportantNumbers("Yasmin Bühlmann", "079 669 48 39"),
      ImportantNumbers("Tania Doppmann", "079 669 48 39"),
    ];

    return List.from(
      _numbers.map(
        (entry) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              entry.name,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              entry.phoneNumber,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}