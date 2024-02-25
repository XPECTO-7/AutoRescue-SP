import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/Authentication/Controller/main_page.dart';
import 'package:provider/Pages/View/account.dart';
import 'package:provider/Pages/View/add_service_page.dart';
import 'package:provider/Pages/View/manage.dart';
import 'package:provider/Pages/View/notification_page.dart';
import 'package:provider/Components/mybutton.dart';
import 'package:provider/Colors/appcolor.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    late List<Widget> _children;
  late Widget _page;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _children = [
      ManagePage(),
      HomePage(),
      AccountPage(),
    ];
    _page = _children[_currentIndex];
  }

  late Map<String, dynamic> userDetails;
  String name = "";
  String currentDate = DateFormat.yMMMMd('en_US').format(DateTime.now());
  

  void getUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final user = await FirebaseFirestore.instance
        .collection('USERS')
        .doc(currentUser.email)
        .get()
        .then((value) {
      setState(() {
        userDetails = value.data() as Map<String, dynamic>;
        name = userDetails["Fullname"];
      });
    });
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const MainPage();
        },
      ),
      (route) => false,
    );
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
            backgroundColor: AppColors.appPrimary,
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.verified_rounded),
                  label: 'Manage',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_suggest_rounded),
                  label: 'Account',
                ),
              ],
              onTap: (index) {
                setState(() {
                  _page = _children[index];
                  _currentIndex = index;
                });
              },
              currentIndex: _currentIndex,
            ),
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
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              currentDate,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NotificationPage(),
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.notifications,
                                color: AppColors.whiteSmoke,
                                size: 40,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  MyButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return AccountPage();
                          },
                        ),
                      );
                    },
                    text: 'Complete Your Profile',
                    color: Colors.red,
                  ),
                  if (userDetails['Aadhar Photo'] == '')
                    const Text(
                      'Complete your profile to Add Service Details',
                      style: TextStyle(color: Colors.black),
                    ),
                  if (userDetails['Aadhar Photo'] != '') const SizedBox(height: 10),
                  MyButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return AddServicePage();
                          },
                        ),
                      );
                    },
                    text: 'Add Service',
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold();
        }
      },
    );
  }
}
