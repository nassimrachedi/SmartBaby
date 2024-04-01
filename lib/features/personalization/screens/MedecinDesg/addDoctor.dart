import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/Doctor_controleur.dart';
import '../../models/user_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AssignDoctorForm extends StatelessWidget {
  final DoctorAssignmentController controller = Get.put(DoctorAssignmentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.assignDoctorTitle),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controller.emailController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.doctorEmailLabel,
                hintText: AppLocalizations.of(context)!.enterDoctorEmailHint,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.assignDoctor,
              child: Text(AppLocalizations.of(context)!.assignDoctorButton),
            ),
            SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.assignedDoctorsLabel,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return FutureBuilder<List<UserModel>>(
                    future: controller.getAssignedDoctors(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (snapshot.hasError || !snapshot.hasData) {
                          return Center(
                            child: Text(AppLocalizations.of(context)!.noAssignedDoctors),
                          );
                        } else {
                          List<UserModel> assignedDoctors = snapshot.data!;
                          return ListView.builder(
                            itemCount: assignedDoctors.length,
                            itemBuilder: (context, index) {
                              UserModel doctor = assignedDoctors[index];
                              return ListTile(
                                title: Text(doctor.fullName),
                                subtitle: Text(doctor.email),
                              );
                            },
                          );
                        }
                      }
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
