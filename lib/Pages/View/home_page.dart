// ignore_for_file: prefer_const_literals_to_create_immutables, use_build_context_synchronously, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/Authentication/Controller/main_page.dart';
import 'package:intl/intl.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:provider/Components/mybutton.dart';
import 'package:provider/Pages/View/add_service_page.dart';
import 'package:provider/Pages/View/notification_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? userDetails;
  String name = "";
  String currentDate = DateFormat.yMMMMd('en_US').format(DateTime.now());

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
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
        name = userDetails!["Fullname"];
      });
    });
    print("");
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return const MainPage();
      },
    ), (route) => false);
  }

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appPrimary,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.miscellaneous_services_sharp), label: 'Manage'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded), label: 'Account'),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: AppColors.appPrimary,
        selectedItemColor: AppColors.OxfordBlue, // Customize the selected item color
        unselectedItemColor: Colors.black, // Customize the unselected item color
      ),
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi  " + name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black),
                    ),
                    Text(
                      currentDate,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          color: Colors.black),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationPage()));
                      },
                      child: Icon(
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
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AddServicePage();
                }));
              },
              text: 'Add Service',
              color: Colors.black)
        ]),
      ),
    );
  }
}
