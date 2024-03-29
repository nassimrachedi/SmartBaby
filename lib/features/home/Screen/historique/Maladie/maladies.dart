import 'package:SmartBaby/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SmartBaby/features/personalization/models/MaladieModel.dart';
import '../../../../../data/repositories/Maladie/maladieRepository.dart';
import 'DetailsMaladies.dart';

class Maladies extends StatelessWidget {
  final ChildMaladieRepository maladiesRepository = ChildMaladieRepository();

  @override
  Widget build(BuildContext context) {
    // Defining the color scheme
    Color softPurple = Color(0xFFB39DDB);
    Color darkerPurple = softPurple.withOpacity(0.5);
    Color background = Colors.grey[100]!;

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
          'Liste des Maladies',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        // Removing elevation for a flatter design
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: background,
        child: StreamBuilder<List<Maladie>>(
          stream: maladiesRepository.streamMaladiesPrents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Erreur de chargement: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Aucune maladie trouvée'));
            } else {
              List<Maladie> maladies = snapshot.data!;
              return ListView.builder(
                itemCount: maladies.length,
                itemBuilder: (context, index) {
                  Maladie maladie = maladies[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 2, // Adding elevation for depth
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(maladie.nom, style: cardStyle),
                      subtitle: Text('Type: ${maladie.type}',
                          style: subtitleStyle),
                      trailing: Icon(Icons.arrow_forward_ios,
                          color: darkerPurple),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              DetailsMaladie(maladie: maladie)),
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
