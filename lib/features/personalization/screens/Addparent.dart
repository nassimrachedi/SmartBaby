import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ParentControlleur.dart'; // Create this controller
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AssignParentForm extends StatelessWidget {
  final ParentAssignmentController controller = Get.put(ParentAssignmentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.assignsecondparent,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/application/parents.png', // Add an appropriate image
                  height: 100,
                ),
                SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!.assignsecondparent,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: controller.emailController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.parentemail,
                hintText: AppLocalizations.of(context)!.enterparentemail,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(Icons.email, color: Colors.blueAccent),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.assignParent,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.save,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
