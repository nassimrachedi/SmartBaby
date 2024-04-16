import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../../../features/personalization/models/user_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../authentication/authentication_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Repository class for user-related operations.
class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _firebaseStorage = FirebaseStorage.instance;
  late BuildContext context;


  Future<void> saveUserRecord(UserModel doctor) async {
    try {
      await _db.collection("Users").doc(doctor.id).set(doctor.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw AppLocalizations.of(context)!.somethingWentWrong;
    }
  }


  Future<void> saveParentRecord(UserModel parent) async {
    try {
      await _db.collection("Parents").doc(parent.id).set(parent.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw AppLocalizations.of(context)!.somethingWentWrong;
    }
  }


  Future<void> saveDoctorRecord(UserModel doctor) async {
    try {
      await _db.collection("Doctors").doc(doctor.id).set(doctor.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw AppLocalizations.of(context)!.somethingWentWrong;
    }
  }

  /// Function to fetch user details based on user ID.
  Future<UserModel> fetchUserDetails() async {
    try {
      final documentSnapshot = await _db.collection("Users").doc(
          AuthenticationRepository.instance.getUserID).get();
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw AppLocalizations.of(context)!.somethingWentWrong;
    }
  }


  Future<UserModel> fetchParentDetails() async {
    try {
      final documentSnapshot = await _db.collection("Parents").doc(
          AuthenticationRepository.instance.getUserID).get();
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw AppLocalizations.of(context)!.somethingWentWrong;
    }
  }

  Future<UserModel> fetchDoctorDetails() async {
    try {
      final documentSnapshot = await _db.collection("Doctors").doc(
          AuthenticationRepository.instance.getUserID).get();
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw AppLocalizations.of(context)!.somethingWentWrong;
    }
  }

  /// Function to update user data in Firestore.
  Future<void> updateUserDetails(UserModel updatedUser) async {
    try {
      await _db.collection("Users").doc(updatedUser.id).update(
          updatedUser.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw AppLocalizations.of(context)!.somethingWentWrong;
    }
  }

  /// Update any field in specific Users Collection
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db.collection("Users").doc(
          AuthenticationRepository.instance.getUserID).update(json);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw AppLocalizations.of(context)!.somethingWentWrong;
    }
  }

  /// Upload any Image
  Future<String> uploadImage(String path, XFile image) async {
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
      throw AppLocalizations.of(context)!.somethingWentWrong;
    }
  }

  /// Function to remove user data from Firestore.
  Future<void> removeUserRecord(String userId) async {
    try {
      await _db.collection("Users").doc(userId).delete();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw AppLocalizations.of(context)!.somethingWentWrong;
    }
  }

  Future<void> updateUserNotification(String userId, String field, bool value) async {
    await _db.collection('Parents').doc(userId).update({field: value});
  }

  Stream<UserModel> userNotificationsStream(String userId) {
    return _db.collection('Parents').doc(userId).snapshots().map(
          (snapshot) {
        if (snapshot.exists && snapshot.data() != null) {
          return UserModel.fromSnapshot(snapshot);
        } else {
          return UserModel.empty();
        }
      },
    );
  }


}