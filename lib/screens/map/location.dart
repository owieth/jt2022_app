import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:jt2022_app/constants/houses.dart';
import 'package:jt2022_app/models/workshop.dart';
import 'package:jt2022_app/services/workshops/workshops_service.dart';
import 'package:latlong2/latlong.dart' as lat_lng;
import 'package:sizer/sizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:collection/collection.dart';

class Location extends StatefulWidget {
  const Location({Key? key}) : super(key: key);

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  int _selectedMarkerIndex = -1;
  double _maxPanelHeight = 0;

  final mapStyle =
      'https://api.mapbox.com/styles/v1/mapbox/dark-v10/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}';
  final accessToken =
      'pk.eyJ1Ijoib3J0ZXhoZCIsImEiOiJjbDFsMmZ3N2UwMWthM2NxcjY3cGFvNjJ2In0.-4xH_hTNDBZQVwGvdY0-UQ';

  @override
  Widget build(BuildContext context) {
    _maxPanelHeight = MediaQuery.of(context).size.height * .30;

    return Material(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          SlidingUpPanel(
            minHeight: _maxPanelHeight,
            isDraggable: false,
            color: Theme.of(context).scaffoldBackgroundColor,
            parallaxEnabled: true,
            parallaxOffset: 0.25,
            body: _buildMap(),
            panelBuilder: (_) => _panel(),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _panel() {
    return _selectedMarkerIndex != -1
        ? MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: FutureBuilder(
              future: WorkshopsService().workshops,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Workshop>> snapshot) {
                if (snapshot.hasData) {
                  SVProgressHUD.dismiss();
                  List<Workshop> workshops = snapshot.data!;
                  return _buildWorkshops(workshops);
                }

                SVProgressHUD.show();
                return Container();
              },
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Markierung auswählen!',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
          );
  }

  Widget _buildMap() {
    return FlutterMap(
      options: MapOptions(
          minZoom: 17.75,
          maxZoom: 17.75,
          zoom: 17.75,
          center: lat_lng.LatLng(46.663370, 7.275294),
          swPanBoundary: lat_lng.LatLng(46.662652, 7.273872),
          nePanBoundary: lat_lng.LatLng(46.664910, 7.278258),
          onTap: (_, __) => setState(() => _selectedMarkerIndex = -1)),
      nonRotatedLayers: [
        TileLayerOptions(
          urlTemplate: mapStyle,
          additionalOptions: {'accessToken': accessToken},
        ),
        MarkerLayerOptions(markers: _buildMapMarkers()),
      ],
    );
  }

  List<Marker> _buildMapMarkers() {
    List<lat_lng.LatLng> coordinates = [
      lat_lng.LatLng(46.663300, 7.275963),
      lat_lng.LatLng(46.663454, 7.274467),
      lat_lng.LatLng(46.663050, 7.275300),
      lat_lng.LatLng(46.663960, 7.275372),
      lat_lng.LatLng(46.663920, 7.276075),
    ];

    return coordinates
        .mapIndexed(
          (index, location) => Marker(
            height: _selectedMarkerIndex == index ? 60 : 50,
            width: 50,
            point: location,
            builder: (_) => InkWell(
              onTap: () => setState(() => _selectedMarkerIndex = index),
              child: SvgPicture.asset(
                'assets/icon/marker.svg',
              ),
            ),
          ),
        )
        .toList();
  }

  Widget _buildWorkshops(List<Workshop> workshops) {
    final workshopsByHouse =
        workshops.where((workshop) => workshop.house == _selectedMarkerIndex);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
      child: Column(
        children: [
          Text(
            Houses().houses.firstWhere(
                (house) => house['key'] == _selectedMarkerIndex)['value'],
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: _maxPanelHeight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: ListView.separated(
                itemCount: workshopsByHouse.length,
                itemBuilder: ((context, index) {
                  return Row(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: CachedNetworkImage(
                          imageUrl: workshops[index].image,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: 45.w),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                workshops[index].name,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Text(
                                "${workshops[index].startTime} - ${workshops[index].endTime}",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                separatorBuilder: (_, __) => const SizedBox(height: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
