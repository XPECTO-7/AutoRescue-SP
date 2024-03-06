import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploader extends StatefulWidget {
  final String label;
  final String updateText;
  final TextEditingController controller;
  final Function(File) onImageSelected;

  const ImageUploader({
    Key? key,
    required this.label,
    this.updateText = 'Update Image',
    required this.controller,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  State<ImageUploader> createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      widget.onImageSelected(File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: InkWell(
        onTap: pickImage,
        child: SizedBox(
          height: 60,
          width: MediaQuery.of(context).size.width,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.black,
              border: Border.all(color: Colors.white),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.controller.text.isEmpty
                      ? const Text(
                          "Add Image",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )
                      : const Text(
                          "Update Image",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
                if (widget.controller.text.isNotEmpty)
                  Container(
                    child: Image.file(
                      widget.controller.text.isNotEmpty
                          ? File(widget.controller.text)
                          : File(""),
                    ),
                  ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add_a_photo, color: Colors.white),
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