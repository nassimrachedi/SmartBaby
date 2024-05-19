import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../utils/formatters/formatter.dart';
import 'address_model.dart';

/// Model class representing user data.

enum UserRole {
  parent,
  doctor,
}

class UserModel {
  // Keep those values final which you do not want to update
  final String id;
  String firstName;
  String lastName;
  final String username;
  final String email;
  String phoneNumber;
  String profilePicture;
  final List<AddressModel>? addresses;
  final UserRole role;
  String? childId;
  bool notifySpO2;
  bool notifyBPM;
  bool notifyTemperature;
  bool isOnline; // Nouveau champ pour le statut en ligne
  bool isActive;
  double? latitude;
  double? longitude;
  /// Constructor for UserModel.
  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    this.addresses,
    required this.role,
    this.childId,
    this.notifySpO2 = false,
    this.notifyBPM = false,
    this.notifyTemperature = false,
    this.isOnline=false,
    this.isActive=false,
    this.latitude,
    this.longitude,
  });

  /// Helper function to get the full name.
  String get fullName => '$firstName $lastName';

  /// Helper function to format phone number.
  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);

  /// Static function to split full name into first and last name.
  static List<String> nameParts(fullName) => fullName.split(" ");

  /// Static function to generate a username from the full name.
  static String generateUsername(fullName) {
    List<String> nameParts = fullName.split(" ");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    String camelCaseUsername = "$firstName$lastName"; // Combine first and last name
    String usernameWithPrefix = "$camelCaseUsername"; //
    return usernameWithPrefix;
  }

  /// Static function to create an empty user model.
  static UserModel empty() => UserModel(
    id: '',
    firstName: '',
    lastName: '',
    username: '',
    email: '',
    phoneNumber: '',
    profilePicture: '',
    role: UserRole.parent, // Vous pouvez définir le rôle par défaut ici si nécessaire.
  );

  /// Convert model to JSON structure for storing data in Firebase.
  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'Username': username,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
      'Role': role.toString(),
      'NotifySpO2': notifySpO2,
      'NotifyBPM': notifyBPM,
      'NotifyTemperature': notifyTemperature,
      'IsOnline': isOnline,
      'IsActive': isActive,
      if (childId != null) 'ChildId': childId,
      'Latitude': latitude,  // Ajout de la latitude
      'Longitude': longitude,
    };
  }

  /// Factory method to create a UserModel from a Firebase document snapshot.
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
        id: document.id,
        firstName: data['FirstName'] ?? '',
        lastName: data['LastName'] ?? '',
        username: data['Username'] ?? '',
        email: data['Email'] ?? '',
        phoneNumber: data['PhoneNumber'] ?? '',
        profilePicture: data['ProfilePicture'] ?? '',
        addresses: data['Addresses'] != null ? (data['Addresses'] as List).map((e) => AddressModel.fromMap(e)).toList() : null,
        role: data['Role'] == '' ? UserRole.parent : UserRole.doctor,
        childId: data['ChildId'],
        notifySpO2: data['NotifySpO2'] ?? false,
        notifyBPM: data['NotifyBPM'] ?? false,
        notifyTemperature: data['NotifyTemperature'] ?? false,
        isOnline: data['IsOnline'] ?? false,
        isActive: data['IsActive'] ?? false,
        latitude: (data['Latitude'] as num?)?.toDouble(),
        longitude: (data['Longitude'] as num?)?.toDouble(),
      );
    } else {
      return UserModel.empty();
    }
  }
}

class Parent extends UserModel {
  // Additional fields specific to parents (optional)


  Parent({
    required String id,
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String phoneNumber,
    required String profilePicture,
    List<AddressModel>? addresses,
    String? childId,
    bool notifySpO2 = false,
    bool notifyBPM = false,
    bool notifyTemperature = false,
    bool isOnline= false,
    bool isActive= false,
    double? latitude,
    double? longitude,
  }) : super(
    id: id,
    firstName: firstName,
    lastName: lastName,
    username: username,
    email: email,
    phoneNumber: phoneNumber,
    profilePicture: profilePicture,
    addresses: addresses,
    role: UserRole.parent,
    childId: childId,
    notifySpO2: notifySpO2,
    notifyBPM: notifyBPM,
    notifyTemperature: notifyTemperature,
    isOnline:isOnline,
    isActive:isActive,
    latitude: latitude,
    longitude: longitude,
  );
}

class Doctor extends UserModel {
  Doctor({
    required String id,
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String phoneNumber,
    required String profilePicture,
    List<AddressModel>? addresses,
    String? childId,
    bool notifySpO2 = false,
    bool notifyBPM = false,
    bool notifyTemperature = false,
    bool isOnline= false,
    bool isActive= false,
    double? latitude,
    double? longitude,
  }) : super(
    id: id,
    firstName: firstName,
    lastName: lastName,
    username: username,
    email: email,
    phoneNumber: phoneNumber,
    profilePicture: profilePicture,
    addresses: addresses,
    role: UserRole.doctor,
    childId: childId,
    notifySpO2: notifySpO2,
    notifyBPM: notifyBPM,
    notifyTemperature: notifyTemperature,
    isOnline: isOnline,
    isActive: isActive,
    latitude: latitude,
    longitude: longitude,

  );

  factory Doctor.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return Doctor(
        id: document.id,
        firstName: data['FirstName'] ?? '',
        lastName: data['LastName'] ?? '',
        username: data['Username'] ?? '',
        email: data['Email'] ?? '',
        phoneNumber: data['PhoneNumber'] ?? '',
        profilePicture: data['ProfilePicture'] ?? '',
        addresses: data['Addresses'] != null ? (data['Addresses'] as List).map((e) => AddressModel.fromMap(e)).toList() : null,
        childId: data['ChildId'],
        notifySpO2: data['NotifySpO2'] ?? false,
        notifyBPM: data['NotifyBPM'] ?? false,
        notifyTemperature: data['NotifyTemperature'] ?? false,
        isOnline: data['IsOnline'] ?? false,
        isActive: data['IsActive'] ?? false,
        latitude: (data['Latitude'] as num?)?.toDouble(),
        longitude: (data['Longitude'] as num?)?.toDouble(),

      );
    } else {
      return Doctor.empty();
    }
  }

  static Doctor empty() => Doctor(
    id: '',
    firstName: '',
    lastName: '',
    username: '',
    email: '',
    phoneNumber: '',
    profilePicture: '',
  );
}
