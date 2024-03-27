import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/Doctor_controleur.dart';


class AssignDoctorForm extends StatelessWidget {
  final DoctorAssignmentController controller = Get.put(DoctorAssignmentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assigner un Médecin"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller.emailController,
              decoration: InputDecoration(
                labelText: 'Email du Médecin',
                hintText: 'Entrez l\'email du médecin',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            Obx(() {
              return controller.isLoading.value
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: controller.assignDoctor,
                child: Text('Assigner le Médecin'),
              );
            }),
          ],
        ),
      ),
    );
  }
}