import 'package:cloud_firestore/cloud_firestore.dart';

import 'EtatSante_model.dart';
import 'MaladieModel.dart';

class ModelChild {
  final String idChild;
  String firstName;
  String lastName;
  DateTime birthDate;
  String childPicture;
  double minBpm;
  double maxBpm;
  double spo2;
  double minTemp;
  double maxTemp;
  String gender;
  String smartwatchId;
  String cameraId;
  final List<Maladie>? Maladies;
  final List<EtatSante>? Etat;
  String DoctorId;
  double taille;
  double poids;

  ModelChild({
    required this.idChild,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.childPicture,
    this.minBpm = 60.0,
    this.maxBpm = 100.0,
    this.spo2= 95.0,
    this.minTemp = 36.0,
    this.maxTemp= 37.5,
    required this.gender,
    this.smartwatchId = '',
    this.cameraId = '',
    this.Maladies,
    this.Etat,
    this.DoctorId='',
    required this.taille,
    required this.poids
  });


  Map<String, dynamic> toJson() {
    return {
      'idChild': idChild,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate.toIso8601String(),
      'childPicture': childPicture,
      'minBpm': minBpm,
      'maxBpm': maxBpm,
      'spo2': spo2,
      'minTemp': minTemp,
      'maxTemp': maxTemp,
      'gender': gender,
      'smartwatchId': smartwatchId,
      'cameraId': cameraId,
      'DoctorId': DoctorId,
      'poids':poids,
      'taille':taille

    };
  }

  factory ModelChild.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data() ?? {};
    DateTime birthDate;
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
      DoctorId: data['DoctorId'] ?? '',
      Maladies : data['Maladies'] != null ? (data['Maladies'] as List).map((e) => Maladie.fromMap(e)).toList() : null,
      Etat : data['Etat'] != null ? (data['Etat'] as List).map((e) => EtatSante.fromMap(e)).toList() : null,
      taille: (data['taille'] as num?)?.toDouble() ?? 20.0,
      poids:(data['poids'] as num?)?.toDouble() ?? 2.0,
      childPicture: data['childPicture'] ?? '',
    );
  }

  static ModelChild empty() => ModelChild(
    idChild: '',
    firstName: '',
    lastName: '',
    birthDate: DateTime.now(),
    gender: '',
    taille: 0.0,
    poids: 0.0,
    childPicture: '',
  );
}