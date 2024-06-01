import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../controllers/children_controller.dart';
import '../../models/children_model.dart';
import 'addnew_child.dart';

class UserChildrenScreen extends StatelessWidget {
  final ChildController controller = Get.put(ChildController());

  UserChildrenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.title),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<ModelChild?>(
        future: controller.getChildForParent(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.pinkAccent,
                ),
                onPressed: () => Get.to(() => AddChildForm()),
                child: Text(AppLocalizations.of(context)!.addChild),
              ),
            );
          }

          ModelChild child = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        height: 130,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                          color: Color(0xFFabcdef),
                        ),
                      ),
                      Center(
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: controller.imageChildUploading.value ? null : () => controller.updateChildPicture(),
                              child: Container(
                                height: 80,
                                width: 80,
                                margin: EdgeInsets.only(top: 0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.blue.shade50,
                                    width: 2.0,
                                  ),
                                ),
                                child: ClipOval(
                                  child: child.childPicture != null
                                      ? Image.network(
                                    child.childPicture,
                                    fit: BoxFit.cover,
                                  )
                                      : Icon(
                                    Icons.person,
                                    size: 50,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 90,
                        left: 90,
                        child: Text(
                          '${child.firstName} ${child.lastName}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Icon(Icons.cake, color: Color(0xFFabcdef)),
                          title: Text(DateFormat('yyyy-MM-dd').format(child.birthDate)),
                          trailing: IconButton(
                            icon: Icon(Icons.edit, color: Color(0xFFabcdef)),
                            onPressed: () {
                              // Logic to edit child info
                            },
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.transgender, color: Color(0xFFabcdef)),
                          title: Text(child.gender),
                          trailing: IconButton(
                            icon: Icon(Icons.edit, color: Color(0xFFabcdef)),
                            onPressed: () {
                              // Logic to edit child info
                            },
                          ),
                        ),
                        ListTile(
                          leading: Icon(Iconsax.ruler, color: Color(0xFFabcdef)),
                          title: Text('${AppLocalizations.of(context)!.height}: ${child.taille} Cm'),
                        ),
                        ListTile(
                          leading: Icon(Iconsax.weight, color: Color(0xFFabcdef)),
                          title: Text('${AppLocalizations.of(context)!.poids}: ${child.poids} Kg'),
                        ),
                        ListTile(
                          leading: Icon(Icons.favorite_border, color: Color(0xFFabcdef)),
                          title: Text('${AppLocalizations.of(context)!.minbpm}: ${child.minBpm}'),
                        ),
                        ListTile(
                          leading: Icon(Icons.favorite, color: Color(0xFFabcdef)),
                          title: Text('${AppLocalizations.of(context)!.maxbpm}: ${child.maxBpm}'),
                        ),
                        ListTile(
                          leading: Icon(Icons.opacity, color: Color(0xFFabcdef)),
                          title: Text('${AppLocalizations.of(context)!.spo2}: ${child.spo2}%'),
                        ),
                        ListTile(
                          leading: Icon(Icons.thermostat, color: Color(0xFFabcdef)),
                          title: Text('${AppLocalizations.of(context)!.mintemp}: ${child.minTemp}°C'),
                        ),
                        ListTile(
                          leading: Icon(Icons.thermostat_outlined, color: Color(0xFFabcdef)),
                          title: Text('${AppLocalizations.of(context)!.maxtemp}: ${child.maxTemp}°C'),
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: TextButton(
                            onPressed: () => controller.deleteCurrentChild(),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.redAccent,
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
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddChildForm()),
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
    );
  }
}
