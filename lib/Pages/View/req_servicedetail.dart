import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart'; // Import Firestore

class ReqServiceDetail extends StatefulWidget {
  final String providerID;
  final String serviceRequestType;
  final String requestedTime; // Define requestedTime parameter
  final String status;

  const ReqServiceDetail({
    required this.providerID,
    required this.serviceRequestType,
    required this.requestedTime,
    required this.status,
  });

  @override
  State<ReqServiceDetail> createState() => _ReqServiceDetailState();
}

class _ReqServiceDetailState extends State<ReqServiceDetail> {
  late Stream<DocumentSnapshot> providerStream; // Define providerStream

  @override
  void initState() {
    super.initState();
    // Initialize providerStream in initState
    providerStream = FirebaseFirestore.instance
        .collection("PROVIDERS")
        .doc(widget.providerID) // Assuming providerID is the document ID in PROVIDERS collection
        .snapshots();
  }

  TextStyle sstyle = TextStyle(
    fontFamily: GoogleFonts.ubuntu().fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Row(
          children: [
            Text(
              '${widget.status}',
              style: TextStyle(
                fontFamily: GoogleFonts.ubuntu().fontFamily,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Provider Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            StreamBuilder<DocumentSnapshot>(
              stream: providerStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                // Extract provider data from snapshot
                final providerData = snapshot.data!;
                final providerName = providerData["Fullname"];
                final providerCompany = providerData["Company Name"];
                final providerPH = providerData["Phone Number"];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Provider Name: $providerName',style: sstyle),
                    const SizedBox(height: 5),
                    Text('Company Name: $providerCompany',style: sstyle),
                    const SizedBox(height: 5),
                    Text('Phone Number: $providerPH',style: sstyle),
                    const SizedBox(height: 5),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Service Request Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Service Request Type: ${widget.serviceRequestType}',style: sstyle),
            const SizedBox(height: 5),
            Text('Requested Time: ${widget.requestedTime}',style: sstyle),
            const SizedBox(height: 5),
            Row(
              children: [
                Text('Status:',style: sstyle),
                Text(' ${widget.status}', style: TextStyle(
                    color: widget.status == "Pending"
                        ? Colors.yellow
                        : widget.status == "Accepted"
                            ? Colors.green
                            : widget.status == "Declined"
                                ? Colors.red
                                : Colors.black, // Default text color for unknown status
                    fontFamily: GoogleFonts.ubuntu().fontFamily,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  TimelineTile(
                    alignment: TimelineAlign.manual,
                    lineXY: 0.3,
                    isFirst: true,
                    indicatorStyle: const IndicatorStyle(
                      width: 30,
                      color: Colors.blue, // Color of the dot
                      indicatorXY: 0.5,
                    ),
                    startChild: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        'Requested',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    endChild: Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Time: ${widget.requestedTime}',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  if (widget.status == "Accepted" || widget.status == "Declined")
                    TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.3,
                      indicatorStyle: const IndicatorStyle(
                        width: 30,
                        color: Colors.green,
                        indicatorXY: 0.5,
                      ),
                      startChild: Container(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          widget.status == "Accepted" ? 'Accepted' : 'Declined',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      endChild: Container(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                           'Time: ${DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now())}',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  if (widget.status == "Accepted")
                    StreamBuilder<DocumentSnapshot>(
                      stream: providerStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final providerData = snapshot.data!;
                          final providerPH = providerData["Phone Number"];

                          return TimelineTile(
                            alignment: TimelineAlign.manual,
                            lineXY: 0.3,
                            indicatorStyle: const IndicatorStyle(
                              width: 30,
                              color: Colors.orange,
                              indicatorXY: 0.5,
                            ),
                            startChild: Container(
                              padding: const EdgeInsets.all(8),
                              child: const Text(
                                'On the Way',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            endChild: Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                'Provider Phone: $providerPH',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  if (widget.status == "Completed")
                    TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.3,
                      isLast: true,
                      indicatorStyle: const IndicatorStyle(
                        width: 30,
                        color: Colors.red,
                        indicatorXY: 0.5,
                      ),
                      startChild: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Text(
                          'Service Completed',
                          style: TextStyle(
                            fontSize:
                            16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      endChild: Container(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          'Time: ${DateTime.now().toString()}',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
