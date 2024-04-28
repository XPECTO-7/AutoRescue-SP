import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/Authentication/View/Widgets/pick_location_pop_up.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:provider/Components/myalert_box.dart';
import 'package:provider/Components/mybutton.dart';
import 'package:provider/Pages/View/bottom_nav.dart';

class ServiceDetailsView extends StatefulWidget {
  final String fullName, phoneNumber, adhaarImg, adhaarNum, email, password;

  const ServiceDetailsView({
    Key? key,
    required this.fullName,
    required this.phoneNumber,
    required this.adhaarNum,
    required this.adhaarImg,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  State<ServiceDetailsView> createState() => _ServiceDetailsViewState();
}

class _ServiceDetailsViewState extends State<ServiceDetailsView> {
  TextEditingController serviceTypeController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController expController = TextEditingController();
  TextEditingController licenseController = TextEditingController();
  TextEditingController insuranceController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController priceChargeController =
      TextEditingController(text: '100');

  String imgUrl = "";
  String longitude = "";
  String lattitude = "";
  Position? position;
  final List<String> serviceTypes = [
    'Fuel Delivery Service',
    'Mechanical Service',
    'Emergency Towing Service',
    'EV Charging service',
    'TYRE WORKS'
  ];

  bool isSigningUp = false;

 
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

 

  void getCurrentLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  void validate() async {
  

    if (companyNameController.text.isEmpty) {
      showAlertDialog("Company Name cannot be empty");
    } else if (expController.text.isEmpty) {
      showAlertDialog("Experience cannot be empty");
    } else if (lattitude.isEmpty || longitude.isEmpty) {
      showAlertDialog("Location cannot be empty");
    } else if (licenseController.text.isEmpty) {
      showAlertDialog("License Number cannot be empty");
    } else if (insuranceController.text.isEmpty) {
      showAlertDialog("Insurance Number cannot be empty");
    } else {
      // Check if at least one of the price controllers has a non-empty value
      if (priceChargeController.text.isEmpty) {
        showAlertDialog("Price charge is required");
      } else {
        signUp();
      }
    }
  }

  void showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Validation Error"),
          content: Text(message),
          actions: [
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

 void signUp() async {
  setState(() {
    isSigningUp = true;
  });
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.email, password: widget.password);

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirFolder = referenceRoot.child("Users");
    Reference referenceUser = referenceDirFolder.child(widget.email);
    Reference referenceImage = referenceUser.child(widget.adhaarNum);
    try {
      await referenceImage.putFile(File(widget.adhaarImg));
      String imgUrl = await referenceImage.getDownloadURL();

      if (imgUrl.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection("PROVIDERS")
            .doc(widget.email)
            .set({
          'Fullname': widget.fullName,
          'Phone Number': widget.phoneNumber,
          'Email': widget.email,
          'Aadhar Photo': imgUrl,
          'Profile Photo': '',
          'Aadhar Number': widget.adhaarNum,
          'Company Name': companyNameController.text,
          'location - lattitude': lattitude,
          'location - longitude': longitude,
          'Experience': expController.text,
          'License No': licenseController.text,
          'Insurance No': insuranceController.text,
          'Service Type': serviceTypeController.text,
          'Min Price': priceChargeController.text,
          'Approved': 'Pending'
        });

        // Navigation to homepage upon successful signup
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavPage()), // Replace HomePage with your actual homepage widget
        );
      }
    } catch (e) {
      print(e.toString()); // Handle error here if necessary
    }
  } on FirebaseAuthException catch (e) {
    showDialog(
      context: context,
      builder: (context) => MyAlertBox(
        message: e.code,
      ),
    ).then((_) {
      setState(() {
        isSigningUp = false;
      });
    });
  }
}


  void pickLocation() async {
    if (position != null) {
      showDialog(
        context: context,
        builder: (context) {
          return PinLocationMap(
            currentLocationX: position!.latitude,
            currentLocationY: position!.longitude,
            onTap: (p0, p1) {
              setState(() {
                longitude = p1.longitude.toString();
                lattitude = p1.latitude.toString();
              });
              Navigator.pop(context);
            },
          );
        },
      );
    } else {
      print('Current position is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[950],
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,
        title: Text(
          'Sign Up',
          style: TextStyle(
            fontFamily: GoogleFonts.ubuntu().fontFamily,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: companyNameController,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.business),
                            hintText: "Company / Workshop Name",
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.appPrimary),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.appPrimary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        InkWell(
                          onTap: pickLocation,
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                const Icon(Icons.map),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    longitude.isEmpty
                                        ? "Set Company / Workshop Location"
                                        : "Location set",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ),
                                if (longitude.isNotEmpty)
                                  const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: expController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          maxLength: 2, // Maximum length of 3 digits
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          decoration: const InputDecoration(
                            hintText: "Experience In Years",
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.appPrimary),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.appPrimary),
                            ),
                            suffixIcon: Icon(Icons.handyman_sharp),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: licenseController,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.edit_document),
                            hintText: 'License Number',
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.appPrimary),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.appPrimary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: insuranceController,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.verified),
                            hintText: 'Insurance Number',
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.appPrimary),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.appPrimary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: const InputDecoration(
                            hintText: "Select Service",
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.appPrimary),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.appPrimary),
                            ),
                          ),
                          items: serviceTypes
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'Please Select Service Type.';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              serviceTypeController.text = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        const Text('Minimum Charge'),
                        const SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: priceChargeController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}'),
                            ),
                          ],
                          decoration: const InputDecoration(
                            hintText: "Minimum Service Charge",
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.appPrimary),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.appPrimary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        MyButton(
                          onTap: isSigningUp ? null : validate,
                          text: 'Register',
                          textColor: Colors.black,
                          buttonColor: AppColors.appPrimary,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isSigningUp)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Center(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: const CircularProgressIndicator(
                color: AppColors.appPrimary,
              ),
            ),
                        ),
              ],
            )
        ],
      ),
    );
  }
}
