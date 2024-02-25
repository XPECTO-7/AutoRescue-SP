import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:provider/Components/mybutton.dart';

class AddServicePage extends StatefulWidget {
  const AddServicePage({Key? key}) : super(key: key);

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  TextEditingController serviceTypeController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController licenseController = TextEditingController();
  TextEditingController insuranceController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.OxfordBlue,
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 1,
        backgroundColor: AppColors.OxfordBlue,
        title: Row(
          children: [
            const Icon(
              Icons.add,
              size: 25,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              'Service',
              style: TextStyle(
                fontFamily: GoogleFonts.ubuntu().fontFamily,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              TextField(
                controller: companyNameController,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.business),
                  hintText: "Company / Shop Name",
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 7,
                decoration: const InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.description_sharp),
                ),
              ),
              const SizedBox(height: 10),
              DropdownSearch<String>(
                popupProps: PopupProps.menu(
                  showSelectedItems: true,
                  disabledItemFn: (String s) => s.startsWith('I'),
                ),
                items: const [
                  'Emergency Fuel Refilling',
                  'Flat Tyre',
                  'Vehicle Engine Related Service',
                  'Emergency Towing',
                  'EV Charging service',
                  'Key Lockout'
                ],
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  baseStyle: TextStyle(fontSize: 16),
                  dropdownSearchDecoration: InputDecoration(
                      hintText: 'Select Service',
                      hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey))),
                ),
                onChanged: print,
              ),
              const SizedBox(height: 10),
              // Add Location
              TextField(
                controller: licenseController,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.edit_document),
                  hintText: 'License Number',
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: insuranceController,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.edit_document),
                  hintText: 'Insurance Number',
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.location_on_outlined),
                  hintText: 'Location',
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(
                thickness: 0.5,
                color: Colors.grey,
              ),
              const Center(
                child: Text(
                  'All provided details are currently undergoing verification. Once verified, Service will be activated',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              MyButton(onTap: () {}, text: 'Submit', color: Colors.cyan)
            ],
          ),
        ),
      ),
    );
  }
}
