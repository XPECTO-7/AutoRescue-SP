import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
            backgroundColor: Colors.black,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 150,
                  ),
                  Container(
        height: 100.0,
        width: 100.0,
        color: Colors.grey,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: hasImage
              ? Image.network(
                  'https://cdn.pixabay.com/photo/2017/07/18/23/23/user-2517433_640.png',
                  fit: BoxFit.contain,
                )
              : Center(
                  child: Text('no data'),
                ),
        ),
      ),
      SizedBox(height: 30,),
                  MyContainer(text: userDetails['Fullname']),
                  SizedBox(height: 17,),
                  MyContainer(text: userDetails['Email']),
                  SizedBox(height: 17,),
                  MyContainer(text: userDetails['Phone Number']),
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
