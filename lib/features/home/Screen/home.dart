import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'widget/HealthDataWidget.dart'; // Import du widget HealthDataWidget
import 'widget/primary_header.dart';


class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            primary_header(),
            SizedBox(height: 20),
            // Espacement entre primary_header() et le bouton
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
}