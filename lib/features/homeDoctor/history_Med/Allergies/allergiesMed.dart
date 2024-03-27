import 'package:flutter/material.dart';
import 'package:SmartBaby/features/personalization/models/AllergieModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'AjouterAllergie.dart';
import 'DetailsAllergie.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ListAllergies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Allergies'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('allergies').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement'));
          } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucune allergie trouvée'));
          } else {
            List<Allergie> allergies = snapshot.data!.docs.map((doc) => Allergie.fromMap(doc.data() as Map<String, dynamic>)).toList();
            return ListView.builder(
              itemCount: allergies.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(
                      allergies[index].nom,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DetailsAllergiePage(allergie: allergies[index])),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AjouterAllergie()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

