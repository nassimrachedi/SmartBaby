import 'package:flutter/material.dart';
import 'package:SmartBaby/features/personalization/models/MaladieModel.dart';
import 'package:SmartBaby/utils/constants/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailsMaladie extends StatelessWidget {
  final Maladie maladie;

  const DetailsMaladie({Key? key, required this.maladie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.diseaseDetails), // Utilisation de la traduction pour le titre de l'app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${AppLocalizations.of(context)!.name}: ${maladie.nom}', // Utilisation de la traduction pour 'Nom:'
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            SizedBox(height: 16),
            Text(
              '${AppLocalizations.of(context)!.type}: ${maladie.type}', // Utilisation de la traduction pour 'Type:'
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.medications, // Utilisation de la traduction pour 'Médicaments:'
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: maladie.medicaments.length,
                itemBuilder: (context, index) {
                  final medicament = maladie.medicaments[index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: TColors.accent2,
                    child: ListTile(
                      title: Text(
                        medicament.nom,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${AppLocalizations.of(context)!.type}: ${medicament.type}', // Utilisation de la traduction pour 'Type:'
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${AppLocalizations.of(context)!.details}: ${medicament.details}', // Utilisation de la traduction pour 'Détails:'
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
