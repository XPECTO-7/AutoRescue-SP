import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/Authentication/View/forgot_password_page.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:provider/Components/log_pfield.dart';
import 'package:provider/Components/myalert_box.dart';
import 'package:provider/Components/mybutton.dart';
import 'package:provider/Components/log_textfield.dart';

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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      MyAlertBox(
        message: e.code,
      );
    }
     setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.appPrimary),
                ),
              )
            : SingleChildScrollView(
                child: SafeArea(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: SingleChildScrollView(
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
                                        text: 'User ',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontFamily:
                                              GoogleFonts.ubuntu().fontFamily,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
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
                            GestureDetector(
                              onTap: signIn,
                              child: MyButton(
                                buttonColor: Colors.black,
                                textColor: Colors.white,
                                text: 'Sign In',
                                onTap: () {
                                  if (emailController.text.isNotEmpty &&
                                      passwordController.text.isNotEmpty) {
                                    signIn();
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) => const MyAlertBox(
                                              message: 'Fill all the Fields',
                                            ));
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 60,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0, // No elevation
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.red,
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                                icon: const FaIcon(FontAwesomeIcons.google),
                                label: Text(
                                  'Sign Up with Google',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: GoogleFonts.ubuntu().fontFamily,
                                    fontSize: 18,
                                  ),
                                ),
                                onPressed: () {},
                              ),
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
                                    style: TextStyle(
                                        fontSize: 18,
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
              ));
  }
}
