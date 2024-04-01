import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'widgets/HealthDataWidgetMed.dart';
import 'widgets/primary_header_med.dart';

class HomeScreenMed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            primary_header_Med(),
            SizedBox(height: 20),
            // Espacement entre PrimaryHeaderMed() et le bouton
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.healthMetrics,
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
            HealthDataWidgetMed(
              title: AppLocalizations.of(context)!.heartRate,
              value: 'heartRate',
              icon: Icons.favorite,
            ),
            HealthDataWidgetMed(
              title: AppLocalizations.of(context)!.oxygenLevel,
              value: 'oxygenLevel',
              icon: Icons.air,
            ),
            HealthDataWidgetMed(
              title: AppLocalizations.of(context)!.temperature,
              value: '38 °C',
              icon: Icons.thermostat_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
