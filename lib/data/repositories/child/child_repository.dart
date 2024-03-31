import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../../../features/personalization/models/children_model.dart';
import '../../../features/personalization/models/requete_model.dart';
import '../../../features/personalization/models/user_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../authentication/authentication_repository.dart';

class ChildRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addChild(ModelChild child) async {
    String parentId = AuthenticationRepository.instance.getUserID;

    // Check if parentId is null before using it
    if (parentId == null) {
      throw Exception("User ID cannot be null"); // Handle the error gracefully
    }

    DocumentReference childRef = await _db.collection('Children').add(
        child.toJson());
    String childId = childRef.id;

    // Check if childId is retrieved successfully before using it
    if (childId == null) {
      throw Exception("Failed to add child"); // Handle the error gracefully
    }
    await _db.collection('Children').doc(childId).update({'ChildId': childId});
    await _db.collection('Parents').doc(parentId).update({'ChildId': childId});
  }

  Future<ModelChild?> getChild() async {
    String? parentId = AuthenticationRepository.instance.getUserID;

    // Check if parentId is null before using it
    if (parentId == null) {
      throw Exception("L'ID de l'utilisateur ne peut pas être nul");
    }

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
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> assignDoctorToChild(String doctorEmail) async {
    String? parentId = AuthenticationRepository.instance.getUserID;
    if (parentId == null) {
      throw Exception("User not logged in");
    }

    DocumentSnapshot<Map<String, dynamic>> parentDoc = await _db.collection(
        'Parents').doc(parentId).get();
    String? childId = parentDoc.data()?['ChildId'];

    if (childId == null || childId.isEmpty) {
      throw Exception("L'utilisateur courant n'a pas d'enfant");
    }


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
  }


  Future<ModelChild?> getChildAssignedToDoctor() async {
    String? doctorId = AuthenticationRepository.instance.getUserID;
    if (doctorId == null) {
      throw Exception("Doctor not logged in");
    }

    // Récupérer les informations du médecin, y compris l'id de l'enfant associé.
    DocumentSnapshot<Map<String, dynamic>> doctorSnapshot = await _db
        .collection('Doctors').doc(doctorId).get();
    String? childId = doctorSnapshot.data()?['ChildId'];

    if (childId == null) {
      throw Exception("No child assigned to this doctor");
    }

    // Récupérer les informations de l'enfant en utilisant l'ID récupéré.
    DocumentSnapshot<Map<String, dynamic>> childSnapshot = await _db.collection(
        'Children').doc(childId).get();
    if (!childSnapshot.exists) {
      throw Exception("Child not found");
    }

    // Créer et retourner l'objet ModelChild à partir des données de l'enfant.
    return ModelChild.fromSnapshot(childSnapshot);
  }


  Future<void> deleteChild(String childId) async {
    // Récupérer l'ID de l'utilisateur courant
    String userId = AuthenticationRepository.instance.getUserID;

    // Récupérer les informations de l'utilisateur pour déterminer son rôle
    DocumentSnapshot<Map<String, dynamic>> userSnapshot = await _db.collection(
        'Users').doc(userId).get();
    UserModel user = UserModel.fromSnapshot(userSnapshot);

    // Si l'utilisateur est un parent, supprimez l'enfant de la base de données et mettez à jour le parent
    if (user.role == UserRole.parent) {
      await _db.collection('Children').doc(childId).delete();
      await _db.collection('Parents').doc(userId).update(
          {'ChildId': FieldValue.delete()});
    }
    // Si l'utilisateur est un médecin, mettez simplement à jour le médecin pour retirer l'association avec l'enfant
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
      throw Exception("Doctor not logged in");
    }

    // Récupérer le childId associé au médecin
    DocumentSnapshot<Map<String, dynamic>> doctorSnapshot = await _db
        .collection('Doctors').doc(doctorId).get();
    String? childId = doctorSnapshot.data()?['ChildId'];

    if (childId == null) {
      throw Exception("No child assigned to this doctor");
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
      throw Exception("No vital values were provided to update");
    }
  }


  Future<Doctor?> getDoctorAssignedToChildOfCurrentParent() async {
    String? parentId = AuthenticationRepository.instance
        .getUserID; // Remplacez ceci par la méthode appropriée pour obtenir l'ID du parent actuel.
    if (parentId == null) {
      throw Exception("Parent not logged in");
    }

    // Récupérer l'ID de l'enfant à partir des données du parent.
    DocumentSnapshot<Map<String, dynamic>> parentSnapshot = await _db
        .collection('Parents').doc(parentId).get();
    String? childId = parentSnapshot.data()?['ChildId'];
    if (childId == null) {
      throw Exception("Parent has no child assigned");
    }

    // Rechercher les médecins qui ont cet ID d'enfant assigné.
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

    // Supposons que childId est déjà déterminé en dehors de cette méthode.
    // Vérifier que le médecin avec l'email donné existe.
    QuerySnapshot doctorQuery = await _db.collection('Doctors')
        .where('Email', isEqualTo: doctorEmail)
        .limit(1)
        .get();

    if (doctorQuery.docs.isEmpty) {
      throw Exception("Aucun médecin trouvé avec cet e-mail");
    }

    // Créer la requête d'assignation.
    DocumentReference requestRef = await _db.collection('AssignmentRequests').add({
      'doctorEmail': doctorEmail,
      'childId': childId,
      'status': 'pending', // États possibles: pending, accepted, rejected
      'timestamp': FieldValue.serverTimestamp(), // Timestamp de la création de la requête
    });

    // Vous pouvez éventuellement enregistrer l'ID de la requête avec la méthode suivante, ou simplement l'ignorer si ce n'est pas nécessaire.
    String requestId = requestRef.id;
  }

  // Cette méthode doit être appelée lorsque le médecin accepte une assignation.
  Future<void> acceptAssignment(String requestId) async {
    // Récupérer la requête.
    DocumentSnapshot<Map<String, dynamic>> requestSnapshot = await _db.collection('AssignmentRequests').doc(requestId).get();
    if (!requestSnapshot.exists) {
      throw Exception("La requête d'assignation n'existe pas.");
    }

    // Mettre à jour le médecin avec l'ID de l'enfant.
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

    await _db.collection('AssignmentRequests').doc(requestId).update({'status': 'accepted'});
  }

  // Cette méthode doit être appelée lorsque le médecin refuse une assignation.
  Future<void> rejectAssignment(String requestId) async {
    // Marquer la requête comme rejetée.
    await _db.collection('AssignmentRequests').doc(requestId).update({'status': 'rejected'});
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

  Stream<List<DoctorAssignmentRequest>> getAssignmentRequestsStream(String doctorEmail) {
    return _db.collection('AssignmentRequests')
        .where('doctorEmail', isEqualTo: doctorEmail)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((querySnapshot) =>
        querySnapshot.docs.map((doc) => DoctorAssignmentRequest.fromSnapshot(doc)).toList()
    );
  }

  Stream<DocumentSnapshot> getChildAssignedToDoctorStream(String doctorEmail) {
    return _db.collection('Doctors')
        .doc(doctorEmail)
        .snapshots();
  }
}
