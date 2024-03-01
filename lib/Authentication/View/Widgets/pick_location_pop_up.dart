import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:provider/Colors/appcolor.dart';
import 'package:provider/Constants/app_strings.dart';
class PinLocationMap extends StatelessWidget {
  final double currentLocationX, currentLocationY;
  
  final Function(TapPosition, latlong.LatLng)? onTap;
  const PinLocationMap(
      {required this.onTap,
      required this.currentLocationX,
      required this.currentLocationY,
      super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child:   FlutterMap(
                options: MapOptions(
                    onTap: onTap,
                    initialZoom: 13,
                    initialCenter: latlong.LatLng(currentLocationX, currentLocationY)),
                children: [
                  TileLayer(
                    urlTemplate:
                       AppStrings.urlTemplate,
                    additionalOptions: {
                      'accessToken':
                          AppStrings.accessToken,
                      'id': AppStrings.id
                    },
                  ),
                  
                ]),
    );
  }
}
