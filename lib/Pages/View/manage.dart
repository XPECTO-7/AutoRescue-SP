import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:provider/Pages/Utils/custom_button.dart';
import 'package:provider/Pages/View/show_userdetails.dart';

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
              'Accepted Requests',
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
              final request = userRequest[index].data() as Map<String, dynamic>;
              DateTime requestedTime =
                  (request["Requested-Time"] as Timestamp).toDate();
              String formattedTime =
                  DateFormat('MMMM dd, yyyy hh:mm a').format(requestedTime);
              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                color: Colors.grey[900],
                child: ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(
                    request["UserID"].toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                  height: 2), // Adjust the height as needed
                              Text(
                                formattedTime,
                                style: TextStyle(
                                  color: AppColors.appPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: GoogleFonts.ubuntu().fontFamily,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          CustomButton(
                            h: 40,
                            text: 'Get Location',
                            textColor: Colors.white,
                            fsize: 16,
                            suffixIcon: FontAwesomeIcons.locationArrow,
                            buttonColor: Colors.blue.shade500,
                            onPressed: () {},
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          CustomButton(
                            h: 40,
                            text: 'User Details',
                            textColor: Colors.white,
                            fsize: 16,
                            suffixIcon: FontAwesomeIcons.squarePhone,
                            buttonColor: Colors.green.shade500,
                            onPressed: () {
                              String userId = request["UserID"].toString();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ShowUserDetailsPage(userId: userId),
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          CustomButton(
                            h: 40,
                            text: 'Vehicle Details',
                            textColor: Colors.black,
                            fsize: 16,
                            suffixIcon: FontAwesomeIcons.carBurst,
                            buttonColor: Colors.white,
                            onPressed: () {},
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          CustomButton(
                            h: 40,
                            text: 'Service Completed',
                            textColor: Colors.white,
                            fsize: 16,
                            suffixIcon: FontAwesomeIcons.listCheck,
                            buttonColor: Colors.redAccent,
                            onPressed: () {},
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
