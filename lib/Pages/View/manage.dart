import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:provider/Pages/Utils/custom_button.dart';

class ManagePage extends StatefulWidget {
  const ManagePage({Key? key}) : super(key: key);

  @override
  State<ManagePage> createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  late User currentUser;

  late Stream<List<DocumentSnapshot>> serviceRequestStream =
      const Stream.empty();

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser!;
    _initServiceRequestStream();
  }

  void _initServiceRequestStream() {
    serviceRequestStream = FirebaseFirestore.instance
        .collection("SERVICE-REQUEST")
        .where("ProviderID", isEqualTo: currentUser.email)
        .where("Status", isEqualTo: "Accepted") // Filter only accepted requests
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  Future<void> _deleteRequest(String requestId) async {
    try {
      await FirebaseFirestore.instance
          .collection("SERVICE-REQUEST")
          .doc(requestId)
          .delete();
    } catch (e) {
      print("Error deleting request: $e");
      // Handle error as per your requirement
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Row(
          children: [
            const Icon(
              Icons.verified_rounded,
              color: AppColors.appTertiary,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Accepted Request Details',
              style: TextStyle(
                fontFamily: GoogleFonts.ubuntu().fontFamily,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: serviceRequestStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final userRequest = snapshot.data ?? [];
          if (userRequest.isEmpty) {
            return const Center(
              child: Text('No service requests found.'),
            );
          }

          return ListView.builder(
            itemCount: userRequest.length,
            itemBuilder: (context, index) {
              final request =
                  userRequest[index].data() as Map<String, dynamic>;
              DateTime requestedTime =
                  (request["Requested-Time"] as Timestamp).toDate();
              String formattedTime =
                  DateFormat('yyyy-MM-dd hh:mm').format(requestedTime);

              return Card(
                margin: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 16.0),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                color: Colors.grey[900],
                child: ExpansionTile(
                   initiallyExpanded: true,
                  title: Text(
                    request["Service-Request-Type"]
                        .toString()
                        .toUpperCase(), // Formatted time
                    style: TextStyle(
                      color: Colors.green, // Assuming all are accepted
                      fontSize: 20,
                      fontFamily: GoogleFonts.ubuntu().fontFamily,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status: ${request["Status"].toString()}',
                            style: TextStyle(color: Colors.green),
                          ),
                          Text(
                            'Service Requested Time: $formattedTime', // Formatted time
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          
                          CustomButton(
                            h: 40,
                            text: 'Cancel Request',
                            textColor: Colors.white,
                            fsize: 16,
                            suffixIcon: Icons.cancel_sharp,
                            buttonColor: Colors.red.shade500,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Confirm Cancellation"),
                                    content: const Text(
                                        "Are you sure you want to cancel this request?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("No"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await _deleteRequest(
                                              userRequest[index].id);
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Yes"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
