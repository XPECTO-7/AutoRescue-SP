import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class licenseImage extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final Function(File) onImageSelected;

  const licenseImage({
    Key? key,
    required this.label,
    required this.controller,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  State<licenseImage> createState() => _licenseImageState();
}

class _licenseImageState extends State<licenseImage> {
  XFile? pickedDLimage;

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        pickedDLimage = image;
      });
      widget.onImageSelected(File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
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
                  child: pickedDLimage == null
                      ?  Text(
                        "Add DL Image",
                          style: TextStyle(fontSize: 14, color: Colors.white,fontWeight: FontWeight.bold,fontFamily: GoogleFonts.strait().fontFamily),
                        )
                      :  Text(
                          "Update DL Image",
                          style: TextStyle(fontSize: 14, color: Colors.green,fontFamily: GoogleFonts.strait().fontFamily,fontWeight: FontWeight.bold),
                        ),
                ),
               
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add_a_photo, color: Colors.white,size: 30),
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
