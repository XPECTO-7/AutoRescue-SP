import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:provider/Components/mybutton.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class evSlider extends StatefulWidget {
  final TextEditingController evPriceController;

  const evSlider({
    Key? key,
    required this.evPriceController,
  }) : super(key: key);

  @override
  _evSliderState createState() => _evSliderState();
}

class _evSliderState extends State<evSlider> {
  late SfRangeValues _values;
  bool priceRangeSet = false;

  @override
  void initState() {
    super.initState();
    _values = const SfRangeValues(1000.0, 2000.0); // Initial values for the slider
  }

  void _setPriceRange() {
    setState(() {
      priceRangeSet = true;
      widget.evPriceController.text =
          '${_values.start.toInt()}-${_values.end.toInt()}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: SfRangeSlider(
            min: 0.0,
            max: 5000.0,
            values: _values,
            onChanged: (SfRangeValues values) {
              setState(() {
                _values = values;
              });
            },
           activeColor: AppColors.appPrimary,
            inactiveColor: Colors.white,
            showTicks: true,
            showLabels: true,
            enableTooltip: true,
            numberFormat: NumberFormat.decimalPattern(),
            tooltipTextFormatterCallback: (dynamic value, String position) {
              return '₹${value.toInt()}';
            },
            stepSize: 20,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17.0),
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.appTertiary),
                borderRadius: BorderRadius.circular(3)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      '₹${_values.start.toInt()}  - ',
                      style: TextStyle(
                        color: Colors.green,
                        fontFamily: GoogleFonts.strait().fontFamily,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '₹${_values.end.toInt()}',
                      style: TextStyle(
                        color: Colors.green,
                        fontFamily: GoogleFonts.strait().fontFamily,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_values != null) {
                      _setPriceRange();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Price range set successfully'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please set a price range'),
                        ),
                      );
                    }
                  },
                  label: const Text('SET'),
                  icon: const Icon(Icons.check_circle_outline_outlined),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, 
                  
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
