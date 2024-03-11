import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:provider/Pages/Components/custom_button.dart';
import 'package:provider/Pages/Components/edit_vehicle.dart';
import 'package:provider/Pages/Components/vehicle_form_page.dart';
import 'package:provider/Pages/Utils/sqauretile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
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
    ManagePage(),
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
          TabItem(icon: Icons.settings_suggest_rounded, title: 'Service'),
          TabItem(icon: Icons.home_rounded, title: 'Home'),
          TabItem(icon: Icons.person, title: 'Account'),
        ],
        style: TabStyle.textIn,
        color: Colors.black54,
        activeColor: Colors.black,
        backgroundColor: Colors.white,
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
  late String selectedService;
   bool isTrue = false;
  @override
  void initState() {
    super.initState();
    selectedService = '';
    getAddedVehicles();
  }
 Future<void> getAddedVehicles() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  height: 600,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.0),
                    border: Border.all(color: AppColors.appTertiary),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Squaretile(
                            text: 'Tyre Works',
                            imagePath: 'lib/images/tyre.png',
                            isSelected: selectedService == 'Tyre Works',
                            onTap: () => updateSelectedService('Tyre Works'),
                          ),
                          const SizedBox(width: 7),
                          Squaretile(
                            text: 'Mechanical Works',
                            imagePath: 'lib/images/automotive.png',
                            isSelected: selectedService == 'Mechanical Works',
                            onTap: () =>
                                updateSelectedService('Mechanical Service'),
                          ),
                          const SizedBox(width: 7),
                          Squaretile(
                            text: 'EV Charging',
                            imagePath: 'lib/images/charging-station.png',
                            isSelected: selectedService == 'EV Charging',
                            onTap: () => updateSelectedService('EV Charging'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Squaretile(
                            text: 'Fuel Delivery',
                            imagePath: 'lib/images/fuel.png',
                            isSelected: selectedService == 'Fuel Delivery',
                            onTap: () => updateSelectedService('Fuel Delivery'),
                          ),
                          const SizedBox(width: 7),
                          Squaretile(
                            text: 'Towing',
                            imagePath: 'lib/images/tow-truck.png',
                            isSelected: selectedService == 'Towing',
                            onTap: () => updateSelectedService('Towing'),
                          ),
                          const SizedBox(width: 7),
                          Squaretile(
                            text: 'Key Lockout',
                            imagePath: 'lib/images/key.png',
                            isSelected: selectedService == 'Key Lockout',
                            onTap: () => updateSelectedService('Key Lockout'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (selectedService.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            'Selected Service: $selectedService',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        
                        GestureDetector(
                  onTap: () {
                    setState(() {
                      isTrue = !isTrue;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      padding: const EdgeInsets.only(left: 17),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.grey[700],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('SELECT VEHICLE',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontFamily: GoogleFonts.strait().fontFamily,
                                  fontWeight: FontWeight.bold)),
                          Transform.rotate(
                            angle: isTrue ? 3.14 : 0, // Rotate arrow
                            child: IconButton(
                              icon: const FaIcon(
                                  FontAwesomeIcons.squareArrowUpRight),
                              splashRadius: 1,
                              iconSize: 30,
                              onPressed: () {
                                setState(() {
                                  isTrue = !isTrue;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isTrue)
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, top: 10, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display added vehicles
                        // Display added vehicles
                        ...addedVehicles.map((vehicleDetails) {
                          return GestureDetector(
                            onTap: () {
                              // Navigate to the edit vehicle details page
                              // You can pass the vehicle details as arguments if needed
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditVehiclePage(
                                      vehicleDetails: vehicleDetails),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.grey[300],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.directions_car,
                                    color: AppColors.appSecondary,
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              vehicleDetails['manufacturer'],
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontFamily:
                                                      GoogleFonts.strait()
                                                          .fontFamily,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              vehicleDetails['vehicleName'],
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontFamily:
                                                      GoogleFonts.strait()
                                                          .fontFamily,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          vehicleDetails['registrationNumber'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: GoogleFonts.strait()
                                                  .fontFamily,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),

                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Navigate to the vehicle adding page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const VehicleFormPage(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.grey,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                          
                      const SizedBox(height: 20),
                      CustomButton(
                        text: 'REQUEST',
                        onPressed: () {
                          // Handle request button click
                        },
                        buttonColor: AppColors.appTertiary,
                        textColor: AppColors.appSecondary,
                      ),
                    ],
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
