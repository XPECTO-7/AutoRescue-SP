import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:provider/Pages/View/account.dart';
import 'package:provider/Pages/View/home_page.dart';

class EditVehiclePage extends StatefulWidget {
  final Map<String, dynamic> vehicleDetails;

  const EditVehiclePage({Key? key, required this.vehicleDetails})
      : super(key: key);

  @override
  _EditVehiclePageState createState() => _EditVehiclePageState();
}

class _EditVehiclePageState extends State<EditVehiclePage> {
  late TextEditingController _manufacturerController;
  late TextEditingController _vehicleNameController;
  late TextEditingController _yearController;
  late TextEditingController _registrationNumberController;
  late TextEditingController _kilometersController;
  late String? _selectedFuelType;
  File? _pickedVehicleImage;
  late String? _vehicleImageURL;

  final _hintTextStyle = const TextStyle(
    fontSize: 16,
    color: Colors.grey,
  );

  final _labelTextStyle = const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    _manufacturerController = TextEditingController(
        text: widget.vehicleDetails['manufacturer'] ?? '');
    _vehicleNameController =
        TextEditingController(text: widget.vehicleDetails['vehicleName'] ?? '');
    _yearController =
        TextEditingController(text: widget.vehicleDetails['year'] ?? '');
    _registrationNumberController = TextEditingController(
        text: widget.vehicleDetails['registrationNumber'] ?? '');
    _kilometersController =
        TextEditingController(text: widget.vehicleDetails['kilometers'] ?? '');
    _selectedFuelType = widget.vehicleDetails['fueltype'];

    _vehicleImageURL = widget.vehicleDetails['vehicleImageURL'];
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImageFile = await ImagePicker().pickImage(
      source: source,
      maxWidth: 500,
    );

    if (pickedImageFile == null) return;

    setState(() {
      _pickedVehicleImage = File(pickedImageFile.path);
    });
  }

  Future<String?> _uploadImageToFirebase(File imageFile) async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('vehicle_images')
        .child(
            '${currentUser.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg');

    await storageRef.putFile(imageFile);

    final vehicleImageURL = await storageRef.getDownloadURL();
    return vehicleImageURL;
  }

  Future<void> _updateVehicle() async {
    final manufacturer = _manufacturerController.text;
    final year = _yearController.text;
    final vehicleName = _vehicleNameController.text;
    final registrationNumber = _registrationNumberController.text;
    final kilometers = _kilometersController.text;
    final fuelType = _selectedFuelType;

    if (manufacturer.isEmpty ||
        year.isEmpty ||
        vehicleName.isEmpty ||
        registrationNumber.isEmpty ||
        kilometers.isEmpty ||
        fuelType == null) {
      // Show error message if any field is empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Error",
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.strait().fontFamily,
              ),
            ),
            content: const Text("Please Fill in all fields."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return; // Stop execution if any field is empty
    }

    // Initialize vehicleImageURL as null
    String? vehicleImageURL;

    // Upload image to Firebase Storage if a new image is picked
    if (_pickedVehicleImage != null) {
      vehicleImageURL = await _uploadImageToFirebase(_pickedVehicleImage!);
    }

    // Update the vehicle details in the database
    final currentUser = FirebaseAuth.instance.currentUser!;
    final vehicleRef = FirebaseFirestore.instance
        .collection('USERS')
        .doc(currentUser.email)
        .collection('VEHICLES');

    // Use the registration number as the document ID
    final vehicleDocRef = vehicleRef.doc(registrationNumber);

    // Create a map to store updated vehicle details
    final Map<String, dynamic> updatedVehicleDetails = {
      'Manufacturer': manufacturer,
      'Year': year,
      'VehicleName': vehicleName,
    
      'Kilometers': kilometers,
      'FuelType': fuelType,
    };

    // Add vehicle image URL to the map if it's not null
    if (vehicleImageURL != null) {
      updatedVehicleDetails['vehicleImageURL'] = vehicleImageURL;
    }

    // Update the vehicle document in Firestore
    await vehicleDocRef.update(updatedVehicleDetails);

    // Clear the text fields after submission
    _manufacturerController.clear();
    _yearController.clear();
    _vehicleNameController.clear();
    _kilometersController.clear();
    setState(() {
      _selectedFuelType = null;
      _pickedVehicleImage = null;
    });

    // Show a dialog to indicate successful submission
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Vehicle Updated Successfully",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: GoogleFonts.strait().fontFamily,
                fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>  HomePage(),
                  ),
                );
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          children: [
            Image.asset(
              'lib/images/editvehicle.png',
              color: AppColors.appTertiary,
              width: 35,
              height: 35,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Edit ${_manufacturerController.text}',
              style: const TextStyle(
                color: AppColors.appTertiary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
              size: 37,
              color: Colors.red,
            ),
            onPressed: () {
              // Show a confirmation dialog before deleting the vehicle
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                      "Confirm Delete",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Text(
                        "Are you sure you want to delete ${_manufacturerController.text}?"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          // Dismiss the dialog when cancel button is pressed
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () async {
                          // Delete the vehicle from Firestore collection
                          final currentUser =
                              FirebaseAuth.instance.currentUser!;
                          final vehicleRef = FirebaseFirestore.instance
                              .collection('USERS')
                              .doc(currentUser.email)
                              .collection('VEHICLES');
                          await vehicleRef
                              .doc(_registrationNumberController.text)
                              .delete();

                          // Close the dialog and navigate back
                          Navigator.of(context).pop();
                          Navigator.of(context)
                              .pop(); // Pop twice to go back to the previous page
                        },
                        child: const Text("Delete"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 200,
                color: Colors.grey[200],
                child: Center(
                  child: _pickedVehicleImage == null
                      ? _vehicleImageURL != null
                          ? Image.network(
                              _vehicleImageURL!,
                              fit: BoxFit.cover,
                            )
                          : IconButton(
                              icon: const Icon(
                                Icons.photo_camera,
                                size: 150,
                              ),
                              onPressed: () {
                                _pickImage(ImageSource.gallery);
                              },
                            )
                      : Image.file(
                          _pickedVehicleImage!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Manufacture',
                style: _labelTextStyle,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _manufacturerController,
                decoration: InputDecoration(
                  hintText: 'Eg: Kia, Ola, Yamaha',
                  hintStyle: _hintTextStyle,
                  suffixIcon: const Icon(Icons.business, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Vehicle Name',
                style: _labelTextStyle,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _vehicleNameController,
                decoration: InputDecoration(
                  hintText: 'Eg: Seltos, S1, R15 V4',
                  hintStyle: _hintTextStyle,
                  suffixIcon:
                      const Icon(Icons.directions_car, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Manufacture Year',
                style: _labelTextStyle,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _yearController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: InputDecoration(
                  hintText: 'Eg: 2020',
                  hintStyle: _hintTextStyle,
                  suffixIcon:
                      const Icon(Icons.calendar_today, color: Colors.white),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Registration Number',
                style: _labelTextStyle,
              ),
              const SizedBox(height: 8),
              TextFormField(
                enabled: false,
                controller: _registrationNumberController,
                decoration: InputDecoration(
                  hintText: 'Eg: KL 7 CG 369',
                  hintStyle: _hintTextStyle,
                  suffixIcon:
                      const Icon(Icons.numbers_rounded, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Kilometers',
                style: _labelTextStyle,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _kilometersController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  hintText: 'Eg: 2000',
                  hintStyle: _hintTextStyle,
                  suffixIcon: const Icon(Icons.speed, color: Colors.white),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Fuel Type',
                style: _labelTextStyle,
              ),
              const SizedBox(height: 8),
              Container(
                height: 60,
                child: DropdownButtonFormField<String>(
                  value: _selectedFuelType,
                  onChanged: (value) {
                    setState(() {
                      _selectedFuelType = value!;
                    });
                  },
                  items: <String?>['Electric', 'CNG', 'Petrol', 'Diesel']
                      .map((String? value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value!,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    hintText: 'Select Fuel Type',
                    hintStyle: _hintTextStyle,
                    suffixIcon: const Icon(Icons.local_gas_station,
                        color: Colors.white),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateVehicle,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  'UPDATE VEHICLE',
                  style: TextStyle(
                      fontSize: 19,
                      fontFamily: GoogleFonts.strait().fontFamily,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _manufacturerController.dispose();
    _yearController.dispose();
    _vehicleNameController.dispose();
    _registrationNumberController.dispose();
    _kilometersController.dispose();
    super.dispose();
  }
}
