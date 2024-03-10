import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/Colors/appcolor.dart';

class Squaretile extends StatefulWidget {
  final String imagePath;
  final String text;
  final Function(String) onTap;

  const Squaretile({
    Key? key,
    required this.imagePath,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  _SquaretileState createState() => _SquaretileState();
}

class _SquaretileState extends State<Squaretile> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
       
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(4),
          color: isSelected ? AppColors.appPrimary : AppColors.appTertiary,
        ),
        child: Column(
          children: [
            Image.asset(
              widget.imagePath,
              height: 77,
            ),
            const SizedBox(height: 5),
            Text(
              widget.text,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.strait().fontFamily,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}