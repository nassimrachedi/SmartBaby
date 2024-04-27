import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../data/repositories/child/child_repository.dart';
import '../../../personalization/controllers/Doctor-controleur.dart';
import '../../../personalization/controllers/update_value.dart';
import '../../../personalization/models/children_model.dart';
import 'Adjustvalue.dart';

class DoctorChildScreen extends GetView<DoctorController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enfant Assigné au Médecin'),
      ),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return Center(child: CircularProgressIndicator());
        }
        var child = controller.currentChild.value;
        if (child == null) {
          return Center(child: Text("Aucune donnée à afficher"));
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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Plus arrondi
      ),
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildDetailRow('Nom:', child.lastName),
            buildDetailRow('Prénom:', child.firstName),
            buildDetailRow('Date de naissance:', DateFormat('dd/MM/yyyy').format(child.birthDate)),
            buildDetailRow('Genre:', child.gender),
            buildDetailRow('Min BPM:', child.minBpm.toString()),
            buildDetailRow('Max BPM:', child.maxBpm.toString()),
            buildDetailRow('Min Temp:', child.minTemp.toString()),
            buildDetailRow('Max Temp:', child.maxTemp.toString()),
            buildDetailRow('SpO2:', child.spo2.toString()),
            SizedBox(height: 24),
            buildActionButton('Ajuster', Colors.blueAccent, () {
              Get.put(UpdateVitalSignsController(repository: Get.find<ChildRepository>()));
              Get.to(() => AdjustValuesScreen());
            }),
            SizedBox(height: 12),
            buildActionButton('Supprimer', Colors.redAccent, controller.deleteCurrentDoctorChild)
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
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
