import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; // Import for Clipboard
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/Colors/appcolor.dart';

class ShowUserDetailsPage extends StatefulWidget {
  final String userId;

  const ShowUserDetailsPage({Key? key, required this.userId}) : super(key: key);

  @override
  _ShowUserDetailsPageState createState() => _ShowUserDetailsPageState();
}

class _ShowUserDetailsPageState extends State<ShowUserDetailsPage> {
  late String _name = '';
  late String _email = '';
  late String _phoneNumber = '';
  late String _dlImageURL = '';

  late Stream<DocumentSnapshot> userStream;

  @override
  void initState() {
    super.initState();
    // Initialize userStream in initState
    userStream = FirebaseFirestore.instance
        .collection("USERS")
        .doc(widget.userId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(
              Icons.person_pin_rounded,
              color: AppColors.appPrimary,
              size: 37,
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.appPrimary,
              ), // Loading indicator
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            _name = userData['Fullname'] ?? '';
            _email = userData['Email'] ?? '';
            _phoneNumber = userData['Phone Number'] ?? '';
            _dlImageURL = userData['DlImage'] ?? '';

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  userDetailsItem(Icons.person, 'Name: $_name'),
                  const SizedBox(height: 10),
                  userDetailsItem(Icons.email, 'Email: $_email'),
                  const SizedBox(height: 10),
                  userDetailsItem(Icons.phone, 'Phone Number: $_phoneNumber'),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[800], // Change to grey color
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Driving License ',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        // Show the driving license image if _dlImageURL is not empty
                        _dlImageURL.isNotEmpty
                            ? Image.network(
                                _dlImageURL,
                                height: 450, // Adjust height as needed
                                width: MediaQuery.of(context)
                                    .size
                                    .width, // Full width
                                fit: BoxFit.cover, // Adjust the image size
                              )
                            : Container(), // Show an empty container if _dlImageURL is empty
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget userDetailsItem(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey[800], // Change to grey color
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          if (icon ==
              Icons
                  .phone) // Only show the copy icon if the item is for phone number
            GestureDetector(
              onTap: () {
                Clipboard.setData(
                    ClipboardData(text: text)); // Copy text to clipboard
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Phone number copied to clipboard'),
                ));
              },
              child: const Icon(
                Icons.copy,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
