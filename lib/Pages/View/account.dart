import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/Authentication/Controller/main_page.dart';
import 'package:provider/Pages/Utils/cont.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late Map<String, dynamic> userDetails;
  String name = "";

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

  bool hasImage = true;

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
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 150,
                  ),
                  const Icon(
                    Icons.person_pin_rounded,
                    size: 100,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MyContainer(text: userDetails['Fullname']),
                  const SizedBox(
                    height: 17,
                  ),
                  MyContainer(text: userDetails['Email']),
                  const SizedBox(
                    height: 17,
                  ),
                  MyContainer(text: userDetails['Phone Number']),
                  const SizedBox(
                    height: 17,
                  ),
                  MyContainer(text: userDetails['Aadhar Number']),
                  const SizedBox(
                    height: 100,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 80.0),
                    child: Divider(
                      thickness: 0.2,
                      color: Colors.white70,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.circle_sharp,
                        size: 3,
                      ),
                      const SizedBox(
                        width: 17,
                      ),
                      GestureDetector(
                        onTap: logout,
                        child: Text(
                          'Logout',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: GoogleFonts.dmSans().fontFamily),
                        ),
                      ),
                      const SizedBox(
                        width: 17,
                      ),
                      const Icon(
                        Icons.circle_sharp,
                        size: 3,
                      ),
                    ],
                  )
                ],
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
