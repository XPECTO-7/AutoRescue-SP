// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:provider/Colors/appcolor.dart';

class AddServicePage extends StatefulWidget {
  const AddServicePage({super.key});

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.OxfordBlue,
      appBar: AppBar(
        backgroundColor: AppColors.OxfordBlue,
        centerTitle: true,
        title: const Text('Service',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            )),
      ),
    );
  }
}
