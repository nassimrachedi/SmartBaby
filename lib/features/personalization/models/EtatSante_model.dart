import 'package:cloud_firestore/cloud_firestore.dart';

class EtatSante {
  final double bodyTemp;
  final int bpm;
  final double humidity;
  final int spo2;
  final double temp;
  final DateTime? heure;  // Making 'heure' optional

  EtatSante({
    required this.bodyTemp,
    required this.bpm,
    required this.humidity,
    required this.spo2,
    required this.temp,
    this.heure,  // Not required, can be null
  });

  Map<String, dynamic> toJson() {
    return {
      'bodyTemp': bodyTemp,
      'bpm': bpm,
      'humidity': humidity,
      'spo2': spo2,
      'temp': temp,
      'Heure': heure?.toIso8601String(), // Only convert to string if not null
    };
  }

  factory EtatSante.fromMap(Map<String, dynamic> data) {
    return EtatSante(
      bodyTemp: (data['bodyTemp'] ?? 0.0).toDouble(),
      bpm: (data['bpm'] ?? 0).toInt(),
      humidity: (data['humidity'] ?? 0.0).toDouble(),
      spo2: (data['spo2'] ?? 0).toInt(),
      temp: (data['temp'] ?? 0.0).toDouble(),
      heure: data['Heure'] != null ? (data['Heure'] as Timestamp).toDate() : null,
    );
  }

  factory EtatSante.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data() ?? {};
    DateTime? heure;

    // Check if 'Heure' field exists and is a Timestamp, then convert it to DateTime
    if (data['heure'] is Timestamp) {
      heure = (data['heure'] as Timestamp).toDate();
    }

    return EtatSante(
      bodyTemp: (data['bodyTemp'] ?? 0.0).toDouble(),
      bpm: (data['bpm'] ?? 0).toInt(),
      humidity: (data['humidity'] ?? 0.0).toDouble(),
      spo2: (data['spo2'] ?? 0).toInt(),
      temp: (data['temp'] ?? 0.0).toDouble(),
      heure: heure, // Can be null
    );
  }

  @override
  String toString() {
    return 'BodyTemp: $bodyTemp°C, BPM: $bpm, Humidity: $humidity%, SpO2: $spo2%, Temp: $temp°C, Heure: ${heure?.toIso8601String()}';
  }
}
