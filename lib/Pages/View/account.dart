import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/Authentication/Controller/main_page.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:provider/Components/mybutton.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  File? _imageFile;
  final picker = ImagePicker();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _aadharNumberController;
  late TextEditingController comNameController;
  late TextEditingController licenseController;
  late TextEditingController insuranceController;
  late TextEditingController serTypeController;
  late TextEditingController expController;
  late TextEditingController minChargeController;
  bool isLoading = false;
  bool isExpanded = false;
  String _profilePhotoURL = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _aadharNumberController = TextEditingController();
    comNameController = TextEditingController();
    licenseController = TextEditingController();
    insuranceController = TextEditingController();
    serTypeController = TextEditingController();
    expController = TextEditingController();
    minChargeController = TextEditingController();
    getUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _aadharNumberController.dispose();
    comNameController.dispose();
    licenseController.dispose();
    insuranceController.dispose();
    serTypeController.dispose();
    expController.dispose();
    super.dispose();
  }

  Future<void> getUserData() async {
    setState(() {
      isLoading = true;
    });
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
        comNameController.text = userDetails['Company Name'];
        licenseController.text = userDetails['License No'];
        insuranceController.text = userDetails['Insurance No'];
        serTypeController.text = userDetails['Service Type'];
        expController.text = userDetails['Experience'];
        minChargeController.text = userDetails['Min Price'];

        // Check if Profile Photo URL exists
        if (userDetails['Profile Photo'] != null) {
          _profilePhotoURL = userDetails['Profile Photo'] as String;
        } else {
          // Optionally, you can set a default URL or leave it as null
          _profilePhotoURL = userDetails['Profile Photo'] as String? ?? '';
        }
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void updateUserData() async {
    // Upload profile photo if it exists
    await _uploadImage();

    final currentUser = FirebaseAuth.instance.currentUser!;
    final userUpdateData = {
      'Fullname': _nameController.text,
      'Email': _emailController.text,
      'Phone Number': _phoneNumberController.text,
      'Aadhar Number': _aadharNumberController.text,
      'Company Name': comNameController.text,
      'License No': licenseController.text,
      'Insurance No': insuranceController.text,
      'Service Type': serTypeController.text,
      'Experience': expController.text,
    };

    // Add profile photo URL to user data if available
    if (_imageFile != null) {
      final fileName = Path.basename(_imageFile!.path);
      final destination = 'profile_photos/$fileName';
      final downloadURL =
          await FirebaseStorage.instance.ref(destination).getDownloadURL();
      userUpdateData['Profile Photo'] = downloadURL;
    }

    // Update user data in Firestore
    await FirebaseFirestore.instance
        .collection('PROVIDERS')
        .doc(currentUser.email)
        .update(userUpdateData);

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
          title: const Text("Logout Successful"),
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
    final Size screenSize = MediaQuery.of(context).size;

    return SizedBox(
      width: screenSize.width,
      child: Scaffold(
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
              const Text(
                'My Profile',
                style: TextStyle(
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
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.appPrimary),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _pickImage();
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: (_imageFile != null ||
                                            _profilePhotoURL != '')
                                        ? (_imageFile != null
                                            ? DecorationImage(
                                                image: FileImage(_imageFile!),
                                                fit: BoxFit.cover,
                                              )
                                            : DecorationImage(
                                                image: NetworkImage(
                                                    _profilePhotoURL),
                                                fit: BoxFit.cover,
                                              ))
                                        : null,
                                  ),
                                  child: (_imageFile == null &&
                                          _profilePhotoURL == '')
                                      ? const Icon(
                                          Icons.account_circle,
                                          size: 120,
                                          color: Colors.white, // Icon color
                                        )
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(7),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      size: 17,
                                      color: AppColors.appPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 17,
                          ),
                          buildEditableField("Fullname", _nameController),
                          const SizedBox(
                            height: 17,
                          ),
                          buildEditableField("Email", _emailController),
                          const SizedBox(
                            height: 17,
                          ),
                          buildEditableField(
                              "Phone Number", _phoneNumberController),
                          const SizedBox(
                            height: 17,
                          ),
                          buildEditableField(
                              "Aadhar Number", _aadharNumberController),
                          const SizedBox(
                            height: 17,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Container(
                                padding: const EdgeInsets.only(left: 17),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.grey[700],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'COMPANY / WORKSHOP DETAILS',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontFamily:
                                              GoogleFonts.strait().fontFamily,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Transform.rotate(
                                      angle:
                                          isExpanded ? 3.14 : 0, // Rotate arrow
                                      child: IconButton(
                                        icon: const FaIcon(FontAwesomeIcons
                                            .squareArrowUpRight),
                                        splashRadius: 1,
                                        iconSize: 30,
                                        onPressed: () {
                                          setState(() {
                                            isExpanded = !isExpanded;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 17,
                          ),
                          if (isExpanded) // Show this row if isExpanded is true
                            Column(
                              children: [
                                buildEditableField(
                                    "Company Name", comNameController),
                                const SizedBox(
                                  height: 17,
                                ),
                                buildEditableField(
                                    "License Number", licenseController),
                                const SizedBox(
                                  height: 17,
                                ),
                                buildEditableField(
                                    "Insurance Number", insuranceController),
                                const SizedBox(
                                  height: 17,
                                ),
                                buildEditableField("Experience", expController),
                                const SizedBox(
                                  height: 17,
                                ),
                                buildEditableField(
                                    "Minimum Charge", minChargeController),
                                const SizedBox(
                                  height: 17,
                                ),
                              ],
                            ),
                          MyButton(
                            onTap: updateUserData,
                            text: 'Update Details',
                            textColor: Colors.black,
                            buttonColor: AppColors.appPrimary,
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
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

  Future<void> _pickImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        _uploadImage();
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    final currentUser = FirebaseAuth.instance.currentUser!;
    final fileName = Path.basename(_imageFile!.path);
    final destination = 'profile_photos/$fileName';

    try {
      await FirebaseStorage.instance.ref(destination).putFile(_imageFile!);

      final downloadURL =
          await FirebaseStorage.instance.ref(destination).getDownloadURL();

      await FirebaseFirestore.instance
          .collection('PROVIDERS')
          .doc(currentUser.email)
          .update({'Profile Photo': downloadURL});
    } catch (e) {
      print('Failed to upload image: $e');
    }
  }
}
