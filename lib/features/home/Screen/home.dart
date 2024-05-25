import 'package:SmartBaby/features/home/Screen/widget/SignesVitaux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'widget/primary_header.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            PrimaryHeader(),
            SizedBox(height: 0),
            // Espacement entre primary_header() et le bouton
            SizedBox(height: 0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.healthMetrics,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  HomePageV(), 
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
