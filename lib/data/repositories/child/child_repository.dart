import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import '../../../features/personalization/models/children_model.dart';
import '../../../features/personalization/models/requete_model.dart';
import '../../../features/personalization/models/user_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../authentication/authentication_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
class ChildRepository {
  final _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late BuildContext _context;
  /// ajouter un enfant dans la bdd
  Future<void> addChild(ModelChild child) async {
    String parentId = AuthenticationRepository.instance.getUserID;
    DocumentReference childRef = await _db.collection('Children').add(
        child.toJson());
    String childId = childRef.id;
    if (childId == null) {
      throw Exception(AppLocalizations.of(_context)!
          .failed_to_add_child);
    }
    DocumentSnapshot parentDoc = await _db.collection('Parents').doc(parentId).get();

    Map<String, dynamic> parentData = parentDoc.data() as Map<String, dynamic>;
    if (!parentData.containsKey('ChildId') || parentData['ChildId'].isEmpty) {
      await _db.collection('Parents').doc(parentId).update({'ChildId': childId});
      print("ChildId mis à jour avec succès.");
    } else {
      print("Le champ 'ChildId' existe déjà et n'est pas vide.");
    }
  }




  Future<String> uploadImageChild(String path, XFile image) async {
    try {
      final ref = _firebaseStorage.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw AppLocalizations.of(_context)!.somethingWentWrong;
    }
  }

  /// Update any field in specific Users Collection
  Future<void> updateChildSingleField(Map<String, dynamic> json) async {
    try {
      String? parentId = AuthenticationRepository.instance.getUserID;
      DocumentSnapshot<Map<String, dynamic>> parentSnapshot = await _db
          .collection('Parents').doc(parentId).get();
      String? childId = parentSnapshot.data()?['ChildId'];
      await _db.collection("Children").doc(childId).update(json);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw AppLocalizations.of(_context)!.somethingWentWrong;
    }
  }




  Future<ModelChild?> getChild() async {
    String? parentId = AuthenticationRepository.instance.getUserID;


    DocumentSnapshot<Map<String, dynamic>> parentSnapshot = await _db
        .collection('Parents').doc(parentId).get();
    String? childId = parentSnapshot.data()?['ChildId'];

    if (childId != null) {
      DocumentSnapshot<Map<String, dynamic>> childSnapshot = await _db
          .collection('Children').doc(childId).get();
      if (childSnapshot.exists && childSnapshot.data() != null) {
        return ModelChild.fromSnapshot(childSnapshot);
      }
    }
    return null;
  }

  /// Function to remove child data from Firestore.
  Future<void> removeChild(String childId) async {
    try {
      await _db.collection("Children").doc(childId).delete();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw AppLocalizations.of(_context)!.something_went_wrong;
    }
  }





  Stream<void> assignDoctorToChild(String doctorEmail) async* {
    String? parentId = AuthenticationRepository.instance.getUserID;

    DocumentSnapshot<Map<String, dynamic>> parentDoc = await _db.collection('Parents').doc(parentId).get();
    String? childId = parentDoc.data()?['ChildId'];

    if (childId == null || childId.isEmpty) {
      throw Exception(AppLocalizations.of(_context)!.no_child_assigned_to_this_user);
    }

    await for (QuerySnapshot doctorQuery in _db.collection('Doctors')
        .where('Email', isEqualTo: doctorEmail)
        .limit(1)
        .snapshots()) {

      if (doctorQuery.docs.isEmpty) {
        throw Exception(AppLocalizations.of(_context)!.no_doctor_found_with_this_email);
      }

      DocumentSnapshot doctorDoc = doctorQuery.docs.first;
      await _db.collection('Doctors').doc(doctorDoc.id).update({
        'ChildId': childId
      });

    }
  }



  Future<ModelChild?> getChildAssignedToDoctor() async {
    String? doctorId = AuthenticationRepository.instance.getUserID;
    DocumentSnapshot<Map<String, dynamic>> doctorSnapshot = await _db
        .collection('Doctors').doc(doctorId).get();
    String? childId = doctorSnapshot.data()?['ChildId'];
    DocumentSnapshot<Map<String, dynamic>> childSnapshot = await _db.collection(
        'Children').doc(childId).get();
    if (!childSnapshot.exists) {
      throw Exception(AppLocalizations.of(_context)!.child_not_found);
    }
    return ModelChild.fromSnapshot(childSnapshot);
  }




  // ilaq an remplacer s  taggi apres
  Stream<ModelChild?> getChildAssignedToDoctorD() {
    String? doctorId = AuthenticationRepository.instance.getUserID;

    Stream<DocumentSnapshot<Map<String, dynamic>>> doctorStream = _db.collection('Doctors').doc(doctorId).snapshots();

    return doctorStream.switchMap((doctorSnapshot) {
      String? childId = doctorSnapshot.data()?['ChildId'];

      if (childId != null) {
        return _db.collection('Children').doc(childId).snapshots().map((childSnapshot) {
          if (childSnapshot.exists) {
            return ModelChild.fromSnapshot(childSnapshot);
          }
          return null;
        });
      } else {
        return Stream.value(null);
      }
    });
  }



  Future<void> deleteChild() async {
    String userId = AuthenticationRepository.instance.getUserID;

    DocumentSnapshot<Map<String, dynamic>> userSnapshot = await _db.collection(
        'Users').doc(userId).get();
    UserModel user = UserModel.fromSnapshot(userSnapshot);

    if (user.role == UserRole.parent) {
      DocumentSnapshot<Map<String, dynamic>> parentSnapshot = await _db
          .collection('Parents').doc(userId).get();
      String? childId = parentSnapshot.data()?['ChildId'];

      await _db.collection('Parents').doc(userId).update(
          {'ChildId': ''});
      await _db.collection('Children').doc(childId).update(
          {'idParent1': ''});
      await _db.collection('Children').doc(childId).update(
          {'idParent2': ''});
    }
    else if (user.role == UserRole.doctor) {
      DocumentSnapshot<Map<String, dynamic>> parentSnapshot = await _db
          .collection('Doctors').doc(userId).get();
      String? childId = parentSnapshot.data()?['ChildId'];
      await _db.collection('DoctorChild').doc(userId).update(
          {'ChildId': ''});
    }
  }


  Future<void> updateChildVitalValuesForDoctor({
    double? minBpm,
    double? maxBpm,
    double? minTemp,
    double? maxTemp,
    double? spo2,
  }) async {
    String? doctorId = AuthenticationRepository.instance.getUserID;

    if (doctorId == null) {
      throw Exception(AppLocalizations.of(_context)!.doctor_not_logged_in);
    }

    DocumentSnapshot<Map<String, dynamic>> doctorSnapshot = await _db
        .collection('Doctors').doc(doctorId).get();
    String? childId = doctorSnapshot.data()?['ChildId'];

    if (childId == null) {
      throw Exception(
          AppLocalizations.of(_context)!.no_child_assigned_to_this_doctor);
    }

    Map<String, dynamic> updateData = {};

    if (minBpm != null) updateData['minBpm'] = minBpm;
    if (maxBpm != null) updateData['maxBpm'] = maxBpm;
    if (minTemp != null) updateData['minTemp'] = minTemp;
    if (maxTemp != null) updateData['maxTemp'] = maxTemp;
    if (spo2 != null) updateData['spo2'] = spo2;

    if (updateData.isNotEmpty) {
      await _db.collection('Children').doc(childId).update(updateData);
    } else {
      throw Exception(
          AppLocalizations.of(_context)!.no_vital_values_provided_to_update);
    }
  }



  Stream<ModelChild> getChildStream() {
    String? doctorId = AuthenticationRepository.instance.getUserID;

    return _db.collection('Doctors').doc(doctorId).snapshots().switchMap((
        doctorSnapshot) {
      String? childId = doctorSnapshot.data()?['childId'];
      if (childId != null) {
        return _db.collection('Children').doc(childId).snapshots().map((
            childSnapshot) {
          return ModelChild.fromSnapshot(childSnapshot);
        });
      } else {
        return Stream<ModelChild>.empty();
      }
    });
  }




  Stream<List<Doctor>> getDoctorsAssignedToChildOfCurrentParent() async* {
    String parentId = AuthenticationRepository.instance.getUserID;

    DocumentSnapshot<Map<String, dynamic>> parentSnapshot = await _db.collection('Parents').doc(parentId).get();
    String? childId = parentSnapshot.data()?['ChildId'];
    if (childId == null) {
      throw Exception("Parent has no child assigned");
    }

    yield* _db.collection('DoctorChild').where('ChildId', isEqualTo: childId).snapshots().asyncMap((querySnapshot) async {
      List<Doctor> doctors = [];
      for (var doc in querySnapshot.docs) {
        String doctorId = doc['DoctorId'];
        DocumentSnapshot<Map<String, dynamic>> doctorSnapshot = await _db.collection('Doctors').doc(doctorId).get();
        if (doctorSnapshot.exists) {
          doctors.add(Doctor.fromSnapshot(doctorSnapshot));
        }
      }
      return doctors;
    });
  }


  Future<void> createAssignmentRequest(String doctorEmail) async {
    String? parentId = AuthenticationRepository.instance
        .getUserID;
    DocumentSnapshot<Map<String, dynamic>> parentSnapshot = await _db
        .collection('Parents').doc(parentId).get();
    String? childId = parentSnapshot.data()?['ChildId'];
    if (childId == null) {
      throw Exception("Parent has no child assigned");
    }

    QuerySnapshot doctorQuery = await _db.collection('Doctors')
        .where('Email', isEqualTo: doctorEmail)
        .limit(1)
        .get();

    if (doctorQuery.docs.isEmpty) {
      throw Exception("Aucun médecin trouvé avec cet e-mail");
    }
    /// création dune requete
    DocumentReference requestRef = await _db.collection('AssignmentRequests')
        .add({
      'doctorEmail': doctorEmail,
      'childId': childId,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
      'EmailParent': AuthenticationRepository.instance.getUserEmail,
    });

    String requestId = requestRef.id;
  }

  Future<void> acceptAssignment(String requestId) async {
    DocumentSnapshot<Map<String, dynamic>> requestSnapshot = await _db
        .collection('AssignmentRequests').doc(requestId).get();
    if (!requestSnapshot.exists) {
      throw Exception("La requête d'assignation n'existe pas.");
    }

    String doctorEmail = requestSnapshot.data()!['doctorEmail'] as String;
    String childId = requestSnapshot.data()!['childId'] as String;

    QuerySnapshot doctorQuery = await _db.collection('Doctors')
        .where('Email', isEqualTo: doctorEmail)
        .limit(1)
        .get();

    if (doctorQuery.docs.isEmpty) {
      throw Exception("Aucun médecin trouvé avec cet e-mail");
    }

    DocumentSnapshot doctorDoc = doctorQuery.docs.first;


    await _db.collection('AssignmentRequests').doc(requestId).update(
        {'status': 'accepted'});

    await _db.collection('DoctorChild').add({
      'DoctorId': doctorDoc.id,
      'ChildId': childId
    });
  }
  Future<void> rejectAssignment(String requestId) async {
    await _db.collection('AssignmentRequests').doc(requestId).update(
        {'status': 'rejected'});
  }


  Future<String?> getDoctorEmail(String userId) async {
    try {
      final doctorSnapshot = await _db.collection('Doctors').doc(userId).get();
      return doctorSnapshot.data()?['Email'] as String?;
    } catch (e) {
      print("Erreur lors de la récupération de l'e-mail du médecin: $e");
      return null;
    }
  }

  Stream<List<DoctorAssignmentRequest>> getAssignmentRequestsStream(
      String doctorEmail) {
    return _db.collection('AssignmentRequests')
        .where('doctorEmail', isEqualTo: doctorEmail)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((querySnapshot) =>
        querySnapshot.docs.map((doc) =>
            DoctorAssignmentRequest.fromSnapshot(doc)).toList()
    );
  }

  Stream<DocumentSnapshot> getChildAssignedToDoctorStream(String doctorEmail) {
    return _db.collection('Doctors')
        .doc(doctorEmail)
        .snapshots();
  }

  Future<void> updateSmartwatchIdForCurrentUser(String newSmartwatchId) async {
    String parentId = AuthenticationRepository.instance.getUserID;

    // Vérifiez si l'ID du parent est récupéré avec succès
    if (parentId.isEmpty) {
      throw Exception("L'ID de l'utilisateur ne peut pas être vide");
    }

    try {
      /// Vérifiez d'abord si le newSmartwatchId existe dans la collection SmartWatchEsp32
      QuerySnapshot smartwatchQuery = await _db.collection('SmartWatchEsp32')
          .where(FieldPath.documentId, isEqualTo: newSmartwatchId)
          .get();

      if (smartwatchQuery.docs.isEmpty) {
        throw Exception(
            "L'ID de la smartwatch n'existe pas dans la base de données");
      }

      /// Maintenant que nous avons confirmé que le smartwatch existe, obtenons le childId associé à ce parent
      DocumentSnapshot<Map<String, dynamic>> parentDoc = await _db.collection(
          'Parents').doc(parentId).get();
      String childId = parentDoc.data()?['ChildId'];

      // Vérifiez si le childId a été récupéré avec succès
      if (childId != null && childId.isNotEmpty) {
        // Mettez à jour le smartwatchId pour ce childId
        await _db.collection('Children').doc(childId).update(
            {'smartwatchId': newSmartwatchId});
      } else {
        throw Exception("Aucun enfant assigné à cet utilisateur");
      }
    } catch (e) {
      // Gérer les erreurs de manière appropriée
      print(e);
      throw Exception(
          "Erreur lors de la mise à jour de l'ID de la smartwatch: ${e
              .toString()}");
    }
  }
}





