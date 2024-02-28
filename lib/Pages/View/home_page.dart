import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:provider/Components/mybutton.dart';
import 'package:provider/Pages/View/account.dart';
import 'package:provider/Pages/View/add_service_page.dart';
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
          TabItem(icon: Icons.verified_rounded, title: 'Services'),
          TabItem(icon: Icons.home_rounded, title: 'Home'),
          TabItem(icon: Icons.settings_suggest_rounded, title: 'Settings'),
        ],
        style: TabStyle.textIn,
        color: Colors.white,
        activeColor: Colors.white,
        backgroundColor: Colors.black87,
        height: 50,
        initialActiveIndex: 1,
        elevation: 5,
        onTap: (int index) => setState(() {
          _selectedIndex = index;
        }),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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

          return RefreshIndicator(
            onRefresh: _refreshData,
            child: Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hi  " + userDetails['Fullname'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              Text(
                                currentDate,
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AccountPage(),
                                    ),
                                  );
                                },
                                child: const Icon(
                                  Icons.notifications,
                                  color: AppColors.appPrimary,
                                  size: 40,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(
                              15), // Adjust the radius as needed
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              MyButton(
                                onTap: () {
                                  if (userDetails['Aadhar Photo'] != '' &&
                                      userDetails['Aadhar Number'] != '') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AddServicePage(),
                                      ),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                              'Complete Your Profile'),
                                          content: const Text(
                                              'Please complete your profile to Add Service.'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.pushNamed(
                                                    context, '/AccountPage');
                                              },
                                              child: const Text(
                                                  'Go to Profile Page'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                text: 'Add Service',
                                textColor: Colors.white,
                                buttonColor: Colors.black,
                              ),
                              Expanded(
                                child: Container(
                                   decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(
                              15), // Adjust the radius as needed
                        ),
                                ))
                            ],
                          ),
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
