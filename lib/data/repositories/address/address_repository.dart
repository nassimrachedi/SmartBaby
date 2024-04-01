import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../features/personalization/models/address_model.dart';
import '../authentication/authentication_repository.dart';

class AddressRepository extends GetxController {
  static AddressRepository get instance => Get.find();

  /// Variables
  final _db = FirebaseFirestore.instance;
  late BuildContext _context;

  /* ---------------------------- FUNCTIONS ---------------------------------*/

  /// Get all order related to current User
  Future<List<AddressModel>> fetchUserAddresses() async {
    try {
      final userId = AuthenticationRepository.instance.firebaseUser!.uid;
      if (userId.isEmpty) throw AppLocalizations.of(_context)!.user_info_not_found;

      final result = await _db.collection('Users').doc(userId).collection('Addresses').get();
      return result.docs.map((documentSnapshot) => AddressModel.fromDocumentSnapshot(documentSnapshot)).toList();
    } catch (e) {
      // log e.toString();
      throw AppLocalizations.of(_context)!.something_went_wrong;
    }
  }

  /// Store new user order
  Future<String> addAddress(AddressModel address, String userId) async {
    try {
      final currentAddress = await _db.collection('Users').doc(userId).collection('Addresses').add(address.toJson());
      return currentAddress.id;
    } catch (e) {
      throw AppLocalizations.of(_context)!.address_info_save_error;
    }
  }

  /// Clear the "selected" field for all addresses
  Future<void> updateSelectedField(String userId, String addressId, bool selected) async {
    try {
      await _db.collection('Users').doc(userId).collection('Addresses').doc(addressId).update({'SelectedAddress': selected});
    } catch (e) {
      throw AppLocalizations.of(_context)!.address_update_error;
    }
  }
}
