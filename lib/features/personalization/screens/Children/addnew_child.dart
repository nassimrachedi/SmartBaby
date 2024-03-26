import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/children_controller.dart';

class AddChildForm extends StatelessWidget {
  final ChildController controller = Get.put(ChildController(parentId: '')); // Assurez-vous de lier le contrôleur dans votre page

  AddChildForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajouter Enfant')),
      body: SingleChildScrollView(
        child: Form(
          key: controller.childFormKey,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: controller.firstNameController,
                  decoration: InputDecoration(labelText: 'Prénom'),
                  validator: (value) => value!.isEmpty ? 'Le prénom est obligatoire.' : null,
                ),
                TextFormField(
                  controller: controller.lastNameController,
                  decoration: InputDecoration(labelText: 'Nom'),
                  validator: (value) => value!.isEmpty ? 'Le nom est obligatoire.' : null,
                ),
                TextFormField(
                  controller: controller.birthDateController,
                  decoration: InputDecoration(labelText: 'Date de Naissance (YYYY-MM-DD)'),
                  validator: (value) => value!.isEmpty ? 'La date de naissance est obligatoire.' : null,
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
                      child: Text(value == 'boy' ? 'Garçon' : 'Fille'),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    controller.selectedGender.value = newValue!;
                  },
                )),
                ElevatedButton(
                  onPressed: controller.addChild,
                  child: Text('Enregistrer Enfant'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}