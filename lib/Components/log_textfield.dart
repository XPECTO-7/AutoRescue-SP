import 'package:flutter/material.dart';
import 'package:provider/Colors/appcolor.dart';

class LogTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final IconData iconData;

  const LogTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.appPrimary),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            fillColor: Colors.black,
            filled: true,
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.white,
            ),
            contentPadding:
                const EdgeInsets.only(left: 20, top: 20, bottom: 20),
            suffixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(end: 12.0),
              child: GestureDetector(
                child: Icon(iconData)),
            ),
          )),
    );
  }
}
