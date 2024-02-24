import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DDList extends StatefulWidget {
  final Function(String) onSelected;

  const DDList({Key? key, required this.onSelected}) : super(key: key);

  @override
  _DDListState createState() => _DDListState();
}

class _DDListState extends State<DDList> {
  String? _selectedService;

  // Define bank data directly within the widget
  List<Map<String, String>> bankDataList = [
    {
      "name": "Fuel Delivery Service",
      "logoAsset": "lib/images/fuel.png",
    },
    {
      "name": "Tyre Related Service",
      "logoAsset": "lib/images/tyre.png",
    },
    {
      "name": "Engine Related Service",
      "logoAsset": "lib/images/automotive.png",
    },
    {
      "name": "Towing Service",
      "logoAsset": "lib/images/tow-truck.png",
    },
    {
      "name": "EV Charging service",
      "logoAsset": "lib/images/charging-station.png",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: Text(
            'Select Service',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: DropdownButtonFormField<String>(
            value: _selectedService,
            onChanged: (String? newValue) {
              setState(() {
                _selectedService = newValue;
                widget.onSelected(newValue!);
              });
            },
            dropdownColor: Colors.white,
            style: const TextStyle(
              fontSize: 17,
              color: Colors.black,
            ), // Add this line for white background
            iconSize: 35,
            isExpanded: true,
            items: bankDataList
                .map<DropdownMenuItem<String>>(
                  (Map<String, String> bankData) => DropdownMenuItem<String>(
                    value: bankData['name'],
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                          child: Row(
                            children: [
                              Image.asset(
                                bankData['logoAsset']!,
                                height: 40, // Adjust height as needed
                                width: 40, // Adjust width as needed
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/placeholder.png', // Path to placeholder image asset
                                    height: 32,
                                    width: 32,
                                  );
                                },
                              ),
                              const SizedBox(width: 10),
                              Text(
                                bankData['name']!,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: GoogleFonts.ubuntu().fontFamily,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 0.1,
                          color: Colors.grey[900],
                        ), // Add a divider after each item
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
