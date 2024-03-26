import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../../../features/personalization/models/children_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../authentication/authentication_repository.dart';

class ChildRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addChild(ModelChild child, String parentId) async {
    String parentId = AuthenticationRepository.instance.getUserID;

    // Check if parentId is null before using it
    if (parentId == null) {
      throw Exception("User ID cannot be null"); // Handle the error gracefully
    }

    DocumentReference childRef = await _db.collection('Children').add(child.toJson());
    String childId = childRef.id;

    // Check if childId is retrieved successfully before using it
    if (childId == null) {
      throw Exception("Failed to add child"); // Handle the error gracefully
    }

    await _db.collection('Users').doc(parentId).update({'childId': childId});
  }

  Future<ModelChild?> getChild() async {
    String? parentId = AuthenticationRepository.instance.getUserID;

    // Check if parentId is null before using it
    if (parentId == null) {
      throw Exception("L'ID de l'utilisateur ne peut pas être nul");
    }

    DocumentSnapshot<Map<String, dynamic>> parentSnapshot = await _db.collection('Users').doc(parentId).get();
    String? childId = parentSnapshot.data()?['childId'];

    if (childId != null) {
      DocumentSnapshot<Map<String, dynamic>> childSnapshot = await _db.collection('Children').doc(childId).get();
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
}