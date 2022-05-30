import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:jt2022_app/models/numbers.dart';
import 'package:jt2022_app/models/user.dart';
import 'package:jt2022_app/services/users/users_service.dart';
import 'package:jt2022_app/widgets/shared/avatar_widget.dart';
import 'package:jt2022_app/widgets/shared/navigation_button_widget.dart';
import 'package:line_icons/line_icons.dart';

class Members extends StatefulWidget {
  const Members({Key? key}) : super(key: key);

  @override
  State<Members> createState() => _MembersState();
}

class _MembersState extends State<Members> {
  bool _showBackToTopButton = false;
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >= 400) {
            _showBackToTopButton = true;
          } else {
            _showBackToTopButton = false;
          }
        });
      });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
          controller: _scrollController,
          children: [
            const SizedBox(height: 30.0),
            Text(
              'Wichtige Nummern',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 15.0),
            SizedBox(
              height: 150,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildImportantNumbers(),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Text(
              'C4MP Teilnehmer:innen',
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
                          child: InkWell(
                            onTap: () => _showSimpleDialog(user),
                            child: ListTile(
                              leading: Avatar(
                                radius: 30,
                                image:
                                    user.photoUrl != '' ? user.photoUrl : null,
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user.name),
                                  Text(
                                    '${user.region} - ${user.muncipality}',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ],
                              ),
                            ),
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
      floatingActionButton: _showBackToTopButton == false
          ? null
          : SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _scrollToTop,
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  shape: const CircleBorder(),
                ),
                child: Icon(
                  LineIcons.arrowUp,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
    );
  }

  List<Widget> _buildImportantNumbers() {
    final List<ImportantNumbers> _numbers = [
      ImportantNumbers("Feuerwehr", "118"),
      ImportantNumbers("Polizei", "117"),
      ImportantNumbers("Sanität", "144"),
      ImportantNumbers("Yasmin Bühlmann", "079 555 10 51"),
      ImportantNumbers("Tania Doppmann", "079 532 76 18"),
      ImportantNumbers("Olivier Winkler", "078 652 77 00"),
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

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(seconds: 2),
      curve: Curves.linear,
    );
  }

  Future<void> _showSimpleDialog(CustomUser user) async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.white, width: 1),
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Avatar(
                    radius: 50,
                    image: user.photoUrl != '' ? user.photoUrl : null,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: SingleChildScrollView(
                      child: Text(
                        user.name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: SingleChildScrollView(
                      child: Text(
                        user.region,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: SingleChildScrollView(
                      child: Text(
                        user.muncipality,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }
}
