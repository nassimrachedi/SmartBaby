import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// Assuming EtatSante.fromDocumentSnapshot is a method that creates an instance of EtatSante from a Firestore DocumentSnapshot
// and EtatSante is a class that represents the health state with attributes like bodyTemp, bpm, etc.
import '../../../features/personalization/models/EtatSante_model.dart';
import '../authentication/authentication_repository.dart';

class EtatSanteRepository2 {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Retrieve the current user's ID (parent of the child).
  String get currentUserId {
    // Implementation to retrieve the current user ID.
    // This needs to be implemented correctly, assuming AuthenticationRepository.instance.getUserID is valid.
    return AuthenticationRepository.instance.getUserID;
  }


  // Retrieve and process health state data for a specific child and given date.
  Future<Stream<Map<DateTime, EtatSante>>> getDailyEtatSanteData(DateTime selectedDate) async {
    final parentId = currentUserId;
    DocumentSnapshot<Map<String, dynamic>> parentDoc = await _db.collection('Parents').doc(parentId).get();
    String childId = parentDoc.data()?['ChildId'] ?? '';
    return _db
        .collection('Children')
        .doc(childId)
        .collection('EtatSante')
        .where('heure', isGreaterThanOrEqualTo: DateTime(selectedDate.year, selectedDate.month, selectedDate.day))
        .where('heure', isLessThan: DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 1))
        .snapshots()
        .map((snapshot) {
      print("Documents récupérés: ${snapshot.docs.length}");
      Map<DateTime, List<EtatSante>> dataByHour = {};

      for (var doc in snapshot.docs) {
        var etat = EtatSante.fromDocumentSnapshot(doc);
        var hour = DateTime(etat.heure!.year, etat.heure!.month, etat.heure!.day, etat.heure!.hour);
        if (!dataByHour.containsKey(hour)) {
          dataByHour[hour] = [];
        }
        dataByHour[hour]!.add(etat);
      }

      // Calculate the averages for each hour
      Map<DateTime, EtatSante> averageDataByHour = {};
      dataByHour.forEach((hour, etats) {
        double avgBodyTemp = etats.map((e) => e.bodyTemp).reduce((a, b) => a + b) / etats.length;
        int avgBpm = etats.map((e) => e.bpm).reduce((a, b) => a + b) ~/ etats.length;
        double avgHumidity = etats.map((e) => e.humidity).reduce((a, b) => a + b) / etats.length;
        int avgSpo2 = etats.map((e) => e.spo2).reduce((a, b) => a + b) ~/ etats.length;
        double avgTemp = etats.map((e) => e.temp).reduce((a, b) => a + b) / etats.length;

        averageDataByHour[hour] = EtatSante(
          bodyTemp: avgBodyTemp,
          bpm: avgBpm,
          humidity: avgHumidity,
          spo2: avgSpo2,
          temp: avgTemp,
          heure: hour,
        );
      });

      // Add default values for missing hours
      for (int i = 0; i < 24; i++) {
        var hour = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, i);
        averageDataByHour.putIfAbsent(hour, () => EtatSante(
          bodyTemp: 0, // Or whatever default value you consider appropriate
          bpm: 0, // Default resting heart rate
          humidity: 0, // Average room humidity
          spo2: 0, // Average healthy SpO2
          temp: 0, // Room temperature in Celsius
          heure: hour,
        ));
      }

      return averageDataByHour; // Corrected return statement without extra colon
    });
  }
}
