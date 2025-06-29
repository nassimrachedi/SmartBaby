import 'package:SmartBaby/features/homeDoctor/widgets/SignesVitauxMed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'widgets/HealthDataWidgetMed.dart';
import 'widgets/primary_header_med.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreenMed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 280,
                width: 400,
                child: primary_header_Med()),
            SizedBox(height: 45),
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
            HomePageMed(),
          ],
        ),
      ),
    );
  }
}
