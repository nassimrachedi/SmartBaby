import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/children_controller.dart';
import '../../models/children_model.dart';
import 'addnew_child.dart';

class UserChildrenScreen extends StatelessWidget {
  final ChildController controller = Get.put(ChildController()); // Utilisez l'ID réel du parent

  UserChildrenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mes Enfants')),
      body: FutureBuilder<ModelChild?>(
        future: controller.getChildForParent(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: ElevatedButton(
                onPressed: () => Get.to(() => AddChildForm()),
                child: Text('Ajouter Enfant'),
              ),
            );
          }

          ModelChild child = snapshot.data!;
          return ListTile(
            title: Text(child.firstName + ' ' + child.lastName),
            subtitle: Text('Date de Naissance: ${DateFormat('yyyy-MM-dd').format(child.birthDate)}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddChildForm()),
        child: Icon(Icons.add),
      ),
    );
  }
}
