import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/Colors/appcolor.dart';

class Squaretile extends StatefulWidget {
  final String imagePath;
  final String text;
  final VoidCallback onTap;
  final bool isSelected;

  const Squaretile({
    Key? key,
    required this.imagePath,
    required this.text,
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);

  @override
  _SquaretileState createState() => _SquaretileState();
}

class _SquaretileState extends State<Squaretile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(4),
          color: widget.isSelected ? AppColors.appPrimary : AppColors.appTertiary,
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
