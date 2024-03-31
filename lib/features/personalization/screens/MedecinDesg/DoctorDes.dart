import 'package:SmartBaby/features/personalization/controllers/Doctor_controleur.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/DoctorAssigned_controller.dart';
import '../../models/user_model.dart';
import 'addDoctor.dart';

class DoctorDisplayWidget extends StatelessWidget {
  final DoctorDisplayController controller = Get.put(DoctorDisplayController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Médecin Assigné"),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
             Get.put(DoctorAssignmentController());
              Get.to(() => AssignDoctorForm());
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.assignedDoctor.value != null) {
          // Affichage des détails du médecin assigné.
          Doctor doctor = controller.assignedDoctor.value!;
          return ListTile(
            title: Text(doctor.fullName),
            subtitle: Text(doctor.email),
            // Ajoutez ici d'autres détails que vous souhaitez afficher.
          );
        } else {
          // Si aucun médecin n'est assigné, affichez un message.
          return Center(child: Text("Aucun médecin assigné."));
        }
      }),
    );
  }
}
