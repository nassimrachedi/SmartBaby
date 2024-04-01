import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import '../../../features/personalization/models/AllergieModel.dart';
import '../authentication/authentication_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChildAllergieRepository{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late BuildContext _context;

  Future<void> addAllergieToChild(Allergie allergie) async {
    String DoctorId= AuthenticationRepository.instance.getUserID;
    DocumentSnapshot<Map<String, dynamic>> DoctorSnapshot = await _db.collection('Doctors').doc(DoctorId).get();
    String? childId = DoctorSnapshot.data()?['childId'];
    try {
      await _db.collection('Children').doc(childId).collection('Allergie').add(allergie.toMap());
    } catch (e) {
      throw  AppLocalizations.of(_context)!.something_save_maladie_error;
    }
  }


  Future<List<Allergie>> FetchAllergie() async {
    try {
      String DoctorId= AuthenticationRepository.instance.getUserID;
      DocumentSnapshot<Map<String, dynamic>> DoctorSnapshot = await _db.collection('Doctors').doc(DoctorId).get();
      String? childId = DoctorSnapshot.data()?['childId'];
      if (childId!.isEmpty) throw AppLocalizations.of(_context)!.unable_to_find_child_info;

      final result = await _db.collection('Children').doc(childId).collection('Allergie').get();
      return result.docs.map((documentSnapshot) => Allergie.fromDocumentSnapshot(documentSnapshot)).toList();
    } catch (e) {
      // log e.toString();
      throw AppLocalizations.of(_context)!.something_fetch_maladie_error;
    }
  }



  Future<List<Allergie>> getAllergies() async {
    try {
      String doctorId = AuthenticationRepository.instance.getUserID; // Make sure the user is logged in
      DocumentSnapshot<Map<String, dynamic>> doctorSnapshot = await _db.collection('Doctors').doc(doctorId).get();
      String? childId = doctorSnapshot.data()?['childId'];

      if (childId != null) {
        QuerySnapshot<Map<String, dynamic>> childMedicinesSnapshot = await _db.collection('Children').doc(childId).collection('Allergie').get();

        List<Allergie> maladies = childMedicinesSnapshot.docs.map((doc) => Allergie.fromMap(doc.data())).toList();
        return maladies;
      } else {
        throw Exception(AppLocalizations.of(_context)!.child_not_found);
      }
    } catch (e) {
      print(e); // Consider handling the error more gracefully
      return [];
    }
  }

  Stream<List<Allergie>> streamAllergie() {
    String doctorId = AuthenticationRepository.instance.getUserID;
    if (doctorId == null || doctorId.isEmpty) {
      throw Exception('Doctor ID not found.');
    }

    return _db.collection('Doctors').doc(doctorId).snapshots().switchMap((docSnapshot) {
      String? childId = docSnapshot.data()?['childId'];
      if (childId != null && childId.isNotEmpty) {
        return _db.collection('Children').doc(childId).collection('Allergie').snapshots().map((maladieSnapshot) {
          return maladieSnapshot.docs.map((doc) => Allergie.fromMap(doc.data() as Map<String, dynamic>)).toList();
        });
      } else {
        return Stream<List<Allergie>>.value([]);
      }
    });
  }

  Stream<List<Allergie>> streamAllergieParents() {
    String doctorId = AuthenticationRepository.instance.getUserID;
    if (doctorId == null || doctorId.isEmpty) {
      throw Exception('Doctor ID not found.');
    }

    return _db.collection('Parents').doc(doctorId).snapshots().switchMap((docSnapshot) {
      String? childId = docSnapshot.data()?['childId'];
      if (childId != null && childId.isNotEmpty) {
        return _db.collection('Children').doc(childId).collection('Allergie').snapshots().map((maladieSnapshot) {
          return maladieSnapshot.docs.map((doc) => Allergie.fromMap(doc.data() as Map<String, dynamic>)).toList();
        });
      } else {
        return Stream<List<Allergie>>.value([]);
      }
    });
  }
}




