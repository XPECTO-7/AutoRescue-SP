import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final color;

  const MyButton({super.key, required this.onTap, required this.text,required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style:  TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.ubuntu().fontFamily,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
