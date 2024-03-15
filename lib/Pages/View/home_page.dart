import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/Authentication/View/Widgets/pick_location_pop_up.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:provider/Pages/Components/custom_button.dart';
import 'package:provider/Pages/Components/label_textfield.dart';
import 'package:provider/Pages/Utils/sqauretile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/Pages/View/account.dart';
import 'package:provider/Pages/View/manage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  static const List<Widget> _widgetOptions = <Widget>[
    ManagePage(
      servicetype: "",
      vehicleID: "",
      userEmail: "",
    ),
    HomePageContent(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: ConvexAppBar(
        items: const [
          TabItem(icon: Icons.settings_suggest_rounded, title: 'SERVICE'),
          TabItem(icon: Icons.home_rounded, title: 'HOME'),
          TabItem(
            icon: Icons.person,
            title: 'ACCOUNT',
          ),
        ],
        style: TabStyle.reactCircle,
        color: Colors.black,
        activeColor: Colors.black,
        backgroundColor: AppColors.appTertiary,
        height: 60,
        initialActiveIndex: 1,
        elevation: 5,
        onTap: (int index) => setState(() {
          _selectedIndex = index;
        }),
      ),
    );
  }
}

class HomePageContent extends StatefulWidget {
  const HomePageContent({Key? key}) : super(key: key);

  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  bool isTrue = false;
  String selectedVehicleName = "", selectedService = "", lat = "", long = "";
  Position? position;
  String userEmail = "";
  String vehicleID = "";
  late TextEditingController expchController;
  late TextEditingController cuLockController;

  @override
  void initState() {
    super.initState();
    selectedService = '';
    getAddedVehicles();
    expchController = TextEditingController();
    cuLockController = TextEditingController();
  }

  void setLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    if (position != null) {
      setState(() {
        lat = position!.latitude.toString();
        long = position!.longitude.toString();
      });
    }
  }

  Future<void> getAddedVehicles() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    setState(() {
      userEmail = currentUser.email!;
    });
    final vehicleRef = FirebaseFirestore.instance
        .collection('USERS')
        .doc(currentUser.email)
        .collection('VEHICLES');

    final querySnapshot = await vehicleRef.get();

    final List<Map<String, dynamic>> vehicles = [];
    querySnapshot.docs.forEach((doc) {
      final data = doc.data();
      vehicles.add({
        'vehicleName': data['VehicleName'],
        'manufacturer': data['Manufacturer'],
        'registrationNumber': data['RegistrationNumber'],
        'year': data['Year'],
        'kilometers': data['Kilometers'],
        'fueltype': data['FuelType'],
        'vehicleImageURL': data['vehicleImageURL'],
      });
    });

    setState(() {
      addedVehicles = vehicles;
    });
  }

  void updateSelectedService(String service) {
    setState(() {
      if (selectedService == service) {
        // Deselect if the same service is clicked again
        selectedService = '';
      } else {
        // Select the clicked service
        selectedService = service;
      }
    });
  }

  List<Map<String, dynamic>> addedVehicles = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/images/cserv.png',
              color: AppColors.appPrimary,
              width: 60,
              height: 60,
            ),
            const SizedBox(width: 2),
            Text(
              'AutoRescue',
              style: TextStyle(
                fontFamily: GoogleFonts.ubuntu().fontFamily,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                    text: 'SELECT SERVICE',
                    fsize: 14,
                    iconsize: 24,
                    onPressed: () {},
                    buttonColor: Colors.yellow.shade900,
                    suffixIcon: FontAwesomeIcons.wrench,
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Squaretile(
                        text: 'TYRE WORKS',
                        imagePath: 'lib/images/tyre.png',
                        isSelected: selectedService == 'TYRE WORKS',
                        onTap: () => updateSelectedService('TYRE WORKS'),
                      ),
                      const SizedBox(width: 7),
                      Squaretile(
                        text: 'MECHANICAL WORKS',
                        imagePath: 'lib/images/automotive.png',
                        isSelected: selectedService == 'Mechanical Service',
                        onTap: () =>
                            updateSelectedService('Mechanical Service'),
                      ),
                      const SizedBox(width: 7),
                      Squaretile(
                        text: 'EV CHARGING',
                        imagePath: 'lib/images/charging-station.png',
                        isSelected: selectedService == 'EV Charging service',
                        onTap: () =>
                            updateSelectedService('EV Charging service'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Squaretile(
                        text: 'FUEL DELIVERY',
                        imagePath: 'lib/images/fuel.png',
                        isSelected: selectedService == 'Fuel Delivery Service',
                        onTap: () =>
                            updateSelectedService('Fuel Delivery Service'),
                      ),
                      const SizedBox(width: 7),
                      Squaretile(
                        text: 'TOWING',
                        imagePath: 'lib/images/tow-truck.png',
                        isSelected:
                            selectedService == 'Emergency Towing Service',
                        onTap: () =>
                            updateSelectedService('Emergency Towing Service'),
                      ),
                      const SizedBox(width: 7),
                      Squaretile(
                        text: 'KEY LOCKOUT',
                        imagePath: 'lib/images/key.png',
                        isSelected: selectedService == 'KEY LOCKOUT',
                        onTap: () => updateSelectedService('KEY LOCKOUT'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    text: 'SELECT VEHICLE',
                    fsize: 14,
                    iconsize: 24,
                    onPressed: () {},
                    buttonColor: Colors.yellow.shade800,
                    suffixIcon: FontAwesomeIcons.car,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, top: 10, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...addedVehicles.map((vehicleDetails) {
                          final isSelected = selectedVehicleName ==
                              '${vehicleDetails['manufacturer']} ${vehicleDetails['vehicleName']}';
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                vehicleID =
                                    vehicleDetails["registrationNumber"];
                                selectedVehicleName =
                                    '${vehicleDetails['manufacturer']} ${vehicleDetails['vehicleName']}';
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 7),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.appPrimary),
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.black26,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(FontAwesomeIcons.car,
                                      size: 20, color: Colors.white),
                                  const SizedBox(width: 17),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              vehicleDetails['manufacturer'] +
                                                  " " +
                                                  vehicleDetails['vehicleName'],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: GoogleFonts.strait()
                                                    .fontFamily,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              vehicleID,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: GoogleFonts.strait()
                                                    .fontFamily,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (isSelected)
                                          const Icon(
                                            Icons.check,
                                            color: AppColors.appPrimary,
                                          )
                                        // Placeholder for check icon
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  if (selectedService.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          children: [
                            if (selectedService.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 17.0),
                                child: Text(
                                  '$selectedService',
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                      fontFamily:
                                          GoogleFonts.strait().fontFamily,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  if (selectedVehicleName.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          children: [
                            if (selectedVehicleName != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 17.0),
                                child: Text(
                                  '$selectedVehicleName',
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                      fontFamily:
                                          GoogleFonts.strait().fontFamily,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  CustomButton(
                    text: 'CONTINUE',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManagePage(
                            servicetype: selectedService,
                            vehicleID: vehicleID,
                            userEmail: userEmail,
                          ),
                        ),
                      );
                    },
                    buttonColor: AppColors.appTertiary,
                    textColor: AppColors.appSecondary,
                    suffixIcon: FontAwesomeIcons.arrowRight,
                  ),
                  const SizedBox(
                    height: 25,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
