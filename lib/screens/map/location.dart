import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;

class Location extends StatefulWidget {
  const Location({Key? key}) : super(key: key);

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height - 255),
          itemCount: 5,
          itemBuilder: (_, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: Card(
                elevation: 10,
                child: ListTile(
                  leading: Image.asset('assets/images/church.jpeg'),
                  title: const Text('I like icecream'),
                ),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 200),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(40)),
            child: FlutterMap(
              options: MapOptions(
                minZoom: 5,
                maxZoom: 18,
                zoom: 17.6,
                center: latLng.LatLng(46.663370, 7.275294),
              ),
              nonRotatedLayers: [
                TileLayerOptions(
                  urlTemplate:
                      'https://api.mapbox.com/styles/v1/mapbox/dark-v10/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}',
                  additionalOptions: {
                    'accessToken':
                        'pk.eyJ1Ijoib3J0ZXhoZCIsImEiOiJjbDFsMmZ3N2UwMWthM2NxcjY3cGFvNjJ2In0.-4xH_hTNDBZQVwGvdY0-UQ'
                  },
                ),
                MarkerLayerOptions(markers: _buildMapMarkers()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Marker> _buildMapMarkers() {
    List<latLng.LatLng> coordinates = [
      latLng.LatLng(46.663370, 7.275294),
      latLng.LatLng(46.662973, 7.275370),
      latLng.LatLng(46.663235, 7.276022),
    ];

    return coordinates
        .map((location) => Marker(
              height: 50,
              width: 50,
              point: location,
              builder: (_) => InkWell(
                onTap: () {},
                child: Image.asset('assets/icon/marker.png'),
              ),
            ))
        .toList();
  }
}
