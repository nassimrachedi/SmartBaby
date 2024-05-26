import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'package:SmartBaby/features/personalization/models/MaladieModel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailsMaladiePage extends StatelessWidget {
  final Maladie maladie;

  const DetailsMaladiePage({Key? key, required this.maladie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy à HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.diseaseDetails),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: dateFormat.format(maladie.date),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                          decorationColor: Colors.deepPurple,
                          decorationStyle: TextDecorationStyle.dotted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 0),
                        leading: Icon(Icons.coronavirus_outlined, size: 40, color: Colors.blue),
                        title: Text(
                          ' ${maladie.nom}',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        subtitle: Text(
                          '${AppLocalizations.of(context)!.type}: ${maladie.type}',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          AppLocalizations.of(context)!.medications,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ),
                      SizedBox(height: 8),
                      for (var medicament in maladie.medicaments) ...[
                        Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          color: Colors.green.shade50,
                          child: ListTile(
                            leading: Image.asset(
                              'assets/logos/med.png',
                              width: 40,
                              height: 40,
                            ),
                            title: Text(
                              medicament.nom,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${AppLocalizations.of(context)!.type}: ${medicament.type}',
                                  style: TextStyle(fontSize: 16, color: Colors.black87),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${AppLocalizations.of(context)!.details}: ${medicament.details}',
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
