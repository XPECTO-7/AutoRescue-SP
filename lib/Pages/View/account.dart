// Import necessary packages and libraries

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/Authentication/Controller/main_page.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:provider/Components/mybutton.dart';
import 'package:provider/Pages/Components/imageupload.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController drLicenseImgController;
  File? pickedImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    drLicenseImgController = TextEditingController();
    getUserData();
  }

  Future<void> getUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final userSnapshot = await FirebaseFirestore.instance
        .collection('USERS')
        .doc(currentUser.email)
        .get();
    if (userSnapshot.exists) {
      final userDetails = userSnapshot.data() as Map<String, dynamic>;
      setState(() {
        _nameController.text = userDetails['Fullname'];
        _emailController.text = userDetails['Email'];
        _phoneNumberController.text = userDetails['Phone Number'];
      });
    }
  }

  Future<void> updateUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser!;

    String imageUrl = await uploadLicenseImage();

    await FirebaseFirestore.instance
        .collection('USERS')
        .doc(currentUser.email)
        .update({
      'Fullname': _nameController.text,
      'Phone Number': _phoneNumberController.text,
      'Chasis Number': drLicenseImgController.text,
      'ImageURL': imageUrl,
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

  Future<String> uploadLicenseImage() async {
    final Reference storageReference =
        FirebaseStorage.instance.ref().child('user_LicenseImage');
    final UploadTask uploadTask = storageReference.putFile(pickedImage!);

    await uploadTask.whenComplete(() {});
    return storageReference.getDownloadURL();
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
          title: const Text("Account Logged Out"),
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
                  ImageUploader(
                      controller: drLicenseImgController,
                      label: 'Driving License Image',
                      onImageSelected: (File image) {
                        setState(() {
                          pickedImage = image;
                        });
                      }),
               
                  // Display the image preview below the ImageUploader field
                  pickedImage != null
                      ? Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black,
                            border: Border.all(),
                          ),
                          child: Image.file(pickedImage!, fit: BoxFit.cover),
                        )
                      : Container(), // Show an empty container if no image is picked
                  const SizedBox(
                    height: 10,
                  ),
                  MyButton(
                    onTap: updateUserData,
                    text: 'Update Details',
                    textColor: Colors.black,
                    buttonColor: AppColors.appPrimary,
                  ),
                  const SizedBox(
                    height: 20,
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

