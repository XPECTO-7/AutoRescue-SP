import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/Colors/appcolor.dart';
import 'package:provider/Pages/Components/label_textfield.dart';

class AddServicePage extends StatefulWidget {
  const AddServicePage({Key? key}) : super(key: key);

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  TextEditingController serviceTypeController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.OxfordBlue,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: AppColors.OxfordBlue,
        centerTitle: true,
        title: const Text(
          'Service',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              const SizedBox(height: 10),
              LabelTextField(
                controller: companyNameController,
                hintText: 'Company Name',
                iconData: Icons.business_sharp,
                labelText: 'Company Name',
              ),
              const SizedBox(height: 20),
              DropdownSearch<String>(
                popupProps: PopupProps.menu(
                  showSelectedItems: true,
                  disabledItemFn: (String s) => s.startsWith('I'),
                ),
                items: [
                  "Fuel Delivery Service",
                  "Tyre Related Service",
                  "Vehicle Engine Related Service",
                  'Towing Service',
                  'EV Charging service'
                ],
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    labelText: "Select Service",
                  ),
                ),
                onChanged: print,
                selectedItem: "Fuel Delivery Service",
              )
            ],
          ),
        ),
      ),
    );
  }
}
