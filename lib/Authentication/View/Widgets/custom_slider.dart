import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class CustomRangeSlider extends StatefulWidget {
  final String serviceType;
  final TextEditingController controller;
  final String whichtype;

  const CustomRangeSlider({
    Key? key,
    required this.serviceType,
    required this.controller,
    required this.whichtype
  }) : super(key: key);

  @override
  _CustomRangeSliderState createState() => _CustomRangeSliderState();
}

class _CustomRangeSliderState extends State<CustomRangeSlider> {
  // Define your range values
  double _min = 100;
  double _max = 1000;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Replace your existing TextField with SfRangeSlider
        if (widget.serviceType == 'whichtype')
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: SfRangeSlider(
              min: 100.0,
              max: 10000.0,
              values: SfRangeValues(_min, _max),
              onChanged: (SfRangeValues values) {
                setState(() {
                  _min = values.start;
                  _max = values.end;
                  // Update the controller values
                  widget.controller.text =
                      '₹${_min.toInt()} - ₹${_max.toInt()}';
                });
              },
              showTicks: true,
              showLabels: true,
              enableTooltip: true,
              numberFormat: NumberFormat.decimalPattern(), // Modified line
              tooltipTextFormatterCallback: (dynamic value, String position) {
                return '₹${value.toInt()}';
              },
              activeColor: AppColors.appPrimary, // Change the slider color here
            ),
          ),
        // Display the TextField with the updated range
        TextField(
          controller: widget.controller,
          keyboardType: TextInputType.number, // Input type set to number only
          readOnly: false, // Now editable
          decoration: const InputDecoration(
            labelText: '*Additional Service Charges Seperately',
            labelStyle: TextStyle(fontSize: 12)
          ),
        ),
      ],
    );
  }
}
