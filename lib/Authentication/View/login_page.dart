import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/Authentication/View/forgot_password_page.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:provider/Components/log_pfield.dart';
import 'package:provider/Components/myalert_box.dart';
import 'package:provider/Components/mybutton.dart';
import 'package:provider/Components/log_textfield.dart';
import 'package:provider/Pages/View/bottom_nav.dart';
import 'package:provider/Pages/View/home_page_view.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({Key? key, required this.showRegisterPage}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  void signIn() async {
  setState(() {
    isLoading = true;
  });

  try {
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    // Navigate to homepage if sign-in is successful
    if (userCredential.user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavPage()), // Replace HomePage with your homepage widget
      );
    }
  } catch (e) {
    // If there's an error signing in
    showDialog(
      context: context,
      builder: (context) =>
          const MyAlertBox(message: 'User not registered or incorrect password.'),
    );
  }

 
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(    
      body: isLoading
        ? const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.appPrimary),
            ),
          )
        : SingleChildScrollView(
            child: SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/images/cserv.png',
                        color: Colors.white,
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'AutoRescue',
                            style: TextStyle(
                              fontSize: 30,
                              fontFamily: GoogleFonts.ubuntu().fontFamily,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(width: 4),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'SERVICE ',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: GoogleFonts.ubuntu().fontFamily,
                                    color: AppColors.appPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                WidgetSpan(
                                  child: Transform.translate(
                                    offset: const Offset(0, -8),
                                    child: const Text(
                                      '®', // Replace '®' with your company symbol
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      LogTextField(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                        iconData: Icons.mail,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      LogPField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: true,
                        iconData: Icons.remove_red_eye_rounded,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return const ForgotPasswordPage();
                                  }));
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      MyButton(
                        onTap: signIn,
                        buttonColor: Colors.black,
                        textColor: Colors.white,
                        text: 'Sign In',
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Not a member ?',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          GestureDetector(
                            onTap: widget.showRegisterPage,
                            child: const Text(
                              'Create an account!',
                              style:  TextStyle(
                                  fontSize: 17,
                                  color: AppColors.appPrimary,
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
