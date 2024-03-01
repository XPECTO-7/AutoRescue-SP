import 'package:flutter/material.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:provider/Components/mybutton.dart';

class ServiceDetailsView extends StatefulWidget {
  const ServiceDetailsView({super.key});

  @override
  State<ServiceDetailsView> createState() => _ServiceDetailsViewState();
}

class _ServiceDetailsViewState extends State<ServiceDetailsView> {
  TextEditingController serviceTypeController = TextEditingController();

  TextEditingController companyNameController = TextEditingController();

  TextEditingController expController = TextEditingController();

  TextEditingController licenseController = TextEditingController();

  TextEditingController insuranceController = TextEditingController();

  TextEditingController locationController = TextEditingController();

  TextEditingController MecPriceController = TextEditingController();
  final List<String> serviceTypes = [
    'Fuel Delivery Service',
    'Mechanical Service',
    'Emergency Towing Service',
    'EV Charging service',
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: companyNameController,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.business),
                  hintText: "Company / Workshop Name",
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.appPrimary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.appPrimary),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.location_on_outlined),
                  hintText: 'Location',
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.appPrimary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.appPrimary),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: expController,
                // keyboardType: const TextInputType
                //     .numberWithOptions(
                //     decimal:
                //         false),
                // inputFormatters: <TextInputFormatter>[
                //   FilteringTextInputFormatter
                //       .digitsOnly
                // ],
                decoration: const InputDecoration(
                  hintText: "Experience In Years",
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.appPrimary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.appPrimary),
                  ),
                  suffixIcon: Icon(Icons.handyman_sharp),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: licenseController,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.edit_document),
                  hintText: 'License Number',
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.appPrimary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.appPrimary),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: insuranceController,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.edit_document),
                  hintText: 'Insurance Number',
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.appPrimary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.appPrimary),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: const InputDecoration(
                  hintText: "Select Service",
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.appPrimary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.appPrimary),
                  ),
                ),
                items: serviceTypes
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {},
                validator: (value) {
                  if (value == null) {
                    return 'Please Select Service Type.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              const Text('Service Charge Details :'),
              if (serviceTypeController.text == 'Mechanical Service')
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: TextField(
                    controller: MecPriceController,
                    decoration: const InputDecoration(
                      hintText: ' ₹ INR',
                      hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.appPrimary),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.appPrimary),
                      ),
                    ),
                  ),
                ),
              const SizedBox(
                height: 40,
              ),
              MyButton(
                  onTap: () {},
                  text: 'Register',
                  textColor: Colors.black,
                  buttonColor: AppColors.appPrimary)
            ],
          ),
        ),
      ],
    );
  }
}
