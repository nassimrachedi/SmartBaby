import 'package:cloud_firestore/cloud_firestore.dart';

import 'MaladieModel.dart';

class ModelChild {
  final String idChild;
  String firstName;
  String lastName;
  DateTime birthDate;
  double minBpm;
  double maxBpm;
  double spo2;
  double minTemp;
  double maxTemp;
  String gender;
  String smartwatchId;
  String cameraId;
  final List<Maladie>? Maladies;

  ModelChild({
    required this.idChild,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    this.minBpm = 60.0,
    this.maxBpm = 100.0,
    this.spo2= 95.0,
    this.minTemp = 36.0,
    this.maxTemp= 37.5,
    required this.gender,
    this.smartwatchId = '',
    this.cameraId = '',
    this.Maladies,
  });

  Map<String, dynamic> toJson() {
    return {
      'idChild': idChild,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate.toIso8601String(),
      'minBpm': minBpm,
      'maxBpm': maxBpm,
      'spo2': spo2,
      'minTemp': minTemp,
      'maxTemp': maxTemp,
      'gender': gender,
      'smartwatchId': smartwatchId,
      'cameraId': cameraId,
    };
  }

  factory ModelChild.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data() ?? {};
    DateTime birthDate;
    // Vérifiez si la date de naissance est une chaîne ou un Timestamp et convertissez-la en DateTime
    if (data['birthDate'] is Timestamp) {
      birthDate = (data['birthDate'] as Timestamp).toDate();
    } else if (data['birthDate'] is String) {
      birthDate = DateTime.parse(data['birthDate']);
    } else {
      throw Exception('birthDate is not in a recognizable format');
    }

    return ModelChild(
      idChild: snapshot.id,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      birthDate: birthDate,
      minBpm: (data['minBpm'] as num?)?.toDouble() ?? 60.0,
      maxBpm: (data['maxBpm'] as num?)?.toDouble() ?? 100.0,
      spo2: (data['spo2'] as num?)?.toDouble() ?? 95.0,
      minTemp: (data['minTemp'] as num?)?.toDouble() ?? 36.0,
      maxTemp: (data['maxTemp'] as num?)?.toDouble() ?? 37.5,
      gender: data['gender'] ?? '',
      smartwatchId: data['smartwatchId'] ?? '',
      cameraId: data['cameraId'] ?? '',
      Maladies : data['Maladies'] != null ? (data['Maladies'] as List).map((e) => Maladie.fromMap(e)).toList() : null,
    );
  }

  static ModelChild empty() => ModelChild(
    idChild: '',
    firstName: '',
    lastName: '',
    birthDate: DateTime.now(),
    gender: '',
  );
}
