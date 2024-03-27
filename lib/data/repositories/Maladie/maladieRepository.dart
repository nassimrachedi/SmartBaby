import 'package:SmartBaby/features/personalization/models/MaladieModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addMaladieToFirestore(Maladie maladie) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference maladiesRef = firestore.collection('maladies');
  DocumentReference docRef = await maladiesRef.add(maladie.toMap());
  for (var medicament in maladie.medicaments) {
    await docRef.collection('medicaments').add(medicament.toMap());
  }
  print('Maladie "${maladie.nom}" ajoutée à Firestore avec succès, avec ses médicaments.');
}