import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/Components/mybutton.dart'; // Import the image_picker package

class UploadDocPage extends StatefulWidget {
  const UploadDocPage({Key? key}) : super(key: key);

  @override
  _UploadDocPageState createState() => _UploadDocPageState();
}

class _UploadDocPageState extends State<UploadDocPage> {
  File? dlImage;
  File? rcImage;
  String? dlUrl, rcUrl;
  Future<void> pickDLImage() async {
    final picker = ImagePicker();
    final pickedImageFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImageFile != null) {
      setState(() {
        dlImage = File(pickedImageFile.path);
      });
    }
  }

  Future<void> pickRCImage() async {
    final picker = ImagePicker();
    final pickedImageFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImageFile != null) {
      setState(() {
        rcImage = File(pickedImageFile.path);
      });
    }
  }

  void uploadImages() async {
    final Reference storageReference =
        FirebaseStorage.instance.ref().child('Users');
        final Reference userReferenc=storageReference.child(FirebaseAuth.instance.currentUser!.email.toString());
    final Reference userReference = userReferenc.child("Vehicle_Details");
    // final Reference rcReference = userReference.child("Rc_Image");
    final Reference dlReference = userReference.child("Dl_Image");
    try {
      // await rcReference.putFile(rcImage!);
      await dlReference.putFile(dlImage!);
    //  rcUrl =await rcReference.getDownloadURL();
     dlUrl = await dlReference.getDownloadURL();
    } catch (e) {
      print(e.toString());
    }
    if (dlUrl != "" ) {
      await FirebaseFirestore.instance
          .collection("USERS")
          .doc(FirebaseAuth.instance.currentUser!.email.toString())
          .update({ "DlImage": dlUrl});
          Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Files'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Driving License Image Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: InkWell(
                onTap: pickDLImage,
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
                          child: dlImage == null
                              ? const Text(
                                  "Add Driving License Image",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                )
                              : const Text(
                                  "Update Driving License Image",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.add_a_photo,
                              color: Colors.white),
                          onPressed: pickDLImage,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (dlImage != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[950],
                  child: Center(
                    child: Image.file(
                      dlImage!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            const SizedBox(
              height: 50,
            ),
            // RC Book Image Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: InkWell(
                onTap: pickRCImage,
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
                          child: rcImage == null
                              ? const Text(
                                  "Add RC Book Image",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                )
                              : const Text(
                                  "Update RC Book Image",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.add_a_photo,
                              color: Colors.white),
                          onPressed: pickRCImage,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (rcImage != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[950],
                  child: Center(
                    child: Image.file(
                      rcImage!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            MyButton(
                onTap: uploadImages,
                text: "Upload",
                textColor: Colors.black,
                buttonColor: Colors.blue)
          ],
        ),
      ),
    );
  }
}
