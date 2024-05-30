import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart'; // Package Iconsax pour les icônes personnalisées
import '../../controllers/children_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Importez la classe de localisation

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
        child: Container(
          padding: const EdgeInsets.all(16.0), // Padding autour du contenu
          child: Form(
            key: controller.childFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Photo au milieu
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/application/BoyI.webp'), // Chemin de l'image
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: controller.imageChildUploading.value? () {} : () => controller.uploadChildPicture(),
                        child: Column(

                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 10,
                    left: 100,
                    child: Center(child: Text('Photo', style: TextStyle( fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,),),)
                ),
                SizedBox(height: 16.0), // Espacement entre la photo et le premier champ
                TextFormField(
                  controller: controller.firstNameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.firstNameLabel,
                    prefixIcon: Icon(Iconsax.user),
                    border: OutlineInputBorder(), // Bordure de l'input
                  ),
                  validator: (value) => value!.isEmpty ? AppLocalizations.of(context)!.firstNameError : null,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: controller.lastNameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.lastNameLabel,
                    prefixIcon: Icon(Iconsax.user_square),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? AppLocalizations.of(context)!.lastNameError : null,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: controller.tailleController,
                  decoration: InputDecoration(
                    labelText: "taille",
                    prefixIcon: Icon(Iconsax.ruler),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? AppLocalizations.of(context)!.lastNameError : null,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: controller.poidsController,
                  decoration: InputDecoration(
                    labelText: "poids",
                    prefixIcon: Icon(Iconsax.weight),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? AppLocalizations.of(context)!.lastNameError : null,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: controller.birthDateController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.birthDateLabel,
                    prefixIcon: Icon(Iconsax.calendar),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? AppLocalizations.of(context)!.birthDateError : null,
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
                SizedBox(height: 16.0),
                Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedGender.value,
                  decoration: InputDecoration(
                    labelText: "Genre", // Label pour le Dropdown
                    prefixIcon: Icon(Icons.transgender),
                    border: OutlineInputBorder(),
                  ),
                  items: <String>['boy', 'girl']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value == 'boy' ? 'Garçon': 'Girl'),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    controller.selectedGender.value = newValue!;
                  },
                )),
                SizedBox(height: 32.0), // Espacement avant le bouton
                SizedBox(
                  width: double.infinity, // Largeur du bouton étendue sur toute la largeur disponible
                  child: ElevatedButton(
                    onPressed: controller.addChild,
                    child: Text(AppLocalizations.of(context)!.saveChild),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // Couleur de fond du bouton
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15), // Taille du bouton
                      textStyle: TextStyle(
                        fontSize: 18, // Taille du texte
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
