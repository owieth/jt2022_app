import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/services/workshops/workshops_service.dart';
import 'package:jt2022_app/widgets/shared/action_button.dart';
import 'package:jt2022_app/widgets/shared/navigation_button_widget.dart';
import 'package:provider/provider.dart';

class Workshop extends StatefulWidget {
  const Workshop({Key? key}) : super(key: key);

  @override
  State<Workshop> createState() => _WorkshopState();
}

class _WorkshopState extends State<Workshop> {
  bool isUserAlreadySignedUp = false;

  @override
  Widget build(BuildContext context) {
    Map _arguments = ModalRoute.of(context)!.settings.arguments as Map;

    final _workshop = _arguments['workshop'];
    isUserAlreadySignedUp = _arguments['isUserAlreadySignedUp'];
    final _user = Provider.of<User?>(context, listen: false);

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: _workshop.image,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 35,
            child: NavigationButton(
              icon: Icons.arrow_back_ios_new,
              onPressedButton: () => Navigator.pop(context),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 500,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.black.withAlpha(0),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_workshop.name,
                    style: Theme.of(context).textTheme.headline1),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  constraints: const BoxConstraints(maxHeight: 150),
                  child: SingleChildScrollView(
                    child: Text(_workshop.description,
                        style: Theme.of(context).textTheme.headline6),
                  ),
                ),
                const SizedBox(
                  height: 35.0,
                ),
                ActionButton(
                  buttonText: isUserAlreadySignedUp ? "Abmelden" : "Anmelden",
                  callback: () {
                    return _changeWorkshopAttendance(
                      _user!.uid,
                      _workshop.id,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _changeWorkshopAttendance(String userId, String _workshopId) {
    isUserAlreadySignedUp
        ? WorkshopsService().dropOutOfWorkshop(userId, _workshopId)
        : WorkshopsService().signUpForWorkshop(userId, _workshopId);

    Navigator.pop(context);
  }
}
