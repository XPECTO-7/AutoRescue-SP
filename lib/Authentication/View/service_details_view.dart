import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/Authentication/Controller/main_page.dart';
import 'package:provider/Authentication/View/Widgets/custom_slider.dart';
import 'package:provider/Authentication/View/Widgets/pick_location_pop_up.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:provider/Components/myalert_box.dart';
import 'package:provider/Components/mybutton.dart';

class ServiceDetailsView extends StatefulWidget {
  final String fullName, phoneNumber, adhaarImg, adhaarNum, email, password;

  const ServiceDetailsView(
      {Key? key,
      required this.fullName,
      required this.phoneNumber,
      required this.adhaarNum,
      required this.adhaarImg,
      required this.email,
      required this.password})
      : super(key: key);

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
  TextEditingController mecPriceController = TextEditingController();
  String imgUrl = "";
  String longitude = "";
  String lattitude = "";
  Position? position;
  final List<String> serviceTypes = [
    'Fuel Delivery Service',
    'Mechanical Service',
    'Emergency Towing Service',
    'EV Charging service',
  ];
  @override
  void initState() {
    // TODO: implement initState
    getCurrentLocation();
    super.initState();
  }

  void getCurrentLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  void validate() async {
    if (companyNameController.text.isNotEmpty &&
        expController.text.isNotEmpty &&
        lattitude != "" &&
        longitude != "" &&
        licenseController.text.isNotEmpty &&
        insuranceController.text.isNotEmpty) {
      signUp();
    } else {}
  }

  void addImageAndDetails() async {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirFolder = referenceRoot.child("Users");
    Reference referenceUser = referenceDirFolder.child(widget.email);
    Reference referenceImage = referenceUser.child(widget.adhaarNum);
    try {
      await referenceImage.putFile(File(widget.adhaarImg));
      imgUrl = await referenceImage.getDownloadURL();
    } catch (e) {
      print(e.toString());
    }
    if (imgUrl.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("USERS")
          .doc(widget.email)
          .set({
        'Fullname': widget.fullName,
        'Phone Number': widget.phoneNumber,
        'Email': widget.email,
        'Aadhar Photo': imgUrl,
        'Aadhar Number': widget.adhaarNum,
        'Company Name': companyNameController.text,
        'location - lattitude': lattitude,
        'location - longitude': longitude,
        'Experience': expController.text,
        'License No': licenseController.text,
        'Insurance No': insuranceController.text,
        'Service Type': serviceTypeController.text,
        'MecSerCharge': 'MecPriceController',
        'Approved': false
      });
    }
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return const MainPage();
      },
    ), (route) => false);
  }

  void signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: widget.email, password: widget.password);
      addImageAndDetails();
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) => MyAlertBox(
          message: e.code,
        ),
      );
    }
  }

  void pickLocation() async {
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
      body: SafeArea(
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
                          borderSide: BorderSide(color: AppColors.appPrimary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.appPrimary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    InkWell(
                      onTap: pickLocation,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.appPrimary),
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
                                    color: Colors.white, fontSize: 14),
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
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: const InputDecoration(
                        hintText: "Experience In Years",
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.appPrimary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.appPrimary),
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
                          borderSide: BorderSide(color: AppColors.appPrimary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.appPrimary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: insuranceController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.edit_document),
                        hintText: 'Insurance Number',
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.appPrimary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.appPrimary),
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
                          borderSide: BorderSide(color: AppColors.appPrimary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.appPrimary),
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
                    const Text('Service Charge Details :'),
                    CustomRangeSlider(serviceType: serviceTypeController.text, controller: mecPriceController, whichtype: "Mechanical Service"),
                    const SizedBox(
                      height: 40,
                    ),
                    MyButton(
                        onTap: validate,
                        text: 'Register',
                        textColor: Colors.black,
                        buttonColor: AppColors.appPrimary)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
