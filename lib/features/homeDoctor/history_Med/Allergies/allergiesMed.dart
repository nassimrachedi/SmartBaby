import 'package:flutter/material.dart';
import 'package:SmartBaby/features/personalization/models/AllergieModel.dart';
import '../../../../data/repositories/allergieRep/allergieRepository.dart';
import 'AjouterAllergie.dart';
import 'DetailsAllergie.dart';

class ListAllergiesWidget extends StatelessWidget {
  final ChildAllergieRepository allergieRepository = ChildAllergieRepository();

  @override
  Widget build(BuildContext context) {
    Color softPurple = Color(0xFFB39DDB);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Liste des Allergies',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(color: softPurple, height: 1.0),
        ),
      ),
      body: StreamBuilder<List<Allergie>>(
        stream: allergieRepository.streamAllergie(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune allergie trouvée'));
          }

          List<Allergie> allergies = snapshot.data!;
          return ListView.builder(
            itemCount: allergies.length,
            itemBuilder: (context, index) {
              Allergie allergie = allergies[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: softPurple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: softPurple.withOpacity(0.5)),
                ),
                child: ListTile(
                  title: Text(
                    allergie.nom,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    'Type: ${allergie.type}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: softPurple),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailsAllergiePage(allergie: allergie)),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newAllergie = await Navigator.push<Allergie?>(
            context,
            MaterialPageRoute(builder: (context) => AjouterAllergie()),
          );


        },
        icon: Icon(Icons.add),
        label: Text('Ajouter Allergie'),
        backgroundColor: softPurple,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
