import 'package:SmartBaby/features/personalization/models/MaladieModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../authentication/authentication_repository.dart';

  Future<void> addMaladieToFirestore(Maladie maladie) async {

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference maladiesRef = firestore.collection('maladies');
    DocumentReference docRef = await maladiesRef.add(maladie.toMap());
    for (var medicament in maladie.medicaments) {
      await docRef.collection('medicaments').add(medicament.toMap());
    }
    print('Maladie "${maladie
        .nom}" ajoutée à Firestore avec succès, avec ses médicaments.');
  }


  /*
  import 'package:SmartBaby/features/personalization/models/MaladieModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../authentication/authentication_repository.dart';
class ChildMaladie{
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  Future<void> addMaladieToFirestore(Maladie maladie) async {
    String DoctorId= AuthenticationRepository.instance.getUserID;
    DocumentSnapshot<Map<String, dynamic>> parentSnapshot = await _db.collection('Doctors').doc(DoctorId).get();
    String? childId = parentSnapshot.data()?['childId'];

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference maladiesRef = firestore.collection('maladies');
    DocumentReference docRef = await maladiesRef.add(maladie.toMap());
    for (var medicament in maladie.medicaments) {
      await docRef.collection('medicaments').add(medicament.toMap());
    }
    print('Maladie "${maladie
        .nom}" ajoutée à Firestore avec succès, avec ses médicaments.');
  }
}
   */