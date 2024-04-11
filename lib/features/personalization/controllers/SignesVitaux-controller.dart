import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import '../models/EtatSante_model.dart';
class HealthDataController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String smartwatchId; // This should be provided when initializing the controller
  BehaviorSubject<EtatSante?> _healthDataStream = BehaviorSubject<EtatSante?>();

  HealthDataController(this.smartwatchId) {
    _setupStream();
  }

  Stream<EtatSante?> get healthDataStream => _healthDataStream.stream;

  void _setupStream() {
    _db.collection('SmartWatchEsp32')
        .doc(smartwatchId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        try {
          EtatSante etatSante = EtatSante.fromDocumentSnapshot(snapshot);
          _healthDataStream.add(etatSante);
        } catch (e) {
          // Handle parsing error or data inconsistency
          _healthDataStream.addError(e);
        }
      } else {
        // Handle the case when the snapshot does not exist
        _healthDataStream.add(null);
      }
    }, onError: (error) {
      // Handle any errors that occur when setting up the stream
      _healthDataStream.addError(error);
    });
  }

  void dispose() {
    _healthDataStream.close(); // Always be sure to close the stream when done
  }
}
