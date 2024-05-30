import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:io';
import '../../../features/personalization/models/children_model.dart';
import '../../../features/personalization/models/requete_model.dart';
import '../../../features/personalization/models/user_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../authentication/authentication_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChildRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _firebaseStorage = FirebaseStorage.instance;
  late BuildContext _context;
   /// ajouter un enfant dans la bdd
  Future<void> addChild(ModelChild child) async {
    String parentId = AuthenticationRepository.instance.getUserID;
    DocumentReference childRef = await _db.collection('Children').add(
        child.toJson());
    String childId = childRef.id;
    if (childId == null) {
      throw Exception(AppLocalizations.of(_context)!
          .failed_to_add_child); // Handle the error gracefully
    }
    await _db.collection('Children').doc(childId).update({'ChildId': childId});
    await _db.collection('Parents').doc(parentId).update({'ChildId': childId});
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



  Future<void> deleteChild(String childId) async {
    String userId = AuthenticationRepository.instance.getUserID;

    DocumentSnapshot<Map<String, dynamic>> userSnapshot = await _db.collection(
        'Users').doc(userId).get();
    UserModel user = UserModel.fromSnapshot(userSnapshot);

    if (user.role == UserRole.parent) {
      await _db.collection('Children').doc(childId).delete();
      await _db.collection('Parents').doc(userId).update(
          {'ChildId': FieldValue.delete()});
    }
    else if (user.role == UserRole.doctor) {
      await _db.collection('Doctors').doc(userId).update(
          {'ChildId': FieldValue.delete()});
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




  Future<Doctor?> getDoctorAssignedToChildOfCurrentParent() async {
    String? parentId = AuthenticationRepository.instance
        .getUserID;
    DocumentSnapshot<Map<String, dynamic>> parentSnapshot = await _db
        .collection('Parents').doc(parentId).get();
    String? childId = parentSnapshot.data()?['ChildId'];
    if (childId == null) {
      throw Exception("Parent has no child assigned");
    }

    QuerySnapshot doctorQuery = await _db.collection('Doctors')
        .where('ChildId', isEqualTo: childId)
        .limit(1)
        .get();

    if (doctorQuery.docs.isEmpty) {
      throw Exception("No doctor assigned to this child");
    }

    return Doctor.fromSnapshot(
        doctorQuery.docs.first as DocumentSnapshot<Map<String, dynamic>>);
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
    await _db.collection('Doctors').doc(doctorDoc.id).update({
      'ChildId': childId
    });

    await _db.collection('AssignmentRequests').doc(requestId).update(
        {'status': 'accepted'});

    await _db.collection('Children').doc(childId).update(
        {'DoctorId': doctorDoc.id});
  }

  Future<void> rejectAssignment(String requestId) async {
    // Marquer la requête comme rejetée.
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
  /// Upload any Image
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
}







