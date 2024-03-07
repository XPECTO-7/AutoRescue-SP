import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:provider/Pages/View/account.dart';
import 'package:provider/Pages/View/manage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        height: 50,
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

  Future<void> _refreshData() async {
    // Fetch updated user data
    getUserData();
  }

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

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
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
                    width: 50,
                    height: 50,
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
                  crossAxisAlignment:
                      CrossAxisAlignment.center, 
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:1.0),
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          color: AppColors.appTertiary,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const FaIcon(FontAwesomeIcons.searchengin),
                              color: AppColors.appSecondary,
                              iconSize: 30,
                              onPressed: () {},
                            ),
                            const Text('Search',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: AppColors.appSecondary,
                                )),
                          ],
                        ),
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
