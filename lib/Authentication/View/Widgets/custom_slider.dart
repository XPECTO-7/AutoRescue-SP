import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class CustomRangeSlider extends StatefulWidget {
  final String serviceType;
  final TextEditingController controller;
  final Map<String, SfRangeValues> priceRanges;

  const CustomRangeSlider({
    Key? key,
    required this.serviceType,
    required this.controller,
    required this.priceRanges,
  }) : super(key: key);

  @override
  _CustomRangeSliderState createState() => _CustomRangeSliderState();
}

class _CustomRangeSliderState extends State<CustomRangeSlider> {
  late SfRangeValues _values;

  @override
  void initState() {
    super.initState();
    // Convert int values to double
    double start = widget.priceRanges[widget.serviceType]!.start.toDouble();
    double end = widget.priceRanges[widget.serviceType]!.end.toDouble();
    _values = SfRangeValues(start, end);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: SfRangeSlider(
            min: widget.priceRanges[widget.serviceType]!.start.toDouble(), // Convert int to double
            max: widget.priceRanges[widget.serviceType]!.end.toDouble(), // Convert int to double
            values: _values,
            onChanged: (SfRangeValues values) {
              setState(() {
                _values = values;
                widget.controller.text = '₹${_values.start.toInt()} - ₹${_values.end.toInt()}';
              });
            },
            showTicks: true,
            showLabels: true,
            enableTooltip: true,
            numberFormat: NumberFormat.decimalPattern(),
            tooltipTextFormatterCallback: (dynamic value, String position) {
              return '₹${value.toInt()}';
            },
            activeColor: AppColors.appPrimary,
          ),
        ),
        TextField(
          controller: widget.controller,
          keyboardType: TextInputType.number,
          readOnly: true,
          decoration: InputDecoration(
            labelText: '*Expected Price',
            labelStyle: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
