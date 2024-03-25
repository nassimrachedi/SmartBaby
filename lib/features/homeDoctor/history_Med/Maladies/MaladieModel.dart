import '../MedicamentModel.dart';

class Maladie {
  final String nom;
  final String type;
  final List<Medicament> medicaments; // Liste des médicaments

  Maladie({required this.nom, required this.type, required this.medicaments});
}