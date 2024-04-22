import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:provider/Colors/appcolor.dart';
import 'package:provider/Constants/app_strings.dart';

class GetLocationPage extends StatelessWidget {
  final double currentLocationX, currentLocationY;

  const GetLocationPage({
    Key? key,
    required this.currentLocationX,
    required this.currentLocationY,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: FlutterMap(
            options: MapOptions(
              initialZoom: 18,
              initialCenter: latlong.LatLng(currentLocationX, currentLocationY),
            ),
            children: [
              MarkerLayer(markers: [
                Marker(
                    point: latlong.LatLng(currentLocationX, currentLocationY),
                    child: const Icon(Icons.location_on,color: Colors.greenAccent,size: 25,))
              ]),
              TileLayer(
                urlTemplate: AppStrings.urlTemplate,
                additionalOptions: const {
                  'accessToken': AppStrings.accessToken,
                  'id': AppStrings.id,
                },
              ),
            ],
          ),
        ),
        const Positioned(
          top: 32, // Adjust this value to position the text vertically
          left: 16.0, // Adjust this value to position the text horizontally
          child: Text(
            'Location Detected',
            style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                backgroundColor: Colors.greenAccent),
          ),
        ),
      ],
    );
  }
}
