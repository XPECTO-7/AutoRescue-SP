// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/Authentication/Controller/main_page.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:provider/Components/mybutton.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _aadharNumberController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _aadharNumberController = TextEditingController();
    getUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _aadharNumberController.dispose();
    super.dispose();
  }

  Future<void> getUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final userSnapshot = await FirebaseFirestore.instance
        .collection('PROVIDERS')
        .doc(currentUser.email)
        .get();
    if (userSnapshot.exists) {
      final userDetails = userSnapshot.data() as Map<String, dynamic>;
      setState(() {
        _nameController.text = userDetails['Fullname'];
        _emailController.text = userDetails['Email'];
        _phoneNumberController.text = userDetails['Phone Number'];
        _aadharNumberController.text = userDetails['Aadhar Number'];
      });
    }
  }

  void updateUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('PROVIDERS')
        .doc(currentUser.email)
        .update({
      'Fullname': _nameController.text,
      'Email': _emailController.text,
      'Phone Number': _phoneNumberController.text,
      'Aadhar Number': _aadharNumberController.text,
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Update Successful"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout Successfull"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _refresh() async {
    await getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'lib/images/user.png',
              height: 30,
              width: 30,
              alignment: Alignment.centerLeft,
              color: AppColors.appPrimary,
            ),
            const SizedBox(width: 10),
            Text(
              'My Profile',
              style: TextStyle(
                fontFamily: GoogleFonts.ubuntu().fontFamily,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: AppColors.appPrimary,
            ),
            onPressed: () => logout(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Center(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.person_pin_rounded,
                    size: 100,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  buildEditableField("Fullname", _nameController),
                  const SizedBox(
                    height: 17,
                  ),
                  buildEditableField("Email", _emailController),
                  const SizedBox(
                    height: 17,
                  ),
                  buildEditableField("Phone Number", _phoneNumberController),
                  const SizedBox(
                    height: 17,
                  ),
                  buildEditableField("Aadhar Number", _aadharNumberController),
                  const SizedBox(
                    height: 34,
                  ),
                  MyButton(
                    onTap: updateUserData,
                    text: 'Update Details',
                    textColor: Colors.black,
                    buttonColor: AppColors.appPrimary,
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEditableField(String label, TextEditingController controller) {
    return GestureDetector(
      onTap: () {
        // You can implement any editing mechanism here
        // For simplicity, we will just focus on the field when tapped
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            suffixIcon: controller.text.isEmpty
                ? const Icon(
                    Icons.error_outline_rounded,
                    color: Colors.red,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
