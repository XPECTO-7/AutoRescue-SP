import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
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

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final numberController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final numericRegex = RegExp(r'[0-9]');

  void validation() {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        fullNameController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty) {
      if (passwordController.text.length >= 8 &&
          numericRegex.hasMatch(passwordController.text)) {
        if (passwordController.text == confirmPasswordController.text) {
          signUp();
        } else {
          //pw didnt match
          showDialog(
            context: context,
            builder: (context) => const MyAlertBox(
              message: "Password didnt match",
            ),
          );
        }
      } else {
        //Display pw didnt meet requirements
        showDialog(
          context: context,
          builder: (context) => const MyAlertBox(
            message: " Password didnt meet requirements",
          ),
        );
      }
    } else {
      //Display fill all fields
      showDialog(
        context: context,
        builder: (context) => const MyAlertBox(
          message: " Fill all fields",
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
        'Aadhar Photo':'',
        'Aadhar Number':'',
        'Approved':false
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[950],
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_pin,
                  size: 50,),
                  Text(
                    'Create Your Account',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  //F U L L N A M E
                  RegTextField(
                    controller: fullNameController,
                    hintText: 'Full name',
                    obscureText: false,
                    iconData: Icons.person,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: IntlPhoneField(
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepOrange),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          fillColor: Colors.black,
                          filled: true,
                          hintStyle: TextStyle(color: Colors.white),
                          hintText: 'Phone Number',
                          suffixIcon: Icon(Icons.phone)),
                      initialCountryCode: 'IN',
                      controller: numberController,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  //E M A I L
                  RegTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                    iconData: Icons.mail,
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //P A S S W O R D
                  MyPWTField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),

                  //C O N F I R M P A S S W O R D
                  RegTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                    iconData: Icons.lock,
                  ),

                  const SizedBox(
                    height: 25,
                  ),
                  MyButton(
                    text: 'Sign Up',
                    onTap: validation,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already a member ?',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: widget.showLoginPage,
                        child: const Text(
                          ' Login',
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
