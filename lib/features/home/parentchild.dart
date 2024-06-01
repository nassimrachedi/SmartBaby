import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/ParentRepository/ParentRepository.dart';
import '../homeDoctor/DoctorChild/TSingleChild.dart';
import '../personalization/controllers/parentcontroleur.dart';
import '../personalization/models/children_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ParentChildrenScreen extends StatelessWidget {
  final ParentController parentController = Get.find<ParentController>(); // Utilisez Get.find pour récupérer le contrôleur
  final ParentRepository parentRepository = Get.find<ParentRepository>(); // Utilisez Get.find pour récupérer le repository

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.enfantChoisi)),
      body: StreamBuilder<List<ModelChild>>(
        stream: parentRepository.getChildrenForParent(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)!.no_child_assigned_to_this_user));
          }
          var children = snapshot.data!;
          return ListView.builder(
            itemCount: children.length,
            itemBuilder: (context, index) {
              var child = children[index];
              return Obx(() => TSingleChild(
                childModel: child,
                isSelected: parentController.currentChildId.value == child.idChild,
                onTap: () => parentController.selectChild(child.idChild),
              ));
            },
          );
        },
      ),
    );
  }
}
