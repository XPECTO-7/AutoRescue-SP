import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:provider/Constants/app_strings.dart';
class ManagePage extends StatefulWidget {
  const ManagePage({super.key});

  @override
  State<ManagePage> createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Row(
          children: [
            const Icon(
              Icons.verified_rounded,
              color: AppColors.appPrimary,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Manage Service',
              style: TextStyle(
                fontFamily: GoogleFonts.ubuntu().fontFamily,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child:   FlutterMap(
            
              options: MapOptions(
                  minZoom: 5,
                  maxZoom: 18,
                  initialZoom: 18,
                  // initialCenter: latlong.LatLng(
                  //     8.774774774774775, 76.8818346748862)
                  initialCenter: latlong.LatLng(
                   8.702702702702702,
                    76.77583118610511,
                  )
                  ),
              children: [
                TileLayer(
                  // urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  // subdomains: ['a', 'b', 'c'],
        
                  urlTemplate:
                      AppStrings.urlTemplate,
                  additionalOptions: {
                    'accessToken':
                       AppStrings.accessToken,
                    'id': AppStrings.id
                  },
                ),
                MarkerLayer(
                  markers: [],
                  // Marker(
                  //     point: latlong.LatLng(double.parse(lattitude),
                  //         double.parse(longitude)),
                  //     child: Icon(
                  //       Icons.man,
                  //       size: 36,
                  //       color: AppColors.aleartColor,
                  //     ))
                )
              ]),
      ),
    );
  }
}
