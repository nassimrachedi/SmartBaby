import 'package:SmartBaby/features/personalization/models/MaladieModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../authentication/authentication_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class ChildMaladieRepository{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late BuildContext _context;


  Future<void> addMaladieToChild(Maladie maladie) async {
    String DoctorId= AuthenticationRepository.instance.getUserID;
    DocumentSnapshot<Map<String, dynamic>> DoctorSnapshot = await _db.collection('Doctors').doc(DoctorId).get();
    String? childId = DoctorSnapshot.data()?['ChildId'];
    try {
      await _db.collection('Children').doc(childId).collection('Maladie').add(maladie.toMap());
    } catch (e) {
      throw AppLocalizations.of(_context)!.something_save_maladie_error;
    }
  }


  Future<List<Maladie>> FetchMaladie() async {
    try {
      String DoctorId= AuthenticationRepository.instance.getUserID;
      DocumentSnapshot<Map<String, dynamic>> DoctorSnapshot = await _db.collection('Users').doc(DoctorId).get();
      String? childId = DoctorSnapshot.data()?['ChildId'];
      if (childId!.isEmpty) throw AppLocalizations.of(_context)!.unable_to_find_child_info;

      final result = await _db.collection('Children').doc(childId).collection('Maladie').get();
      return result.docs.map((documentSnapshot) => Maladie.fromDocumentSnapshot(documentSnapshot)).toList();
    } catch (e) {
      // log e.toString();
      throw AppLocalizations.of(_context)!.something_fetch_maladie_error;
    }
  }



  Future<List<Maladie>> getMaladies() async {
  try {
  String doctorId = AuthenticationRepository.instance.getUserID; // Make sure the user is logged in
  DocumentSnapshot<Map<String, dynamic>> doctorSnapshot = await _db.collection('Users').doc(doctorId).get();
  String? childId = doctorSnapshot.data()?['ChildId'];

  if (childId != null) {
  QuerySnapshot<Map<String, dynamic>> childMedicinesSnapshot = await _db.collection('Children').doc(childId).collection('Maladie').get();

  List<Maladie> maladies = childMedicinesSnapshot.docs.map((doc) => Maladie.fromMap(doc.data())).toList();
  return maladies;
  } else {
  throw Exception(AppLocalizations.of(_context)!.child_not_found);
  }
  } catch (e) {
  print(e); // Consider handling the error more gracefully
  return [];
  }
  }
  Stream<List<Maladie>> streamMaladies() {
    String doctorId = AuthenticationRepository.instance.getUserID;
    if (doctorId == null || doctorId.isEmpty) {
      throw Exception(AppLocalizations.of(_context)!.doctor_id_not_found);
    }

    return _db.collection('Doctors').doc(doctorId).snapshots().switchMap((docSnapshot) {
      String? childId = docSnapshot.data()?['ChildId'];
      if (childId != null && childId.isNotEmpty) {
        return _db.collection('Children').doc(childId).collection('Maladie').snapshots().map((maladieSnapshot) {
          return maladieSnapshot.docs.map((doc) => Maladie.fromMap(doc.data() as Map<String, dynamic>)).toList();
        });
      } else {
        return Stream<List<Maladie>>.value([]);
      }
    });
  }

  Stream<List<Maladie>> streamMaladiesPrents() {
    String doctorId = AuthenticationRepository.instance.getUserID;
    if (doctorId == null || doctorId.isEmpty) {
      throw Exception(AppLocalizations.of(_context)!.doctor_id_not_found);
    }

    return _db.collection('Parents').doc(doctorId).snapshots().switchMap((docSnapshot) {
      String? childId = docSnapshot.data()?['ChildId'];
      if (childId != null && childId.isNotEmpty) {
        return _db.collection('Children').doc(childId).collection('Maladie').snapshots().map((maladieSnapshot) {
          return maladieSnapshot.docs.map((doc) => Maladie.fromMap(doc.data() as Map<String, dynamic>)).toList();
        });
      } else {
        return Stream<List<Maladie>>.value([]);
      }
    });
  }
}





