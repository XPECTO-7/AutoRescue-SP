import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/Colors/appcolor.dart';

class ShowVehicleDetails extends StatefulWidget {
  final String userID;
  final String vehicleID;

  const ShowVehicleDetails({
    Key? key,
    required this.userID,
    required this.vehicleID,
  }) : super(key: key);

  @override
  _ShowVehicleDetailsState createState() => _ShowVehicleDetailsState();
}

class _ShowVehicleDetailsState extends State<ShowVehicleDetails> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _vehicleDetails;

  @override
  void initState() {
    super.initState();
    _vehicleDetails = _fetchVehicleDetails();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchVehicleDetails() async {
    return await FirebaseFirestore.instance
        .collection("USERS")
        .doc(widget.userID)
        .collection("VEHICLES")
        .doc(widget.vehicleID)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title:  const Row(
          children: [
            Icon(Icons.directions_car, color: AppColors.appPrimary,size: 37,),
            SizedBox(width: 8),
           
          ],
        ),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: _vehicleDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final vehicleData = snapshot.data!.data();
            if (vehicleData == null) {
              return const Center(child: Text('Vehicle not found'));
            } else {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeading('Vehicle Image'),
                    const SizedBox(height: 10),
                    _buildImageWidget(vehicleData['vehicleImageURL']),
                    const SizedBox(height: 10),
                    _buildSectionHeading('RC Book Image'),
                    const SizedBox(height: 10),
                    _buildImageWidget(vehicleData['vehicleRCImageURL']),
                    const SizedBox(height: 32),
                    _buildDetailRow('Manufacturer', vehicleData['Manufacturer']),
                    const SizedBox(height: 10),
                    _buildDetailRow('Vehicle Name', vehicleData['VehicleName']),
                    const SizedBox(height: 10),
                    _buildDetailRow('Manufacture Year', vehicleData['Year']),
                    const SizedBox(height: 10),
                    _buildDetailRow('Registration Number', vehicleData['RegistrationNumber']),
                    const SizedBox(height: 10),
                    _buildDetailRow('Kilometers', vehicleData['Kilometers']),
                    const SizedBox(height: 10),
                    _buildDetailRow('Fuel Type', vehicleData['FuelType']),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildSectionHeading(String text) {
    return Text(
      text,
      style: GoogleFonts.nunito(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildImageWidget(String? imageUrl) {
    return imageUrl != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          )
        : Container(
            width: double.infinity,
            height: 200,
            color: Colors.grey[400],
            child: Center(
              child: Text(
                'Image not available',
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 7,
          child: Text(
            label + ':',
            style: GoogleFonts.nunito(
              color: AppColors.appPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 7,
          child: Text(
            value,
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
