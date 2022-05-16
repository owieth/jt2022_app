import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:jt2022_app/models/workshop.dart';
import 'package:jt2022_app/services/workshops/workshops_service.dart';
import 'package:jt2022_app/widgets/shared/action_button.dart';
import 'package:jt2022_app/widgets/shared/navigation_button_widget.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class WorkshopPriority extends StatefulWidget {
  const WorkshopPriority({Key? key}) : super(key: key);

  @override
  State<WorkshopPriority> createState() => _WorkshopPriorityState();
}

class _WorkshopPriorityState extends State<WorkshopPriority> {
  late final User _user;
  late Future<List<Workshop>> _userWorkshops;
  List<Workshop> workshops = [];

  @override
  void initState() {
    super.initState();
    _user = Provider.of<User?>(context, listen: false)!;
    _userWorkshops = WorkshopsService().getUserWorkshops(_user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.w, 2.5.h, 10.w, 2.5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NavigationButton(
              icon: Icons.arrow_back_ios_new,
              onPressedButton: () => Navigator.pop(context),
            ),
            SizedBox(height: 5.h),
            FutureBuilder(
              future: _userWorkshops,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Workshop>> snapshot) {
                if (snapshot.hasData) {
                  SVProgressHUD.dismiss();
                  workshops = snapshot.data!;
                  return Expanded(
                    child: Center(
                      child: ReorderableListView.builder(
                        itemCount: workshops.length,
                        itemBuilder: (_, index) {
                          return Padding(
                            key: Key('$index'),
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Container(
                              child: _buildWorkshop(workshops[index]),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          );
                        },
                        proxyDecorator: (child, _, animation) {
                          return AnimatedBuilder(
                            child: child,
                            animation: animation,
                            builder: (_, __) {
                              final animValue =
                                  Curves.easeInOut.transform(animation.value);
                              final scale = lerpDouble(1, 1.05, animValue)!;
                              return Transform.scale(
                                scale: scale,
                                child: Material(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.transparent,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 20,
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Material(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                      ),
                                      child,
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        onReorder: (int oldIndex, int newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            final Workshop item = workshops.removeAt(oldIndex);
                            workshops.insert(newIndex, item);
                          });
                        },
                      ),
                    ),
                  );
                }

                SVProgressHUD.show();
                return Container();
              },
            ),
            ActionButton(
              buttonText: "Priorisierung speichern",
              callback: () async {
                WorkshopsService()
                    .changePriorityOfUserWorkshops(_user.uid, workshops);
                Navigator.pop(context, true);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkshop(Workshop workshop) {
    return ListTile(
      title: Text(workshop.name),
      trailing: const Icon(
        Icons.reorder,
        size: 15,
        color: Colors.white,
      ),
    );
  }
}
