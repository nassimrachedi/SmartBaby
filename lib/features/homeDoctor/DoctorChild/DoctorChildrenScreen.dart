import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/DoctorRepos/DoctorRepository.dart';
import '../../personalization/controllers/ControllerInitChildFor.dart';
import '../../personalization/models/children_model.dart';
import 'TSingleChild.dart';

class DoctorChildrenScreen extends StatelessWidget {
  final DoctorControllers doctorController = Get.find<DoctorControllers>(); // Utilisez Get.find pour récupérer le contrôleur
  final DoctorRepository doctorRepository = Get.find<DoctorRepository>(); // Utilisez Get.find pour récupérer le repository

  @override
  Widget build(BuildContext context) {
    // Cela s'assure que `currentChildId` est initialisé avant de construire le widget.
    doctorController.getCurrentChildId();

    return Scaffold(
      appBar: AppBar(title: Text('Enfants du docteur')),
      body: StreamBuilder<List<ModelChild>>(
        stream: doctorRepository.getDoctorChildren(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun enfant trouvé'));
          }
          var children = snapshot.data!;
          return ListView.builder(
            itemCount: children.length,
            itemBuilder: (context, index) {
              var child = children[index];
              return Obx(() => TSingleChild(
                childModel: child,
                isSelected: doctorController.currentChildId.value == child.idChild,
                onTap: () => {
                  // Ici, utilisez doctorController pour maintenir la cohérence de l'état
                  doctorController.currentChildId.value = child.idChild,
                  doctorRepository.selectChild(child.idChild)
                },
              ));
            },
          );
        },
      ),
    );
  }
}
