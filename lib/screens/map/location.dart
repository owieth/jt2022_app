import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as lat_lng;
import 'package:flutter_svg/flutter_svg.dart';

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
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/church.jpeg',
                        height: 75,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Bern Süd',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Text(
                          'Bümpliz',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ],
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
                zoom: 17.75,
                center: lat_lng.LatLng(46.663370, 7.275294),
                // bounds: LatLngBounds(
                //   lat_lng.LatLng(46.661362, 7.271638),
                //   lat_lng.LatLng(46.665130, 7.279211),
                // ),
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
    List<lat_lng.LatLng> coordinates = [
      lat_lng.LatLng(46.663370, 7.275294),
      lat_lng.LatLng(46.662973, 7.275370),
      lat_lng.LatLng(46.663235, 7.276022),
    ];

    return coordinates
        .map((location) => Marker(
              height: 50,
              width: 50,
              point: location,
              builder: (_) => InkWell(
                //onTap: () => _pageController.animateToPage(page, duration: duration, curve: curve),
                onTap: () {},
                child: SvgPicture.asset(
                  'assets/icon/marker.svg',
                ),
              ),
            ))
        .toList();
  }
}
