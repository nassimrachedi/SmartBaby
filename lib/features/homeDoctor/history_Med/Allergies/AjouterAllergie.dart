import 'package:SmartBaby/data/repositories/allergieRep/allergieRepository.dart';
import 'package:SmartBaby/features/homeDoctor/history_Med/Maladies/AjouterMedicaments.dart';
import 'package:flutter/material.dart';
import 'package:SmartBaby/features/personalization/models/AllergieModel.dart';

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
        title: Text('Ajouter allergie'),
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
                  labelText: 'Nom de l\'allergie',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom d\'allergie';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _typeAllergieController,
                decoration: InputDecoration(
                  labelText: 'Type de l\'allergie',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un type d\'allergie';
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
                child: Text('Ajouter médicament'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  backgroundColor: Colors.blue,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _medicaments.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_medicaments[index].nom),
                      subtitle: Text(_medicaments[index].type),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _medicaments.removeAt(index);
                          });
                        },
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
                        SnackBar(content: Text('Allergie ajoutée avec succès')),
                      );

                      Navigator.pop(context, allergie);
                      rep.getAllergies();
                    }
                  },
                  child: Text('Ajouter'),
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
