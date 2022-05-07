import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:jt2022_app/models/workshop.dart';
import 'package:jt2022_app/services/workshops/workshops_service.dart';
import 'package:latlong2/latlong.dart' as lat_lng;
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

  final List _elements = [
    {'workshopName': 'Workshop 1', 'floor': 'EG'},
    {'workshopName': 'Workshop 2', 'floor': 'EG'},
    {'workshopName': 'Workshop 3', 'floor': '1. OG'},
    {'workshopName': 'Workshop 4', 'floor': '1. OG'},
    {'workshopName': 'Workshop 5', 'floor': '2. OG'},
    {'workshopName': 'Workshop 6', 'floor': '2. OG'},
  ];

  @override
  Widget build(BuildContext context) {
    _maxPanelHeight = MediaQuery.of(context).size.height * .30;

    return Material(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
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
        children: [
          const SizedBox(
            height: 12.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 5,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                ),
              ),
            ],
          ),
          FutureBuilder(
            future: WorkshopsService().workshops,
            builder:
                (BuildContext context, AsyncSnapshot<List<Workshop>> snapshot) {
              if (snapshot.hasData) {
                SVProgressHUD.dismiss();
                List<Workshop> workshops = snapshot.data!;
                return _buildWorkshops(workshops);
              }

              SVProgressHUD.show();
              return Container();
            },
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
      ),
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
      lat_lng.LatLng(46.663960, 7.275372),
      lat_lng.LatLng(46.663920, 7.276075),
      lat_lng.LatLng(46.663454, 7.274467),
      lat_lng.LatLng(46.663050, 7.275300),
      lat_lng.LatLng(46.663300, 7.275963),
    ];

    return coordinates
        .mapIndexed(
          (index, location) => Marker(
            height: _selectedMarkerIndex == index ? 60 : 50,
            width: 50,
            point: location,
            builder: (_) => InkWell(
              onTap: () => setState(() {
                _selectedMarkerIndex = index;
              }),
              child: SvgPicture.asset(
                'assets/icon/marker.svg',
              ),
            ),
          ),
        )
        .toList();
  }

  Widget _buildWorkshops(List<Workshop> workshop) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
      child: GroupedListView<dynamic, String>(
        shrinkWrap: true,
        elements: _elements,
        groupBy: (element) => element['floor'],
        // groupComparator: (currentFloor, previousFloor) =>
        //     previousFloor.compareTo(currentFloor),
        // itemComparator: (currentFloor, previousFloor) =>
        //     currentFloor['workshopName']
        //         .compareTo(previousFloor['workshopName']),
        //order: GroupedListOrder.ASC,
        groupSeparatorBuilder: (String value) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Text(
            value,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        separator: const SizedBox(height: 20),
        itemBuilder: (c, element) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/church.jpeg',
                  height: 75,
                ),
              ),
              Text(
                element['workshopName'],
                style: Theme.of(context).textTheme.bodyText1,
              ),
              // SizedBox(
              //   height: 100,
              //   width: 100,
              //   child: CachedNetworkImage(
              //     imageUrl: workshop.image,
              //     imageBuilder: (context, imageProvider) => Container(
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(25.0),
              //         image: DecorationImage(
              //           image: imageProvider,
              //           fit: BoxFit.cover,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // Container(
              //   constraints: const BoxConstraints(maxWidth: 100),
              //   child: SingleChildScrollView(
              //     child: Text(workshop.name,
              //         overflow: TextOverflow.ellipsis,
              //         style: Theme.of(context).textTheme.bodyText1),
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }
}
