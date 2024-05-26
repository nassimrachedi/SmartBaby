import 'package:SmartBaby/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:SmartBaby/features/personalization/models/AllergieModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../data/repositories/allergieRep/allergieRepository.dart';
import 'DetailsAllergie.dart';

class Allergies extends StatelessWidget {
  final ChildAllergieRepository allergieRepository = ChildAllergieRepository();

  @override
  Widget build(BuildContext context) {
    Color background =Colors.white;

    // Styling for the cards
    var cardStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    );

    // Styling for subtitles
    var subtitleStyle = TextStyle(
      color: Colors.grey[600],
      fontSize: 16,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${AppLocalizations.of(context)!.allergies_title}',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Container(
        color: background,
        child: StreamBuilder<List<Allergie>>(
          stream: allergieRepository.streamAllergieParents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('${AppLocalizations.of(context)!.loadingError}: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text(AppLocalizations.of(context)!.noDiseaseFound));
            } else {
              List<Allergie> allergies = snapshot.data!;
              return ListView.builder(
                itemCount: allergies.length,
                itemBuilder: (context, index) {
                  Allergie allergie = allergies[index];
                  return Card(
                    color: Colors.blue.shade50,
                    margin: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    elevation: 2, // Adding elevation for depth
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.coronavirus_outlined, size: 50, color: Colors.blue.shade800),
                      title: Text(allergie.nom, style: cardStyle),
                      subtitle: Text(' ${AppLocalizations.of(context)!.type}: ${allergie.type}',
                          style: subtitleStyle),
                      trailing: Icon(Icons.arrow_forward_ios,
                          color: Colors.black),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              DetailsAllergie(allergie: allergie)),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
