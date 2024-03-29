import 'package:SmartBaby/features/personalization/models/MaladieModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../authentication/authentication_repository.dart';
import 'package:rxdart/rxdart.dart';
class ChildMaladieRepository{
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  Future<void> addMaladieToChild(Maladie maladie) async {
    String DoctorId= AuthenticationRepository.instance.getUserID;
    DocumentSnapshot<Map<String, dynamic>> DoctorSnapshot = await _db.collection('Doctors').doc(DoctorId).get();
    String? childId = DoctorSnapshot.data()?['childId'];
    try {
      await _db.collection('Children').doc(childId).collection('Maladie').add(maladie.toMap());
    } catch (e) {
      throw 'Something went wrong while saving Maladie Information. Try again later';
    }
  }


  Future<List<Maladie>> FetchMaladie() async {
    try {
      String DoctorId= AuthenticationRepository.instance.getUserID;
      DocumentSnapshot<Map<String, dynamic>> DoctorSnapshot = await _db.collection('Doctors').doc(DoctorId).get();
      String? childId = DoctorSnapshot.data()?['childId'];
      if (childId!.isEmpty) throw 'Unable to find Child information. Try again in few minutes.';

      final result = await _db.collection('Children').doc(childId).collection('Maladie').get();
      return result.docs.map((documentSnapshot) => Maladie.fromDocumentSnapshot(documentSnapshot)).toList();
    } catch (e) {
      // log e.toString();
      throw 'Something went wrong while fetching maladie Information. Try again later';
    }
  }



  Future<List<Maladie>> getMaladies() async {
  try {
  String doctorId = AuthenticationRepository.instance.getUserID; // Make sure the user is logged in
  DocumentSnapshot<Map<String, dynamic>> doctorSnapshot = await _db.collection('Doctors').doc(doctorId).get();
  String? childId = doctorSnapshot.data()?['childId'];

  if (childId != null) {
  QuerySnapshot<Map<String, dynamic>> childMedicinesSnapshot = await _db.collection('Children').doc(childId).collection('Maladie').get();

  List<Maladie> maladies = childMedicinesSnapshot.docs.map((doc) => Maladie.fromMap(doc.data())).toList();
  return maladies;
  } else {
  throw Exception('Child ID not found for doctor.');
  }
  } catch (e) {
  print(e); // Consider handling the error more gracefully
  return [];
  }
  }
  Stream<List<Maladie>> streamMaladies() {
    String doctorId = AuthenticationRepository.instance.getUserID;
    if (doctorId == null || doctorId.isEmpty) {
      throw Exception('Doctor ID not found.');
    }

    return _db.collection('Doctors').doc(doctorId).snapshots().switchMap((docSnapshot) {
      String? childId = docSnapshot.data()?['childId'];
      if (childId != null && childId.isNotEmpty) {
        return _db.collection('Children').doc(childId).collection('Maladie').snapshots().map((maladieSnapshot) {
          return maladieSnapshot.docs.map((doc) => Maladie.fromMap(doc.data() as Map<String, dynamic>)).toList();
        });
      } else {
        return Stream<List<Maladie>>.value([]); // On émet un Stream avec une liste vide
      }
    });
  }
}





