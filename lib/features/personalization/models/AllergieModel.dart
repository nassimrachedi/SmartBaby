import 'package:cloud_firestore/cloud_firestore.dart';

import 'Medicament_Model.dart';

class Allergie {
  final String nom;
  final String type;
  final List<Medicament> medicaments;
  final DateTime date;
  Allergie({
    required this.nom,
    required this.type,
    required this.medicaments,
    required this.date,
  });

  factory Allergie.fromMap(Map<String, dynamic> map) {
    List<Medicament> medicaments = [];
    if (map['medicaments'] != null) {
      var medicamentsList = map['medicaments'] as List;
      medicaments =
          medicamentsList.map((med) => Medicament.fromMap(med)).toList();
    }
    var date = map['date'] != null ? (map['date'] as Timestamp).toDate() : DateTime.now();
    return Allergie(
      nom: map['nom'],
      type: map['type'],
      medicaments: medicaments,
      date: date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'type': type,
      'medicaments': medicaments.map((medicament) => medicament.toMap())
          .toList(),
    };
  }

  factory Allergie.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    if (data != null) {
      // Convertir la liste de maps en une liste de Medicament
      List<Medicament> medicaments = [];
      if (data['medicaments'] != null) {
        medicaments = List.from(data['medicaments']).map((medicamentData) =>
            Medicament.fromMap(medicamentData)).toList();
      }

      // Ajouter d'autres champs si nécessaire, par exemple 'date'
      DateTime date = data['date'] != null ? (data['date'] as Timestamp)
          .toDate() : DateTime.now();

      return Allergie(
        nom: data['nom'] ?? '',
        type: data['type'] ?? '',
        medicaments: medicaments,
        date: date,
      );
    } else {
      // Gérer le cas où data est null
      return Allergie(
        nom: '',
        type: '',
        medicaments: [],
        date: DateTime.now(), // Ou une autre valeur par défaut pour 'date'
      );
    }
  }
}
