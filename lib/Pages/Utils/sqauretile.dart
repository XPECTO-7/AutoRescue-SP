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
    child: SizedBox(
      height: 140, // Adjust the height according to your preference
      width: 105, // Adjust the width according to your preference
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.appTertiary),
          borderRadius: BorderRadius.circular(2),
          color: widget.isSelected ? Colors.black : Colors.grey[950],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              widget.imagePath,
              height: 70,
              width: 125,
            ),
            const SizedBox(height: 5),
            Text(
              widget.text,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.strait().fontFamily,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}