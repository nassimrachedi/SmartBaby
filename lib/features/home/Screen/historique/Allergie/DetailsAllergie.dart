import 'package:SmartBaby/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:SmartBaby/features/personalization/models/AllergieModel.dart';

class DetailsAllergie extends StatelessWidget {
  final Allergie allergie;

  const DetailsAllergie({Key? key, required this.allergie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.allergyDetailsTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${AppLocalizations.of(context)!.nameLabel} ${allergie.nom}',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            SizedBox(height: 16),
            Text(
              '${AppLocalizations.of(context)!.typeLabel} ${allergie.type}',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            SizedBox(height: 24),
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
