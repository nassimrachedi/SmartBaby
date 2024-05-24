import 'package:SmartBaby/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:SmartBaby/features/personalization/models/AllergieModel.dart';
import 'package:intl/intl.dart';

class DetailsAllergie extends StatelessWidget {
  final Allergie allergie;

  const DetailsAllergie({Key? key, required this.allergie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy à HH:mm');
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.allergyDetailsTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.vaccines, size: 40, color: Colors.deepOrange),
              title: Text(
                '${AppLocalizations.of(context)!.nameLabel} ${allergie.nom}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              subtitle: Text(
              '${AppLocalizations.of(context)!.typeLabel} ${allergie.type}',
              style: TextStyle(fontSize: 18, color: Colors.black87),
                 ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Date: ',
                      style: TextStyle(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: dateFormat.format(allergie.date),
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Text(
              AppLocalizations.of(context)!.medicationLabel,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: allergie.medicaments.length,
                itemBuilder: (context, index) {
                  final medicament = allergie.medicaments[index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: TColors.accent2,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        medicament.nom,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            '${AppLocalizations.of(context)!.medicationTypeLabel} ${medicament.type}',
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${AppLocalizations.of(context)!.medicationDetailsLabel} ${medicament.details}',
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
