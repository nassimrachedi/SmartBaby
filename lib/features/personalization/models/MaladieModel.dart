import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SmartBaby/features/home/Screen/historique/Maladie/maladies.dart';
import 'Medicament_Model.dart';

class Maladie {
  final String nom;
  final String type;
  final List<Medicament> medicaments;
  final DateTime date;  // Ajout du champ date

  Maladie({
    required this.nom,
    required this.type,
    required this.medicaments,
    required this.date, // Constructeur mis à jour
  });

  factory Maladie.fromMap(Map<String, dynamic> map) {
    List<Medicament> medicaments = [];
    if (map['medicaments'] != null) {
      var medicamentsList = map['medicaments'] as List;
      medicaments = medicamentsList.map((med) => Medicament.fromMap(med)).toList();
    }
    // Traiter le champ date comme un Timestamp et le convertir en DateTime
    var date = map['date'] != null ? (map['date'] as Timestamp).toDate() : DateTime.now();

    return Maladie(
      nom: map['nom'],
      type: map['type'],
      medicaments: medicaments,
      date: date, // Ajout de la date ici
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'type': type,
      'medicaments': medicaments.map((medicament) => medicament.toMap()).toList(),
      'date': Timestamp.fromDate(date), // Convertir DateTime en Timestamp
    };
  }

  factory Maladie.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    // Convertir la liste de maps en une liste de Medicament
    List<Medicament> medicaments = [];
    if (data['medicaments'] != null) {
      medicaments = List.from(data['medicaments']).map((medicamentData) => Medicament.fromMap(medicamentData)).toList();
    }

    // Traiter le champ date
    DateTime date = data['date'] != null ? (data['date'] as Timestamp).toDate() : DateTime.now();

    return Maladie(
      nom: data['nom'] ?? '',
      type: data['type'] ?? '',
      medicaments: medicaments,
      date: date, // Ajout de la date ici
    );
  }
}
