import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/Authentication/Controller/testing.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:provider/Constants/app_strings.dart';
import 'package:provider/Pages/Components/custom_button.dart';
import 'package:provider/Pages/Components/text_area_simple.dart';
import 'package:provider/Pages/View/req_service.dart';

class ManagePage extends StatefulWidget {
  final String servicetype, vehicleID, userEmail;

  const ManagePage(
      {super.key,
      required this.servicetype,
      required this.vehicleID,
      required this.userEmail});

  @override
  State<ManagePage> createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  bool isLoading = false;
  Position? position;
  String service = "";
  List<Marker> services = [];

  @override
  void initState() {
    // TODO: implement initState
    getCurrentLocation();
    super.initState();
  }

  void getCurrentLocation() async {
    setState(() {
      isLoading = true;
    });
    if (widget.servicetype == "TYRE WORKS" ||
        widget.servicetype == "KEY LOCKOUT") {
      setState(() {
        service = "Mechanical Service";
      });
    } else {
      setState(() {
        service = widget.servicetype;
      });
    }
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    setState(() {
      isLoading = false;
    });
  }

  void getServiceLocations(
      {required List<dynamic> providerList,
      required String lattitude,
      required String longitude}) async {
    String asset = "";
    List providers = providerList;

    providerList.forEach(
      (element) {
        switch (element["Service Type"]) {
          case "Fuel Delivery Service":
            asset = "lib/images/fuel.png";
            break;
          case "Mechanical Service":
            asset = "lib/images/automotive.png";
            break;
          case "Emergency Towing service":
            asset = "lib/images/tow-truck.png";
            break;
          case "EV Charging service":
            asset = "lib/images/charging-station.png";
            break;
          default:
            asset = "lib/images/cserv.png";
        }

        if (element["Service Type"] == service) {
          services.add(Marker(
              point: latlong.LatLng(double.parse(element[lattitude]),
                  double.parse(element[longitude])),
              child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.grey[950],
                          surfaceTintColor: Colors.transparent,
                          content: SizedBox(
                            height: MediaQuery.of(context).size.height / 2,
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  SimpleTextArea(
                                      content: element["Company Name"],
                                      title: "Name : "),
                                  SimpleTextArea(
                                      content: element["Experience"],
                                      title: "Experience : "),
                                  SimpleTextArea(
                                      content: element["Phone Number"],
                                      title: "Ph : "),
                                  SimpleTextArea(
                                      content: element["Service Type"],
                                      title: "Service Type : "),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  CustomButton(
                                    text: 'CONTINUE',
                                    onPressed: () {
                                      sentRequest(
                                          providerID: element["Email"],
                                          vehicleID: widget.vehicleID,
                                          userID: widget.userEmail);
                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ReqServicePage()));
                                    },
                                    buttonColor: AppColors.appPrimary,
                                    textColor: AppColors.appSecondary,
                                    suffixIcon: FontAwesomeIcons.arrowRight,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child:
                      Transform.scale(scale: 1.7, child: Image.asset(asset)))));
        }
      },
    );
  }

  void sentRequest(
      {required String providerID,
      required String vehicleID,
      required String userID}) async {
        setState(() {
          isLoading=true;
        });
    DateTime dateTime = DateTime.now();
   
    await FirebaseFirestore.instance.collection("SERVICE-REQUEST").add({
      "UserLocation-Lat": position!.latitude.toString(),
      "UserLocation-Long": position!.longitude.toString(),
      "UserID": userID,
      "VehicleID": vehicleID,
      "Service-Request-Type": service,
      "Requested-Time": dateTime,
      "Status": "Pending",
      "ProviderID": providerID
    });
    setState(() {
      isLoading=false;
    });
     
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("PROVIDERS").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          getServiceLocations(
              providerList: snapshot.data!.docs,
              lattitude: "location - lattitude",
              longitude: "location - longitude");
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 70,
              title: Row(
                children: [
                  const Icon(
                    Icons.verified_rounded,
                    color: AppColors.appTertiary,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Service Providers Nearby',
                    style: TextStyle(
                      fontFamily: GoogleFonts.ubuntu().fontFamily,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            body: isLoading
                ? const CircularProgressIndicator(
                    color: AppColors.appPrimary,
                  )
                : Center(
                    child: FlutterMap(
                        options: MapOptions(
                            minZoom: 5,
                            maxZoom: 24,
                            initialZoom: 18,
                            // initialCenter: latlong.LatLng(
                            //     8.774774774774775, 76.8818346748862)
                            initialCenter: latlong.LatLng(
                              position!.latitude,
                              position!.longitude,
                            )),
                        children: [
                          TileLayer(
                            // urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            // subdomains: ['a', 'b', 'c'],

                            urlTemplate: AppStrings.urlTemplate,
                            additionalOptions: {
                              'accessToken': AppStrings.accessToken,
                              'id': AppStrings.id
                            },
                          ),
                          MarkerLayer(markers: services)
                        ]),
                  ),
          );
        } else {
          return CircularProgressIndicator(
            color: AppColors.appPrimary,
          );
        }
      },
    );
  }
}
