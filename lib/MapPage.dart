import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  MapPage({this.title, this.coordinates}) : super();
  final String title, coordinates;

  @override
  _MapPage createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
  MapController mapController = new MapController();
  var _geolocator = Geolocator();

  TextEditingController searchController = new TextEditingController();
  String address;
  List location = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          child: FlutterMap(
            mapController: mapController,
            options: MapOptions(
              minZoom: 1.0,
              maxZoom: 40.0,
            ),
            layers: [
              TileLayerOptions(
                  urlTemplate:
                      'https://api.mapbox.com/styles/v1/malhaq/cki2bf3lz57dv19nnl8liicyf/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibWFsaGFxIiwiYSI6ImNraHpmZDh2MTI4eGkyeHJtYXBod2RubXYifQ.Vbs18NTV60B1XwEWZwP0Lg',
                  additionalOptions: {
                    'accessToken':
                        'pk.eyJ1IjoibWFsaGFxIiwiYSI6ImNraHpmZDh2MTI4eGkyeHJtYXBod2RubXYifQ.Vbs18NTV60B1XwEWZwP0Lg',
                    'id': 'mapbox.mapbox-streets-v8'
                  }),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _geolocator.checkGeolocationPermissionStatus();
            await _geolocator.getCurrentPosition().then((value) async {
              List<Placemark> placemarks = await _geolocator
                  .placemarkFromCoordinates(value.latitude, value.longitude);
              setState(() {
                address = placemarks[0].administrativeArea +
                    ", " +
                    placemarks[0].country;
                location.add(address);
              });
              if (mapController.ready)
                mapController.move(
                    new LatLng(value.latitude, value.longitude), 14);
            });

            Navigator.of(context).pop(location);
          },
          child: Icon(Icons.my_location),
        ));
  }
}
