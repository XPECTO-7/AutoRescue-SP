import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/Authentication/View/service_details_view.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:provider/Components/aadhar_field.dart';
import 'package:provider/Components/myalert_box.dart';
import 'package:provider/Components/mybutton.dart';
import 'package:provider/Components/pwcontrol.dart';
import 'package:provider/Components/reg_textfield.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final numberController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final numericRegex = RegExp(r'[0-9]');
  String adharImage = "";
  XFile? pickedImage;
  TextEditingController aadharNoController = TextEditingController();
  TextEditingController aadharImgController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool regCheck = false;

void validation() {
  if (emailController.text.isNotEmpty &&
      passwordController.text.isNotEmpty &&
      fullNameController.text.isNotEmpty &&
      confirmPasswordController.text.isNotEmpty) {
    if (EmailValidator.validate(emailController.text)) {
      if (passwordController.text.length >= 8 &&
          numericRegex.hasMatch(passwordController.text)) {
        if (passwordController.text == confirmPasswordController.text) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ServiceDetailsView(
                  adhaarNum: aadharNoController.text,
                  email: emailController.text,
                  fullName: fullNameController.text,
                  password: confirmPasswordController.text,
                  phoneNumber: numberController.text,
                  adhaarImg: adharImage,
                );
              },
            ),
          );
        } else {
          // Passwords didn't match
          showDialog(
            context: context,
            builder: (context) => const MyAlertBox(
              message: "Passwords didn't match",
            ),
          );
        }
      } else {
        // Password didn't meet requirements
        showDialog(
          context: context,
          builder: (context) => const MyAlertBox(
            message: "Password didn't meet requirements",
          ),
        );
      }
    } else {
      // Invalid email format
      showDialog(
        context: context,
        builder: (context) => const MyAlertBox(
          message: "Enter valid Email address",
        ),
      );
    }
  } else {
    // Fill all fields
    showDialog(
      context: context,
      builder: (context) => const MyAlertBox(
        message: "Fill all fields",
      ),
    );
  }
}


void pickImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.camera);
  if (image != null) {
    // Get the path of the picked image
    String imagePath = image.path;
    
    // Compress the image
    Uint8List? compressedImage = await FlutterImageCompress.compressWithFile(
      imagePath,
      minWidth: 800,
      minHeight: 600,
      quality: 70,
    );

    if (compressedImage != null) {
      // Convert Uint8List to List<int>
      List<int> compressedImageData = compressedImage.toList();

      // Save the compressed image to a temporary file
      final File compressedFile = File(imagePath)..writeAsBytesSync(compressedImageData);

      setState(() {
        pickedImage = XFile(compressedFile.path);
        adharImage = compressedFile.path;
      });
    }
  }
}


  void signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      await FirebaseFirestore.instance
          .collection("PROVIDERS")
          .doc(emailController.text)
          .set({
        'Fullname': fullNameController.text.trim(),
        'Phone Number': numberController.text.trim(),
        'Email': emailController.text.trim(),
        'Aadhar Photo': 'aadharImgController',
        'Aadhar Number': 'aadharNoController',
        'Company Name': 'companyNameController',
        'Location': 'locationController',
        'Experience': 'expController',
        'License No': 'licenseController',
        'Insurance No': 'insuranceController',
        'Service Type': 'serviceTypeController',
        'Approved': 'Pending'
      });
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) => MyAlertBox(
          message: e.code,
        ),
      );
    }
  }

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[950],
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.showLoginPage,
        ),
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
              RegTextField(
                controller: fullNameController,
                hintText: 'Full name',
                obscureText: false,
                iconData: Icons.person,
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: IntlPhoneField(
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.appPrimary),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    fillColor: Colors.black,
                    filled: true,
                    hintStyle: TextStyle(color: Colors.white),
                    hintText: 'Phone Number',
                    suffixIcon: Icon(Icons.phone),
                  ),
                  initialCountryCode: 'IN',
                  controller: numberController,
                ),
              ),
              AadharTextField(
                controller: aadharNoController,
                hintText: 'Aadhar Number',
                obscureText: false,
                iconData: Icons.numbers_rounded,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: InkWell(
                  onTap: pickImage,
                  child: SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black,
                        border: Border.all(color: Colors.white),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: pickedImage == null
                                ? const Text(
                                    "Add Aadhar Image",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  )
                                : const Text(
                                    "Update Image",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                          ),
                         
                          const Spacer(), // Add Spacer to push suffix icon to the right
                          IconButton(
                            icon: const Icon(Icons.add_a_photo,
                                color: Colors
                                    .white), // Change the icon as per your requirement
                            onPressed: pickImage,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              if (pickedImage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    height: 100,
                    width:  MediaQuery.of(context).size.width,
                    color: Colors.grey[950],
                    child: Center(
                      child: Image.file(
                        File(pickedImage!.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 15),
              RegTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
                iconData: Icons.mail,
              ),
              const SizedBox(height: 15),
              MyPWTField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              RegTextField(
                controller: confirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
                iconData: Icons.lock,
              ),
              const SizedBox(
                height: 20,
              ),
              MyButton(
                onTap: validation,
                text: "Next",
                buttonColor: AppColors.appPrimary,
                textColor: Colors.black,
              )
            ],
          ),
        ),
      ),
    );
  }
}
