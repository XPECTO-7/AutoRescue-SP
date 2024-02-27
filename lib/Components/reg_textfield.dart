import 'package:flutter/material.dart';
import 'package:provider/Colors/appcolor.dart';

class RegTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final IconData iconData;
  
  const RegTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.iconData
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder:  OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedBorder:  OutlineInputBorder(
            borderSide: const BorderSide(color:AppColors.appPrimary),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          fillColor: Colors.black,
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.white),
            suffixIcon:  Icon(iconData),
        ),
      ),
    );
  }
}
