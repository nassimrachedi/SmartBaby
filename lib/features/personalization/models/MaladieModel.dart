class Maladie {
  final String nom;
  final String type;
  final List<Medicament> medicaments;

  Maladie({
    required this.nom,
    required this.type,
    required this.medicaments,
  });

  factory Maladie.fromMap(Map<String, dynamic> map) {
    List<Medicament> medicaments = [];
    if (map['medicaments'] != null) {
      var medicamentsList = map['medicaments'] as List;
      medicaments = medicamentsList.map((med) => Medicament.fromMap(med)).toList();
    }
    return Maladie(
      nom: map['nom'],
      type: map['type'],
      medicaments: medicaments,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'type': type,
      'medicaments': medicaments.map((medicament) => medicament.toMap()).toList(),
    };
  }
}

class Medicament {
  final String nom;
  final String type;
  final String details;

  Medicament({
    required this.nom,
    required this.type,
    required this.details,
  });

  factory Medicament.fromMap(Map<String, dynamic> map) {
    return Medicament(
      nom: map['nom'],
      type: map['type'],
      details: map['details'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'type': type,
      'details': details,
    };
  }
}
