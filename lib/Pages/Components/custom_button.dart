import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color buttonColor;
  final Color hoverColor;
  final Color textColor;
  final double borderRadius;
  final double h;
  final double w;
  final IconData? suffixIcon; // New parameter for suffix icon

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.buttonColor = Colors.blue,
    this.hoverColor = Colors.grey,
    this.textColor = Colors.white,
    this.borderRadius = 4.0,
    this.h = 50,
    this.w = double.infinity,
    this.suffixIcon, // Initialize suffix icon
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isHovered = false;

  @override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: MouseRegion(
      onEnter: (event) => setState(() => _isHovered = true),
      onExit: (event) => setState(() => _isHovered = false),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isHovered ? widget.hoverColor : widget.buttonColor,
          foregroundColor: widget.textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          minimumSize: Size(widget.w, widget.h),
        ),
        child: Row( // Wrap text and suffix icon in a Row
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.text,
              style: const TextStyle(
                fontSize: 19,
                fontFamily: 'Strait',
                fontWeight: FontWeight.bold,
              ),
            ),
            if (widget.suffixIcon != null) // Show suffix icon if provided
              SizedBox(
                width: 24, // Set width to provide space between text and suffix icon
                child: Icon(widget.suffixIcon, size: 24),
              ),
          ],
        ),
      ),
    ),
  );
}
}