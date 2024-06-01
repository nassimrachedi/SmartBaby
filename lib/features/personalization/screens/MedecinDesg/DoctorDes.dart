import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:SmartBaby/features/personalization/controllers/DoctorAssigned_controller.dart';
import '../../controllers/Doctor_controleur.dart';
import '../../models/user_model.dart';
import 'addDoctor.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DoctorDisplayWidget extends StatelessWidget {
  final DoctorDisplayController controller = Get.put(DoctorDisplayController());
  final DoctorAssignmentController controllerDoc = Get.put(DoctorAssignmentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.medassign),
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
        } else if (controller.assignedDoctors.isNotEmpty) {
          /// Affichage des détails des médecins assignés.
          return ListView.builder(
            itemCount: controller.assignedDoctors.length,
            itemBuilder: (context, index) {
              Doctor doctor = controller.assignedDoctors[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            FutureBuilder<String?>(
                              future: controllerDoc.getDoctorProfilePicture(doctor.id),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircleAvatar(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  print('${AppLocalizations.of(context)!.error}: ${snapshot.error}');
                                  return CircleAvatar(
                                    child: Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                  );
                                } else {
                                  final profilePictureUrl = snapshot.data;
                                  return CircleAvatar(
                                    backgroundImage: profilePictureUrl != null
                                        ? NetworkImage(profilePictureUrl)
                                        : null,
                                    child: profilePictureUrl == null
                                        ? Icon(
                                      Icons.person,
                                      size: 50,
                                    )
                                        : null,
                                  );
                                }
                              },
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doctor.fullName,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    doctor.email,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Handle delete doctor
                                controller.deleteDoctor(doctor.id);
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.infosupp,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${AppLocalizations.of(context)!.phoneNo} : ${doctor.phoneNumber}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          '${AppLocalizations.of(context)!.address}: ${doctor.addresses ?? "Non disponible"}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: Text("Aucun médecin assigné."));
        }
      }),
    );
  }
}
