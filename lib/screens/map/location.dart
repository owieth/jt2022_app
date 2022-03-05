import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location extends StatefulWidget {
  const Location({Key? key}) : super(key: key);

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  final Completer<GoogleMapController> _controller = Completer();

  final CameraPosition _campus =
      const CameraPosition(target: LatLng(46.663370, 7.275294), zoom: 17.5);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.satellite,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      initialCameraPosition: _campus,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }
}
