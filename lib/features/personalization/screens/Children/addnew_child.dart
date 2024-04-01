import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/children_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Importez la classe de localisation

class AddChildForm extends StatelessWidget {
  final ChildController controller = Get.put(ChildController());

  AddChildForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.addChildTitle)), // Utilisez la traduction pour le titre de l'appbar
      body: SingleChildScrollView(
        child: Form(
          key: controller.childFormKey,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: controller.firstNameController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.firstNameLabel), // Utilisez la traduction pour le label
                  validator: (value) => value!.isEmpty ? AppLocalizations.of(context)!.firstNameError : null, // Utilisez la traduction pour le message d'erreur
                ),
                TextFormField(
                  controller: controller.lastNameController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.lastNameLabel), // Utilisez la traduction pour le label
                  validator: (value) => value!.isEmpty ? AppLocalizations.of(context)!.lastNameError : null, // Utilisez la traduction pour le message d'erreur
                ),
                TextFormField(
                  controller: controller.birthDateController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.birthDateLabel), // Utilisez la traduction pour le label
                  validator: (value) => value!.isEmpty ? AppLocalizations.of(context)!.birthDateError : null, // Utilisez la traduction pour le message d'erreur
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
                Obx(() => DropdownButton<String>(
                  value: controller.selectedGender.value,
                  items: <String>['boy', 'girl']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value == 'boy' ? AppLocalizations.of(context)!.male : AppLocalizations.of(context)!.female), // Utilisez la traduction pour les options
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    controller.selectedGender.value = newValue!;
                  },
                )),
                ElevatedButton(
                  onPressed: controller.addChild,
                  child: Text(AppLocalizations.of(context)!.saveChild), // Utilisez la traduction pour le bouton
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
