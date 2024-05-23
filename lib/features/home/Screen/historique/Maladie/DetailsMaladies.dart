import 'package:flutter/material.dart';
import 'package:SmartBaby/features/personalization/models/MaladieModel.dart';
import 'package:SmartBaby/utils/constants/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class DetailsMaladie extends StatelessWidget {
  final Maladie maladie;

  const DetailsMaladie({Key? key, required this.maladie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.diseaseDetails),
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () => _printPrescription(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${AppLocalizations.of(context)!.name}: ${maladie.nom}',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            SizedBox(height: 16),
            Text(
              '${AppLocalizations.of(context)!.type}: ${maladie.type}',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.medications,
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _printPrescription(BuildContext context) {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            padding: pw.EdgeInsets.all(16),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Établissement Public de Santé a distance ', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    pw.Text('ORDONNANCE', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.SizedBox(height: 8),
                pw.Text('Dr. ATIF', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.Text('Médecin Généraliste', style: pw.TextStyle(fontSize: 14)),
                pw.Divider(),
                pw.SizedBox(height: 8),
                pw.Text('Nom du malade: Nassim Rachedi', style: pw.TextStyle(fontSize: 14)),
                pw.Text('Âge: 21', style: pw.TextStyle(fontSize: 14)),
                pw.Text('Adresse: USTHB', style: pw.TextStyle(fontSize: 14)),
                pw.Text('Sexe: Masculin', style: pw.TextStyle(fontSize: 14)),
                pw.SizedBox(height: 16),
                pw.Text('Médicaments prescrits:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 8),
                ...maladie.medicaments.map((medicament) {
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(medicament.nom, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                      pw.Text('Type: ${medicament.type}', style: pw.TextStyle(fontSize: 14)),
                      pw.Text('Détails: ${medicament.details}', style: pw.TextStyle(fontSize: 14)),
                      pw.SizedBox(height: 12),
                    ],
                  );
                }).toList(),
                pw.SizedBox(height: 16),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Signature du médecin', style: pw.TextStyle(fontSize: 14)),
                    pw.Container(
                      width: 100,
                      height: 50,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.Center(
                        child: pw.Text('Dr. ATIF', style: pw.TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
