import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:provider/Components/mybutton.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class MecSlider extends StatefulWidget {
  final TextEditingController mecPriceController;

  const MecSlider({
    Key? key,
    required this.mecPriceController,
  }) : super(key: key);

  @override
  _MecSliderState createState() => _MecSliderState();
}

class _MecSliderState extends State<MecSlider> {
  late SfRangeValues _values;
  bool priceRangeSet = false;

  @override
  void initState() {
    super.initState();
    _values = const SfRangeValues(500.0, 1000.0); // Initial values for the slider
  }

  void _setPriceRange() {
    setState(() {
      priceRangeSet = true;
      widget.mecPriceController.text =
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
              _setPriceRange(); // Call _setPriceRange to update the controller's text
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              const SizedBox(width: 17,),
              MyButton(
                onTap: () {
                  if (_values != null) {
                    _setPriceRange();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Price range set successfully')),
                      
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content:  Text('Please set a price range')),
                    );
                  }
                },
                text: 'Set',
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}