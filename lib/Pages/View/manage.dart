import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:provider/Pages/Utils/custom_button.dart';
import 'package:provider/Pages/View/get_location.dart';
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
        .where("Status", whereIn: [
          "Accepted",
          "Completed"
        ]) // Filter accepted and completed requests
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  Future<void> _deleteRequest(String requestId) async {
    bool confirmDeletion = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this request?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true if confirmed
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false if canceled
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );

    // Delete the request if confirmation is true
    if (confirmDeletion == true) {
      try {
        await FirebaseFirestore.instance
            .collection("SERVICE-REQUEST")
            .doc(requestId)
            .delete();
        // Trigger UI rebuild
        setState(() {});
      } catch (e) {
        print("Error deleting request: $e");
        // Handle error as per your requirement
      }
    }
  }

  Future<void> _completeService(String requestId) async {
    // Show confirmation dialog
    bool confirmServiceCompletion = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Service Completion"),
          content: const Text("Is the service completed successfully?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true if confirmed
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false if canceled
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );

    // Update status if service completion is confirmed
    if (confirmServiceCompletion == true) {
      try {
        await FirebaseFirestore.instance
            .collection("SERVICE-REQUEST")
            .doc(requestId)
            .update({"Status": "Completed"});
        // Trigger UI rebuild
        setState(() {});
      } catch (e) {
        print("Error completing service: $e");
        // Handle error as per your requirement
      }
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
              bool isCompleted = request["Status"] == "Completed";
              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                color: Colors.grey[900],
                child: ExpansionTile(
                  initiallyExpanded: !isCompleted,
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
                            style: TextStyle(
                              color: isCompleted ? Colors.white : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
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
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GetLocationPage(
                                    currentLocationX: double.parse(request["UserLocation-Lat"]),
                                    currentLocationY: double.parse(request["UserLocation-Long"]),
                                  ),
                                ),
                              );
                            },
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
                            text: request["Status"] == "Completed"
                                ? 'Service Completed'
                                : 'Complete Service',
                            textColor: request["Status"] == "Completed"
                                ? Colors.black
                                : Colors
                                    .white, // Change text color based on status
                            fsize: 16,
                            suffixIcon: FontAwesomeIcons.listCheck,
                            buttonColor: request["Status"] == "Completed"
                                ? AppColors.app1Three
                                : Colors
                                    .redAccent, // Change button color based on status
                            onPressed: () {
                              if (request["Status"] != "Completed") {
                                _completeService(userRequest[index]
                                    .id); // Pass requestId only if status is not completed
                              }
                            },
                          ),
                          if (request["Status"] == "Completed")
                            CustomButton(
                              h: 40,
                              text: 'Delete Request',
                              textColor: Colors.white,
                              fsize: 16,
                              suffixIcon: FontAwesomeIcons.trash,
                              buttonColor: Colors.red,
                              onPressed: () {
                                _deleteRequest(userRequest[index].id);
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
