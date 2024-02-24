import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DDList extends StatefulWidget {
  final Function(String) onSelected;
  const DDList({super.key,required this.onSelected});

  @override
  State<DDList> createState() => _DDListState();
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
  return SingleChildScrollView(
    child: Column(
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
          child: SizedBox(
            width: double.infinity,
            height: 100,
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
              ),
              iconSize: 35,
              isExpanded: true,
              items: bankDataList
                  .map<DropdownMenuItem<String>>(
                    (Map<String, String> bankData) => DropdownMenuItem<String>(
                      value: bankData['name'],
                      child: ListView(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                bankData['logoAsset']!,
                                height: 40,
                                width: 40,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/placeholder.png',
                                    height: 40,
                                    width: 40,
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
                          Divider(
                            thickness: 0.1,
                            color: Colors.grey[900],
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    ),
  );
}
}