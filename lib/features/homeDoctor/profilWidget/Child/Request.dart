import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../personalization/controllers/AssignementRequest_Controlleur.dart';

class AssignmentRequestsScreen extends GetView<AssignmentRequestController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Demandes d\'Assignation')),
      body: Obx(() {
        if (controller.pendingRequests.isEmpty) {
          return Center(child: Text("Aucune demande d'assignation en attente."));
        } else {
          return ListView.builder(
            itemCount: controller.pendingRequests.length,
            itemBuilder: (context, index) {
              final request = controller.pendingRequests[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    'Enfant ID: ${request.childId}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Demande envoyée par: ${request.EmailParent}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () => controller.acceptAssignment(request.id),
                        child: Text('Accepter'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => controller.rejectAssignment(request.id),
                        child: Text('Refuser'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
