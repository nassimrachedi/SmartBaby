import 'package:SmartBaby/data/repositories/allergieRep/allergieRepository.dart';
import 'package:SmartBaby/features/homeDoctor/history_Med/Maladies/AjouterMedicaments.dart';
import 'package:flutter/material.dart';
import 'package:SmartBaby/features/personalization/models/AllergieModel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../personalization/models/Medicament_Model.dart';
import 'AjouterMedicamentAllergies.dart';


class AjouterAllergie extends StatefulWidget {
  const AjouterAllergie({Key? key});

  @override
  State<AjouterAllergie> createState() => _AjouterAllergieState();
}

class _AjouterAllergieState extends State<AjouterAllergie> {
  ChildAllergieRepository rep = ChildAllergieRepository();
  final _formKey = GlobalKey<FormState>();
  final _nomAllergieController = TextEditingController();
  final _typeAllergieController = TextEditingController();
  List<Medicament> _medicaments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.add_allergy, style: TextStyle(
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
                controller: _nomAllergieController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.allergy_name,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.enter_allergy_name;
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _typeAllergieController,
                decoration: InputDecoration(
                  labelText:AppLocalizations.of(context)!.allergy_type,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.enter_allergy_type;
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
                  foregroundColor: Colors.black, padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  backgroundColor:  Color(0xffc8d8fc),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _medicaments.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      elevation: 2, // Adding elevation for depth
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.blue.shade50,
                      child: ListTile(
                        title: Text(_medicaments[index].nom,  style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.black,
                        ),),
                        subtitle: Text(_medicaments[index].type, style: TextStyle(
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
                      final allergie = Allergie(
                        nom: _nomAllergieController.text,
                        type: _typeAllergieController.text,
                        medicaments: _medicaments,
                        date: DateTime.now(),
                      );
                      rep.addAllergieToChild(allergie); // Enregistrer l'allergie dans Firestore
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppLocalizations.of(context)!.allergy_added_success)),
                      );

                      Navigator.pop(context, allergie);
                      rep.getAllergies();
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