import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  late String _rcImageURL = '';

  late Stream<DocumentSnapshot> userStream;

  @override
  void initState() {
    super.initState();
    // Initialize userStream in initState
    userStream = FirebaseFirestore.instance
        .collection("USERS")
        .doc(widget.userId)
        .snapshots();

    // Listen to changes in the stream
    userStream.listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        final userData = snapshot.data() as Map<String, dynamic>;
        setState(() {
          _name = userData['Fullname'] ?? '';
          _email = userData['Email'] ?? '';
          _phoneNumber = userData['Phone Number'] ?? '';
          _dlImageURL = userData['DL ImageURL'] ?? '';
          _rcImageURL = userData['RC ImageURL'] ?? '';
        });

        // Print the user data to the terminal
        print('User Data:');
        print('Name: $_name');
        print('Email: $_email');
        print('Phone Number: $_phoneNumber');
        print('DL ImageURL: $_dlImageURL');
        print('RC ImageURL: $_rcImageURL');
      }
    });
  }

  Future<String?> getImageURL(String imagePath) async {
    if (imagePath.isNotEmpty) {
      final ref = FirebaseStorage.instance.ref(imagePath);
      return await ref.getDownloadURL();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID: ${widget.userId}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Name: $_name',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: $_email',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Phone Number: $_phoneNumber',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'Driving License Image:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            FutureBuilder<String?>(
              future: getImageURL(_dlImageURL),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error loading image: ${snapshot.error}');
                }
                final imageUrl = snapshot.data;
                return imageUrl != null
                    ? Image.network(imageUrl)
                    : const Text('No image available');
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'RC Book Image:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            FutureBuilder<String?>(
              future: getImageURL(_rcImageURL),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error loading image: ${snapshot.error}');
                }
                final imageUrl = snapshot.data;
                return imageUrl != null
                    ? Image.network(imageUrl)
                    : const Text('No image available');
              },
            ),
          ],
        ),
      ),
    );
  }
}
