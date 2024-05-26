import 'package:SmartBaby/data/repositories/Maladie/maladieRepository.dart';
import 'package:SmartBaby/features/personalization/models/MaladieModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../personalization/models/Medicament_Model.dart';
import '../Allergies/AjouterMedicamentAllergies.dart';


class AjouterMaladie extends StatefulWidget {
  const AjouterMaladie({Key? key});

  @override
  State<AjouterMaladie> createState() => _AjouterMaladieState();
}

class _AjouterMaladieState extends State<AjouterMaladie> {
  final ChildMaladieRepository ch = ChildMaladieRepository();
  final _formKey = GlobalKey<FormState>();
  final _nomMaladieController = TextEditingController();
  final _typeMaladieController = TextEditingController();
  List<Medicament> _medicaments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addDisease, style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nomMaladieController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.name,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.enterDiseaseName;
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _typeMaladieController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.type,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.enterDiseaseType;
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final result = await _ajouterMedicament(context);
                  if (result != null) {
                    setState(() {
                      _medicaments.add(result);
                    });
                  }
                },
                child: Text(AppLocalizations.of(context)!.add_medicine),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  backgroundColor:Color(0xffc8d8fc),
                  foregroundColor: Colors.black,
                ),
              ),



              SizedBox(height: 20),
              Expanded(
                child: ListView.builder( // Construction dynamique de la liste des médicaments
                  itemCount: _medicaments.length, // Nombre d'elements
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      elevation: 2, // Adding elevation for depth
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.blue.shade50,
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 4.0),
                        title: Text(_medicaments[index].nom, style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                        ),
                        subtitle: Text(_medicaments[index].type ,style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: Colors.black54, // Couleur du texte
                        ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.redAccent.shade100),
                          onPressed: () {
                            setState(() {
                              _medicaments.removeAt(index);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final maladie = Maladie(
                        nom: _nomMaladieController.text,
                        type: _typeMaladieController.text,
                        medicaments: _medicaments, date: DateTime.now(),
                      );

                      ch.addMaladieToChild(maladie); // Enregistrer la maladie dans Firestore

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppLocalizations.of(context)!.diseaseAddedSuccessfully)),
                      );

                      Navigator.pop(context, maladie);   // Retourne à la page précédente avec la maladie
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.add),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor:  Color(0xffc8d8fc),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }




  Future<Medicament?> _ajouterMedicament(BuildContext context) async {
    final result = await showDialog<Medicament>(
      context: context,
      builder: (BuildContext context) {
        return AjouterMedicamentAllergieDialog();
      },
    );
    return result;
  }
}