import 'package:SmartBaby/features/personalization/models/AllergieModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



Future<void> addAllergieToFirestore(Allergie allergie) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference allergiesRef = firestore.collection('allergies');
  DocumentReference docRef = await allergiesRef.add(allergie.toMap());
  for (var medicament in allergie.medicaments) {
    await docRef.collection('allergies').add(medicament.toMap());
  }
  print('Maladie "${allergie.nom}" ajoutée à Firestore avec succès, avec ses médicaments.');
}
