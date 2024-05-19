import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/children_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddChildForm extends StatelessWidget {
  final ChildController controller = Get.put(ChildController());

  AddChildForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addChildTitle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: controller.childFormKey,
                child: Column(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.addChildTitle,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: controller.firstNameController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.firstNameLabel,
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) => value!.isEmpty
                          ? AppLocalizations.of(context)!.firstNameError
                          : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: controller.lastNameController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.lastNameLabel,
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) => value!.isEmpty
                          ? AppLocalizations.of(context)!.lastNameError
                          : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: controller.birthDateController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.birthDateLabel,
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      validator: (value) => value!.isEmpty
                          ? AppLocalizations.of(context)!.birthDateError
                          : null,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          controller.birthDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    Obx(
                          () => DropdownButtonFormField<String>(
                        value: controller.selectedGender.value,
                        items: <String>['boy', 'girl']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value == 'boy'
                                ? AppLocalizations.of(context)!.male
                                : AppLocalizations.of(context)!.female),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          controller.selectedGender.value = newValue!;
                        },
                        decoration: InputDecoration(
                          labelText: '',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.wc),
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: controller.addChild,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24), backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.saveChild,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
