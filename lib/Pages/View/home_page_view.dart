import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/Components/mybutton.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:provider/Pages/Utils/custom_button.dart';
import 'package:provider/Pages/View/manage.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("PROVIDERS")
          .doc(user.email)
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          final userDetails = snapshot.data!.data() as Map<String, dynamic>;
          final bool approved = userDetails['Approved'] == true;

          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 80,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/images/cserv.png',
                    color: AppColors.appPrimary,
                    width: 60,
                    height: 60,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    'AutoRescue',
                    style: TextStyle(
                      fontFamily: GoogleFonts.ubuntu().fontFamily,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                ],
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7.0),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          userDetails['Service Type'].toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (approved)
                    Expanded(
                      child: StreamBuilder<List<DocumentSnapshot>>(
                        stream: FirebaseFirestore.instance
                            .collection("SERVICE-REQUEST")
                            .where("ProviderID", isEqualTo: user.email)
                            .where("Status", isNotEqualTo: "Completed")
                            .snapshots()
                            .map((snapshot) => snapshot.docs),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final serviceRequests = snapshot.data ?? [];
                          if (serviceRequests.isEmpty) {
                            return const Center(
                              child: Text('No service requests found.'),
                            );
                          }

                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListView.builder(
                              itemCount: serviceRequests.length,
                              itemBuilder: (context, index) {
                                final request = serviceRequests[index].data()
                                    as Map<String, dynamic>;
                                DateTime requestedTime =
                                    (request["Requested-Time"] as Timestamp)
                                        .toDate();
                                String formattedTime =
                                    DateFormat('MMMM dd, yyyy hh:mm a')
                                        .format(requestedTime);

                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white30,
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4.0,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          request["UserID"].toString(),
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontFamily:
                                                GoogleFonts.ubuntu().fontFamily,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Requested Time: $formattedTime\nStatus: ${request["Status"].toString()}',
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              _updateStatus(
                                                  serviceRequests[index].id,
                                                  "Accepted");
                                            },
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          7.0), // Adjust the radius as per your requirement
                                                ),
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                                  // Color based on the current status
                                                  if (request["Status"] ==
                                                      "Accepted") {
                                                    return Colors.green;
                                                  } else {
                                                    return Colors.grey.shade700;
                                                  }
                                                },
                                              ),
                                            ),
                                            child: Text(
                                              request["Status"] == "Accepted"
                                                  ? 'Accepted'
                                                  : 'Accept',
                                              style: TextStyle(
                                                color: AppColors.appTertiary,
                                                fontFamily: GoogleFonts.ubuntu()
                                                    .fontFamily,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              _updateStatus(
                                                  serviceRequests[index].id,
                                                  "Rejected");
                                            },
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          7.0), // Adjust the radius as per your requirement
                                                ),
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                                  // Color based on the current status
                                                  if (request["Status"] ==
                                                      "Rejected") {
                                                    return Colors.red;
                                                  } else {
                                                    return Colors.grey.shade700;
                                                  }
                                                },
                                              ),
                                            ),
                                            child: Text(
                                              request["Status"] == "Rejected"
                                                  ? 'Rejected'
                                                  : 'Reject',
                                              style: TextStyle(
                                                color: AppColors.appTertiary,
                                                fontFamily: GoogleFonts.ubuntu()
                                                    .fontFamily,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  if (!approved)
                    Expanded(
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.all(20.0),
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                'assets/check.json',
                                height: 200,
                              ),
                              Text(
                                "Your company details are currently undergoing verification.\n\nPlease await confirmation from our administrators.\n\nPlease be advised that the verification process may take up to 24 hours to complete.\n\n We appreciate your understanding and patience during this time.",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: GoogleFonts.ubuntu().fontFamily,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        } else {
          return const Scaffold();
        }
      },
    );
  }

  void _updateStatus(String requestId, String newStatus) {
    FirebaseFirestore.instance
        .collection("SERVICE-REQUEST")
        .doc(requestId)
        .update({"Status": newStatus}).then((_) {
      print("Status updated to $newStatus");
    }).catchError((error) {
      print("Error updating status: $error");
    });
  }
}
