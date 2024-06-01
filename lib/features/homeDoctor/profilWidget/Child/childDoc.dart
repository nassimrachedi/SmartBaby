import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../data/repositories/child/child_repository.dart';
import '../../../personalization/controllers/Doctor-controleur.dart';
import '../../../personalization/controllers/update_value.dart';
import '../../../personalization/models/children_model.dart';
import 'Adjustvalue.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DoctorChildScreen extends GetView<DoctorController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.childAssigned),
      ),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return Center(child: CircularProgressIndicator());
        }
        var child = controller.currentChild.value;
        if (child == null) {
          return Center(child: Text('no data found '));
        } else {
          return SingleChildScrollView( // Pour gérer le scroll si contenu trop long
            child: ChildDetailsForm(child: child, controller: controller),
          );
        }
      }),
    );
  }
}

class ChildDetailsForm extends StatelessWidget {
  final ModelChild child;
  final DoctorController controller;

  ChildDetailsForm({required this.child, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children:  <Widget>[
            Stack(
              children: [
                Container(
                  height: 115,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                    color: Color(0xFFabcdef),
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        margin: EdgeInsets.only(top: 3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blue.shade50,
                            width: 2.0,
                          ),
                        ),
                        child: ClipOval(
                          child: child.childPicture != null
                              ? Image.network(
                            child.childPicture,
                            fit: BoxFit.cover,
                          )
                              : Icon(
                            Icons.person,
                            size: 50,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 90,
                  child: Text(
                    '${child.firstName} ${child.lastName}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.cake, color: Color(0xFFabcdef)),
              title: Text(DateFormat('yyyy-MM-dd').format(child.birthDate)),
            ),
            ListTile(
              leading: Icon(Icons.transgender, color: Color(0xFFabcdef)),
              title: Text(child.gender),
            ),
            ListTile(
              leading: Icon(Iconsax.ruler, color: Color(0xFFabcdef)),
              title: Text('${AppLocalizations.of(context)!.height}: ${child.taille} Cm'),
            ),
            ListTile(
              leading: Icon(Iconsax.weight, color: Color(0xFFabcdef)),
              title: Text('${AppLocalizations.of(context)!.poids}: ${child.poids} Kg'),
            ),
            ListTile(
                leading :Icon(Icons.favorite_border, color: Color(0xFFabcdef)),
                title: Text('${AppLocalizations.of(context)!.minbpm}: ${child.minBpm} '),
            ),
            ListTile(
              leading :Icon(Icons.favorite, color: Color(0xFFabcdef)),
              title: Text('${AppLocalizations.of(context)!.maxbpm}: ${child.maxBpm}'),
            ),
            ListTile(
              leading :Icon(Icons.thermostat, color: Color(0xFFabcdef)),
              title: Text('${AppLocalizations.of(context)!.mintemp }: ${child.minTemp}'),
            ),
            ListTile(
              leading :Icon(Iconsax.ruler, color: Color(0xFFabcdef)),
              title: Text('${AppLocalizations.of(context)!.maxtemp}: ${child.maxTemp}'),
            ),
            ListTile(
              leading :Icon(Icons.opacity, color: Color(0xFFabcdef)),
              title: Text('${AppLocalizations.of(context)!.spo2}: ${child.spo2}'),
            ),
            buildActionButton(
              AppLocalizations.of(context)!.ajuster, Colors.blueAccent,() {
                    Get.put(UpdateVitalSignsController(repository: Get.find<ChildRepository>()));
                    Get.to(() => AdjustValuesScreen());
                  },
            ),
            SizedBox(height: 15,),
            buildActionButton(AppLocalizations.of(context)!.delete, Colors.redAccent, controller.deleteCurrentDoctorChild),
           ],
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
          SizedBox(width: 10),
          Expanded(child: Text(value, style: TextStyle(fontSize: 16, color: Colors.grey[600]))),
        ],
      ),
    );
  }

  Widget buildActionButton(String text, Color color, VoidCallback onPressed) {
    return Center(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: color, // Text color
          minimumSize: Size(200, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
