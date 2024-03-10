import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:provider/Pages/Components/custom_button.dart';
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
  late Map<String, dynamic> userDetails;
  String currentDate = DateFormat.yMMMMd('en_US').format(DateTime.now());
  String currentTime = DateFormat.jms().format(DateTime.now());
  bool isFormVisible = false; // Track whether the form is visible or not

  void getUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final user = await FirebaseFirestore.instance
        .collection('USERS')
        .doc(currentUser.email)
        .get()
        .then((value) {
      setState(() {
        userDetails = value.data() as Map<String, dynamic>;
      });
    });
  }
  String selectedService = '';
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final _styleT = TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: GoogleFonts.ubuntu().fontFamily,
    );


    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('USERS')
          .doc(currentUser.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userDetails = snapshot.data!.data() as Map<String, dynamic>;

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
                  const SizedBox(
                    width: 2,
                  ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
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
                                      onTap: (text) {
                                        setState(() {
                                          selectedService = 'Tyre Works';
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 7),
                                    Squaretile(
                                      text: 'Mechanical Service',
                                      imagePath: 'lib/images/automotive.png',
                                      onTap: (text) {
                                        setState(() {
                                          selectedService = 'Mechanical Service';
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 7),
                                    Squaretile(
                                      text: 'EV Charging',
                                      imagePath:
                                          'lib/images/charging-station.png',
                                      onTap: (text) {
                                        setState(() {
                                          selectedService = 'EV Charging';
                                        });
                                      },
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
                                      onTap: (text) {
                                        setState(() {
                                          selectedService = 'Fuel';
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 7),
                                    Squaretile(
                                      text: 'Towing',
                                      imagePath: 'lib/images/tow-truck.png',
                                      onTap: (text) {
                                        setState(() {
                                          selectedService = 'Towing';
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 7),
                                    Squaretile(
                                      text: 'Key Lockout',
                                      imagePath: 'lib/images/key.png',
                                      onTap: (text) {
                                        setState(() {
                                          selectedService = 'Key LockOut';
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                 StreamBuilder<String>(
                                  stream: Stream.value(selectedService),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                        child: Text(
                                          'Service: $text',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  },
                                ),
                                const SizedBox(height: 10),
                                CustomButton(
                                  text: 'REQUEST',
                                  onPressed: () {},
                                  buttonColor: AppColors.appTertiary,
                                  textColor: AppColors.appSecondary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Scaffold();
        }
      },
    );
  }
}
