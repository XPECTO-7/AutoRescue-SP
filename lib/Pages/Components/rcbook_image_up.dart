import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/Colors/appcolor.dart';

class RCImage extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final Function(File) onImageSelected;
  final String? rcImageURL;

  const RCImage({
    Key? key,
    required this.label,
    required this.controller,
    required this.onImageSelected,
    required this.rcImageURL,
  }) : super(key: key);

  @override
  State<RCImage> createState() => _RCImageState();
}

class _RCImageState extends State<RCImage> {
  XFile? pickedRCimage;

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        pickedRCimage = image;
      });
      widget.onImageSelected(File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: InkWell(
        onTap: pickImage,
        child: SizedBox(
          height: 60,
          width: 180,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: pickedRCimage == null && widget.rcImageURL == null
                      ? Text(
                          "Add Image",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.strait().fontFamily,
                          ),
                        )
                      : Text(
                          "Update Image",
                          style: TextStyle(
                            fontSize: 14,
                            color: widget.rcImageURL != null || pickedRCimage != null
                                ? AppColors.appTertiary
                                : Colors.white,
                            fontFamily: GoogleFonts.strait().fontFamily,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add_a_photo, color: Colors.white, size: 30),
                  onPressed: pickImage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
