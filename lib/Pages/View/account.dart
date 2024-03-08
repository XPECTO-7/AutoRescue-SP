import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:provider/Authentication/Controller/main_page.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:provider/Components/mybutton.dart';
import 'package:provider/Pages/Components/license_image_up.dart';
import 'package:provider/Pages/Components/rcbook_image_up.dart';

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
  late TextEditingController rcImgController;
  File? pickedDLimage;
  File? pickedRCimage;
  String? dlImageURL;
  String? rcImageURL;
  bool isExpanded = false; // Track the visibility of the below row

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    drLicenseImgController = TextEditingController();
    rcImgController = TextEditingController();
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
        _nameController.text = userDetails['Fullname'] ?? '';
        _emailController.text = userDetails['Email'] ?? '';
        _phoneNumberController.text = userDetails['Phone Number'] ?? '';

        if (userDetails.containsKey('DL ImageURL')) {
          dlImageURL = userDetails['DL ImageURL'];
        }

        if (userDetails.containsKey('RC ImageURL')) {
          rcImageURL = userDetails['RC ImageURL'];
        }
      });
    }
  }

  Future<void> updateUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser!;

    String DLimageUrl = await uploadLicenseImage();
    String RCimageUrl = await uploadRCBookImage();

    await FirebaseFirestore.instance
        .collection('USERS')
        .doc(currentUser.email)
        .update({
      'Fullname': _nameController.text,
      'Phone Number': _phoneNumberController.text,
      'Email': _emailController.text,
      'DL ImageURL': DLimageUrl,
      'RC ImageURL': RCimageUrl,
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Updated Successfully",
            style: TextStyle(color: AppColors.appPrimary, fontSize: 14),
          ),
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
    final UploadTask uploadTask = storageReference.putFile(pickedDLimage!);

    await uploadTask.whenComplete(() {});
    return storageReference.getDownloadURL();
  }

  Future<String> uploadRCBookImage() async {
    final Reference storageReference =
        FirebaseStorage.instance.ref().child('user_RCimage');
    final UploadTask uploadTask = storageReference.putFile(pickedRCimage!);

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
          title: const Text(
            "Logout Successful",
            style: TextStyle(color: AppColors.appPrimary, fontSize: 14),
          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,
        title: Row(
          children: [
            const Icon(
              Icons.person_pin_rounded,
              size: 30,
              color: AppColors.appTertiary,
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
              color: AppColors.appTertiary,
            ),
            onPressed: () => logout(),
          ),
        ],
      ),
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.faceSmile),
                      iconSize: 20,
                      color: AppColors.appPrimary,
                      onPressed: () {},
                    ),
                    Text(
                      "Hello there!",
                      style: TextStyle(
                          color: AppColors.appTertiary,
                          fontFamily: GoogleFonts.ubuntu().fontFamily,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
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
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      padding: const EdgeInsets.only(left: 17),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.grey[700],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('UPLOAD FILES',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontFamily: GoogleFonts.strait().fontFamily,
                                  fontWeight: FontWeight.bold)),
                          Transform.rotate(
                            angle: isExpanded ? 3.14 : 0, // Rotate arrow
                            child: IconButton(
                              icon: const FaIcon(FontAwesomeIcons.squareArrowUpRight),
                              color: Colors.black,
                              iconSize: 30,
                              onPressed: () {},
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
                  
                Row(
                  children: [
                    Column(
                      children: [
                        LicenseImage(
                          controller: drLicenseImgController,
                          label: 'Driving License Image',
                          onImageSelected: (File image) {
                            setState(() {
                              pickedDLimage = image;
                            });
                          },
                          dlImageURL: '',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // Display the image preview below the ImageUploader field
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 5),
                          child: pickedDLimage != null
                              ? Container(
                                  height: 170,
                                  width: 170,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Image.file(
                                    pickedDLimage!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : dlImageURL != null
                                  ? Container(
                                      height: 170,
                                      width: 170,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Image.network(
                                        dlImageURL!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        RCImage(
                          controller: rcImgController,
                          label: 'RC Book Image',
                          onImageSelected: (File image) {
                            setState(() {
                              pickedRCimage = image;
                            });
                          },
                          rcImageURL: '',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // Display the image preview below the ImageUploader field
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 25),
                          child: pickedRCimage != null
                              ? Container(
                                  height: 170,
                                  width: 170,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Image.file(
                                    pickedRCimage!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : rcImageURL != null
                                  ? Container(
                                      height: 170,
                                      width: 170,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Image.network(
                                        rcImageURL!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],
                ),
                MyButton(
                  onTap: updateUserData,
                  text: 'Update Details',
                  textColor: Colors.black,
                  buttonColor: AppColors.appPrimary,
                ),
              ],
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
