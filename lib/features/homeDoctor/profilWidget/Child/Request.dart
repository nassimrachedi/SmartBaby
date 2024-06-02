import 'package:SmartBaby/features/personalization/models/children_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../../personalization/controllers/AssignementRequest_Controlleur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AssignmentRequestsScreen extends GetView<AssignmentRequestController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.dmsassign)),
      body: Obx(() {
        if (controller.pendingRequests.isEmpty) {
          return Center(child: Text(AppLocalizations.of(context)!.norequest));
        } else {
          return ListView.builder(
            itemCount: controller.pendingRequests.length,
            itemBuilder: (context, index) {
              final request = controller.pendingRequests[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<ModelChild>(
                        future: _getChildData(request.childId), // Récupérer les données de l'enfant
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator()); // Afficher un indicateur de chargement en attendant les données
                          }
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          if (snapshot.hasData) {
                            final childData = snapshot.data!;
                            print("URL de l'image: ${childData.childPicture}");
                            return Row(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage: CachedNetworkImageProvider(childData.childPicture),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${childData.firstName} ${childData.lastName}',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '${AppLocalizations.of(context)!.birthDateLabel}: ${DateFormat('yyyy-MM-dd').format(childData.birthDate)}',
                                        style: TextStyle(color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                          return SizedBox.shrink(); // Si les données de l'enfant ne sont pas disponibles, retourner un widget vide
                        },
                      ),
                      SizedBox(height: 16),
                      Text('${AppLocalizations.of(context)!.demenv}: ${request.EmailParent}'),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => controller.acceptAssignment(request.id),
                            child: Text(AppLocalizations.of(context)!.accep),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => controller.rejectAssignment(request.id),
                            child: Text(AppLocalizations.of(context)!.refuse),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                          ),
                        ],
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

  Future<ModelChild> _getChildData(String childId) async {
    final snapshot = await FirebaseFirestore.instance.collection('Children').doc(childId).get();
    return ModelChild.fromSnapshot(snapshot);
  }
}
