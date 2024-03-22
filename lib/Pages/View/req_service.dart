import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:provider/Components/mybutton.dart';
import 'package:provider/Pages/Components/custom_button.dart';
import 'package:provider/Pages/View/req_servicedetail.dart';

class ReqServicePage extends StatefulWidget {
  const ReqServicePage({Key? key}) : super(key: key);

  @override
  State<ReqServicePage> createState() => _ReqServicePageState();
}

class _ReqServicePageState extends State<ReqServicePage> {
  late User currentUser;

  late Stream<List<DocumentSnapshot>> serviceRequestStream = Stream.empty();

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser!;
    _initServiceRequestStream();
  }

  void _initServiceRequestStream() {
    serviceRequestStream = FirebaseFirestore.instance
        .collection("SERVICE-REQUEST")
        .where("UserID", isEqualTo: currentUser.email)
        .snapshots()
        .map((snapshot) => snapshot.docs);
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
              'Requested Services',
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
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final userRequest = snapshot.data ?? [];
          if (userRequest.isEmpty) {
            return Center(
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
                  DateFormat('yyyy-MM-dd HH:mm').format(requestedTime);

              // Change text color based on status
              Color statusColor = Colors.white; // Default color

             

              if (request["Status"] == "Pending") {
                statusColor =
                    Colors.yellow; // Change to yellow if status is pending
              
              } else if (request["Status"] == "Accepted") {
                statusColor =
                    Colors.green; // Change to green if status is accepted
              } else if (request["Status"] == "Declined") {
                statusColor = Colors.red; // Change to red if status is declined
              } else {
                print('Unknown status: ${request["Status"]}');
              }

              return ExpansionTile(
                title: Text(
                  request["Service-Request-Type"]
                      .toString()
                      .toUpperCase(), // Formatted time
                  style: TextStyle(
                      color: statusColor,
                      fontSize: 20,
                      fontFamily: GoogleFonts.ubuntu().fontFamily),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status: ${request["Status"].toString()}',
                          style: TextStyle(color: statusColor),
                        ),
                        Text(
                          'Service Requested Time: $formattedTime', // Formatted time
                          
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        CustomButton(
                          h: 40,
                          text: 'More Details',
                          textColor: Colors.black,
                          fsize: 16,
                          suffixIcon: Icons.arrow_right_sharp,
                          buttonColor: Colors.white,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReqServiceDetail(
                                  providerID:
                                      request["ProviderID"], // Pass provider ID
                                  serviceRequestType: request[
                                      "Service-Request-Type"], // Pass service request type
                                  requestedTime:
                                      formattedTime, // Pass formatted time
                                  status: request["Status"], // Pass status
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
