import 'package:SmartBaby/features/homeDoctor/profilWidget/Child/Adjustvalue.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../data/repositories/child/child_repository.dart';
import '../../../personalization/controllers/Doctor-controleur.dart';
import '../../../personalization/controllers/update_value.dart';
import '../../../personalization/models/children_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class DoctorChildScreen extends GetView<DoctorController> {
  @override
  Widget build(BuildContext context) {
    // Vous n'avez pas besoin de mettre le contrôleur ici, Get le gère automatiquement
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.enfantAssigneAuMedecin)),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.child.value == null) {
          return Center(child: Text(AppLocalizations.of(context)!.aucuneDonneeAAfficher));
        } else {
          return ChildDetailsForm(child: controller.child.value!, controller: controller,);
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
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${AppLocalizations.of(context)!.name}: ${child.lastName}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,

              ),
            ),
            SizedBox(height: 8),
            Text(
              '${AppLocalizations.of(context)!.prenom}: ${child.firstName}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${AppLocalizations.of(context)!.birthDateLabel}: ${DateFormat('dd/MM/yyyy').format(child.birthDate)}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black45,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${AppLocalizations.of(context)!.genre}: ${child.gender}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black45,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${AppLocalizations.of(context)!.minbpm}: ${child.minBpm}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black45,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${AppLocalizations.of(context)!.maxbpm}: ${child.maxBpm}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black45,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${AppLocalizations.of(context)!.minTemp}: ${child.minTemp}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black45,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${AppLocalizations.of(context)!.maxtemp}: ${child.maxTemp}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black45,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${AppLocalizations.of(context)!.spO2}: ${child.spo2}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black45,
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {

                  Get.put(UpdateVitalSignsController(repository: Get.find<ChildRepository>()));
                  Get.to(() => AdjustValuesScreen());
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  minimumSize: Size(double.infinity, 36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.ajuster,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => controller.deleteCurrentDoctorChild(),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.redAccent,
                  minimumSize: Size(double.infinity, 36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.delete,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
