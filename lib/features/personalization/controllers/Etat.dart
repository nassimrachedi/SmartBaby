class Etat {
  final double bpm; // Beats per minute
  final double spo2; // Blood oxygen saturation level
  final double temp; // Temperature
  final DateTime Heure; // Time of the measurement

  Etat({
    required this.bpm,
    required this.spo2,
    required this.temp,
    required this.Heure,
  });

  Map<String, dynamic> toMap() {
    return {
      'bpm': bpm,
      'spo2': spo2,
      'temp': temp,
      'Heure': Heure.toIso8601String(), // Store the time in ISO 8601 format
    };
  }

  static Etat fromMap(Map<String, dynamic> map, String id) {
    return Etat(
      bpm: map['bpm'],
      spo2: map['spo2'],
      temp: map['temp'],
      Heure: DateTime.parse(map['Heure']),
    );
  }
}