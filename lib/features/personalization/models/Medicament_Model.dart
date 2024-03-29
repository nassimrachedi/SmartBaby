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
