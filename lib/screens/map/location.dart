import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart' as lat_lng;
import 'package:line_icons/line_icons.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Location extends StatefulWidget {
  const Location({Key? key}) : super(key: key);

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  final double _initFabHeight = 120.0;
  double _buttonPositon = 0;
  double _maxPanelHeight = 0;

  @override
  void initState() {
    super.initState();

    _buttonPositon = _initFabHeight;
  }

  @override
  Widget build(BuildContext context) {
    _maxPanelHeight = MediaQuery.of(context).size.height * .30;

    return Material(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          SlidingUpPanel(
            maxHeight: _maxPanelHeight,
            minHeight: 100,
            color: Theme.of(context).scaffoldBackgroundColor,
            parallaxEnabled: true,
            parallaxOffset: 0.25,
            body: _buildMap(),
            panelBuilder: (ScrollController scrollController) =>
                _panel(scrollController),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            onPanelSlide: (double pos) => setState(() => _buttonPositon =
                pos * (_maxPanelHeight - 95.0) + _initFabHeight),
          ),
          Positioned(
            right: 15.0,
            bottom: _buttonPositon,
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  shape: const CircleBorder(),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.0, bottom: 2.0),
                  child: RotationTransition(
                    turns: const AlwaysStoppedAnimation(45 / 360),
                    child: Icon(
                      LineIcons.locationArrow,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _panel(ScrollController scrollController) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        controller: scrollController,
        children: <Widget>[
          const SizedBox(
            height: 12.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 30,
                height: 5,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
              ),
            ],
          ),
          const SizedBox(
            height: 18.0,
          ),
          _buildWorkshops(),
          _buildWorkshops(),
          _buildWorkshops(),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
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
    );
  }

  List<Marker> _buildMapMarkers() {
    List<lat_lng.LatLng> coordinates = [
      lat_lng.LatLng(46.663370, 7.275294),
      lat_lng.LatLng(46.662973, 7.275370),
      lat_lng.LatLng(46.663235, 7.276022),
    ];

    return coordinates
        .map(
          (location) => Marker(
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
          ),
        )
        .toList();
  }

  _buildWorkshops() {
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
  }
}
