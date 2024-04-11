// import 'package:convex_bottom_bar/convex_bottom_bar.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/Pages/View/account.dart';
// import 'package:provider/Pages/View/manage.dart';
// import 'package:provider/Colors/appcolor.dart';
// import 'package:provider/Pages/Utils/custom_button.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 1;

//   static const List<Widget> _widgetOptions = <Widget>[
//     ManagePage(),
//     HomePageContent(),
//     AccountPage(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: _widgetOptions.elementAt(_selectedIndex),
//       ),
//       bottomNavigationBar: ConvexAppBar(
//         items: const [
//           TabItem(icon: Icons.settings_suggest_rounded, title: 'Service'),
//           TabItem(icon: Icons.home_rounded, title: 'Home'),
//           TabItem(icon: Icons.person, title: 'Account'),
//         ],
//         style: TabStyle.textIn,
//         color: Colors.black54,
//         activeColor: Colors.black,
//         backgroundColor: Colors.white,
//         height: 50,
//         initialActiveIndex: 1,
//         elevation: 5,
//         onTap: (int index) => setState(() {
//           _selectedIndex = index;
//         }),
//       ),
//     );
//   }
// }

// class HomePageContent extends StatefulWidget {
//   const HomePageContent({Key? key}) : super(key: key);

//   @override
//   _HomePageContentState createState() => _HomePageContentState();
// }

// class _HomePageContentState extends State<HomePageContent> {
//   late Map<String, dynamic> userDetails;
//   String currentDate = DateFormat.yMMMMd('en_US').format(DateTime.now());
//   String currentTime = DateFormat.jms().format(DateTime.now());

//   @override
//   void initState() {
//     super.initState();
//     getUserData();
//   }

//   void getUserData() async {
//     final currentUser = FirebaseAuth.instance.currentUser!;
//     final userSnapshot = await FirebaseFirestore.instance
//         .collection('USERS')
//         .doc(currentUser.email)
//         .get();

//     if (userSnapshot.exists) {
//       setState(() {
//         userDetails = userSnapshot.data() as Map<String, dynamic>;
//       });
//     } else {
//       // Handle case where user data does not exist
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('PROVIDERS')
//           .doc(FirebaseAuth.instance.currentUser!.email)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(
//             child: Text('Error: ${snapshot.error}'),
//           );
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }

//         final userDetails = snapshot.data?.data() as Map<String, dynamic>?;

//         if (userDetails == null) {
//           return Center(
//             child: Text('User details not found.'),
//           );
//         }

//         return StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('SERVICE-REQUEST')
//               .where("UserID", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Center(
//                 child: Text('Error: ${snapshot.error}'),
//               );
//             }

//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }

//             final userRequests = snapshot.data!.docs;
//             if (userRequests.isEmpty) {
//               return Center(
//                 child: Text('No service requests found.'),
//               );
//             }

//             return Expanded(
//               child: ListView.builder(
//                 itemCount: userRequests.length,
//                 itemBuilder: (context, index) {
//                   final request = userRequests[index].data()
//                       as Map<String, dynamic>;
//                   DateTime requestedTime =
//                       (request["Requested-Time"] as Timestamp).toDate();
//                   String formattedTime = DateFormat('yyyy-MM-dd HH:mm')
//                       .format(requestedTime);

//                   // Change text color based on status
//                   Color statusColor = Colors.white; // Default color

//                   if (request["Status"] == "Pending") {
//                     statusColor = Colors
//                         .yellow; // Change to yellow if status is pending
//                   } else if (request["Status"] == "Accepted") {
//                     statusColor = Colors
//                         .green; // Change to green if status is accepted
//                   } else if (request["Status"] == "Declined") {
//                     statusColor = Colors.red; // Change to red if status is declined
//                   } else {
//                     print('Unknown status: ${request["Status"]}');
//                   }

//                   return ExpansionTile(
//                     title: Text(
//                       request["Service-Request-Type"]
//                           .toString()
//                           .toUpperCase(), // Formatted time
//                       style: TextStyle(
//                           color: statusColor,
//                           fontSize: 20,
//                           fontFamily: GoogleFonts.ubuntu().fontFamily),
//                     ),
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Status: ${request["Status"].toString()}',
//                               style: TextStyle(color: statusColor),
//                             ),
//                             Text(
//                               'Service Requested Time: $formattedTime', // Formatted time
//                             ),
//                             SizedBox(
//                               height: 7,
//                             ),
//                             CustomButton(
//                               h: 40,
//                               text: 'More Details',
//                               textColor: Colors.black,
//                               fsize: 16,
//                               suffixIcon: Icons.arrow_right_sharp,
//                               buttonColor: Colors.white,
//                               onPressed: () {
//                                 // Add your logic for handling more details button press
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
