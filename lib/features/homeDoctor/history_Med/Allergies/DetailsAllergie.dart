import 'package:flutter/material.dart';
import 'package:SmartBaby/features/personalization/models/AllergieModel.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart'; // Pour le formatage de la date
import '../../../personalization/models/Medicament_Model.dart';

class DetailsAllergiePage extends StatelessWidget {
  final Allergie allergie;

  const DetailsAllergiePage({Key? key, required this.allergie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Formatage de la date
    final dateFormat = DateFormat('dd MMM yyyy à HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'allergie'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.vaccines, size: 40, color: Colors.deepOrange),
              title: Text(
                allergie.nom,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              subtitle: Text(
                dateFormat.format(allergie.date),
                style: TextStyle(fontSize: 20, color: Colors.black87),
              ),
            ),
            Divider(thickness: 2),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Type d\'allergie:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
            Text(
              allergie.type,
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Médicaments associés:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
            for (var medicament in allergie.medicaments) ...[
              Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Icon(Icons.medical_services, color: Colors.blue),
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
