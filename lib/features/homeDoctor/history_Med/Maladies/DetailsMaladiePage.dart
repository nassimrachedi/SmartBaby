import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'package:SmartBaby/features/personalization/models/MaladieModel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailsMaladiePage extends StatelessWidget {
  final Maladie maladie;

  const DetailsMaladiePage({Key? key, required this.maladie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Formatter for dates
    final dateFormat = DateFormat('dd MMM yyyy à HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.diseaseDetails),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.coronavirus_outlined, size: 40, color: Colors.deepPurple),
              title: Text(
                maladie.nom,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              subtitle: Text(
                maladie.type,
                style: TextStyle(fontSize: 20, color: Colors.black87),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Date: ${dateFormat.format(maladie.date)}',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
            ),
            Divider(thickness: 2),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Médicaments:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
            for (var medicament in maladie.medicaments) ...[
              Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Icon(Icons.medication, color: Colors.blue),
                  title: Text(
                    medicament.nom,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Type: ${medicament.type}',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Détails: ${medicament.details}',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
