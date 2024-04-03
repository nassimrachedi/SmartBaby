import 'package:cloud_firestore/cloud_firestore.dart';

class EtatSante {
  String id;
  final double spo2;
  final double temp;
  final double bpm;
  final String idChild;
  final DateTime heure;

  EtatSante({
    required this.id,
    required this.spo2,
    required this.temp,
    required this.bpm,
    required this.idChild,
    required this.heure,
  });

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'SpO2': spo2,
      'Temperature': temp,
      'BPM': bpm,
      'IdChild': idChild,
      'Heure': heure.toIso8601String(),
    };
  }

  factory EtatSante.fromMap(Map<String, dynamic> data) {
    return EtatSante(
      id: data['Id'] as String,
      spo2: data['SpO2'].toDouble(),
      temp: data['Temperature'].toDouble(),
      bpm: data['BPM'].toDouble(),
      idChild: data['IdChild'] as String,
      heure: (data['Heure'] as Timestamp).toDate(),
    );
  }

  // Factory constructor to create an EtatSante from a DocumentSnapshot
  factory EtatSante.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return EtatSante(
      id: snapshot.id,
      spo2: data['SpO2']?.toDouble() ?? 0.0,
      temp: data['Temperature']?.toDouble() ?? 0.0,
      bpm: data['BPM']?.toDouble() ?? 0.0,
      idChild: data['IdChild'] ?? '',
      heure: (data['Heure'] as Timestamp).toDate(),
    );
  }

  @override
  String toString() {
    return 'SpO2: $spo2%, Temp: $temp°C, BPM: $bpm, Heure: $heure';
  }
}
