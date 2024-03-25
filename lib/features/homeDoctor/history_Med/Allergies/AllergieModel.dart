import '../MedicamentModel.dart';

class Allergie {
  final String nom;
  final String type;
  final List<Medicament> medicaments;

  Allergie({required this.nom, required this.type, required this.medicaments});
}
