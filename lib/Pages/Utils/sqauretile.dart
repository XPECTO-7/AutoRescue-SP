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
        height: MediaQuery.of(context).size.height /
            6,
        width: MediaQuery.of(context).size.width /
            3.48,
        child: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.appTertiary),
            borderRadius: BorderRadius.circular(2),
            color: widget.isSelected ? AppColors.appPrimary : Colors.grey[950],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 70,
                width: 125,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(widget.imagePath),
                          fit: BoxFit.contain)),
                ),
              ),
              const SizedBox(height: 5),
              Center(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.strait().fontFamily,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign
                      .center, // Optional if you want to explicitly set text alignment
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
