import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/Colors/appcolor.dart';
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
  bool profileCreation = true;

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
  // void check() {
  //   if (companyNameController.text.isNotEmpty &&
  //       expController.text.isNotEmpty &&
  //       locationController.text.isNotEmpty &&
  //       licenseController.text.isNotEmpty &&
  //       insuranceController.text.isNotEmpty &&
  //       serviceTypeController.text.isNotEmpty &&
  //       MecPriceController.text.isNotEmpty &&
  //       aadharNoController.text.isNotEmpty &&
  //       aadharImgController.text.isNotEmpty) {
  //     regCheck = true;
  //   } else {
  //     regCheck = false;
  //   }
  // }

  void validation() {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        fullNameController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty) {
      if (passwordController.text.length >= 8 &&
          numericRegex.hasMatch(passwordController.text)) {
        if (passwordController.text == confirmPasswordController.text) {
          if (regCheck == true) {
            signUp();
          } else {
            showDialog(
              context: context,
              builder: (context) => const MyAlertBox(
                message: "Complete Service Registration",
              ),
            );
          }
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
      // Fill all fields
      showDialog(
        context: context,
        builder: (context) => const MyAlertBox(
          message: "Fill all fields",
        ),
      );
    }
  }

  void signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      await FirebaseFirestore.instance
          .collection("USERS")
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
        'MecSerCharge': 'MecPriceController',
        'Approved': false
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
        title: Row(
          children: [
            const SizedBox(width: 15),
            const Icon(
              Icons.add,
              size: 25,
              color: Colors.white,
            ),
            const SizedBox(width: 15),
            Text(
              'Sign Up',
              style: TextStyle(
                fontFamily: GoogleFonts.ubuntu().fontFamily,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
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
                const SizedBox(height: 15),
                RegTextField(
                  controller: aadharNoController,
                  hintText: 'Aadhar Number',
                  obscureText: false,
                  iconData: Icons.numbers_rounded,
                ),
                const SizedBox(height: 15),
                RegTextField(
                  controller: aadharImgController,
                  hintText: 'Aadhar doc',
                  obscureText: false,
                  iconData: Icons.add_a_photo_rounded,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
