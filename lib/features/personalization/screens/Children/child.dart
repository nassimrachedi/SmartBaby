import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                          color: Color(0xFFabcdef),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        left: 20,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(''), // Assuming you have a profileImageUrl field
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                              icon: Icon(Icons.camera_alt, color: Colors.white),
                              onPressed: () {
                                // Logic to change profile image
                              },
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        left: 100,
                        child: Text(
                          child.firstName + ' ' + child.lastName,
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
                          leading: Icon(Icons.child_care, color: Color(0xFFabcdef)),
                          title: Text(child.gender),
                          trailing: IconButton(
                            icon: Icon(Icons.edit, color: Color(0xFFabcdef)),
                            onPressed: () {
                              // Logic to edit child info
                            },
                          ),
                        ),
                        // Display other attributes
                        ListTile(
                          leading: Icon(Icons.favorite, color: Color(0xFFabcdef)),
                          title: Text("Min BPM: ${child.minBpm}"),
                        ),
                        ListTile(
                          leading: Icon(Icons.favorite_border, color: Color(0xFFabcdef)),
                          title: Text("Max BPM: ${child.maxBpm}"),
                        ),
                        ListTile(
                          leading: Icon(Icons.opacity, color: Color(0xFFabcdef)),
                          title: Text("SpO2: ${child.spo2}%"),
                        ),
                        ListTile(
                          leading: Icon(Icons.thermostat, color: Color(0xFFabcdef)),
                          title: Text("Min Temp: ${child.minTemp}°C"),
                        ),
                        ListTile(
                          leading: Icon(Icons.thermostat_outlined, color: Color(0xFFabcdef)),
                          title: Text("Max Temp: ${child.maxTemp}°C"),
                        ),
                        // Add more ListTiles for other attributes if needed
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
