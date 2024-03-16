import 'package:SmartBaby/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../utils/constants/sizes.dart';
import 'widget/HealthDataWidget.dart'; // Import du widget HealthDataWidget
import 'widget/child_data.dart';
import 'widget/primary_header.dart';


class HomeScreen extends StatelessWidget {
  final List<Child> children = [
    Child('Child 1'),
    Child('Child 2'),
    Child('Child 3'),
    // Ajoutez d'autres enfants si nécessaire
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            primary_header(),
            SizedBox(height: 20),
            // Espacement entre primary_header() et le bouton
            Center( // Centrer horizontalement le bouton
              child: GestureDetector(
                onTap: () {
                  _showChildSelectionDialog(
                      context); // Appeler la méthode pour afficher la boîte de dialogue
                },
                child: Container(
                  width: 200,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: TColors.accent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.child_care, color: Colors.black),
                      SizedBox(width: 8.0),
                      Text(
                        'Change child',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Health Metrics',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            HealthDataWidget(
              title: 'Heart Rate',
              value: 'heartRate',
              icon: Icons.favorite,
            ),
            HealthDataWidget(
              title: 'Oxygen Level',
              value: 'oxygenLevel',
              icon: Icons.air,
            ),
            HealthDataWidget(
              title: 'Temperature',
              value: '38 °C',
              icon: Icons.thermostat_outlined,
            ),
          ],
        ),
      ),
    );
  }


  void _showChildSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Child'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: children.map((child) {
              return ListTile(
                title: Text(child.name),
                onTap: () {
                  // Ajoutez le code pour sélectionner l'enfant
                  Navigator.of(context)
                      .pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}


