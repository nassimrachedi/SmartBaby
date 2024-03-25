import 'package:flutter/material.dart';
import '../MedicamentModel.dart';
import 'AjouterMedicamentAllergies.dart';
import 'AllergieModel.dart';

class AjouterAllergie extends StatefulWidget {
  const AjouterAllergie({Key? key});

  @override
  State<AjouterAllergie> createState() => _AjouterAllergieState();
}

class _AjouterAllergieState extends State<AjouterAllergie> {
  final _formKey = GlobalKey<FormState>();
  final _nomAllergieController = TextEditingController();
  final _typeAllergieController = TextEditingController();
  List<Medicament> _medicaments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter Allergie'),
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
                  labelText: 'Nom allergie',
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
                  labelText: 'Type allergie',
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
                onPressed: () {
                  _ajouterMedicament(context);
                },
                child: Text('Ajouter médicament'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Couleur de fond du bouton
                  // Couleur du texte du bouton
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Bordures arrondies
                  ),
                  padding: EdgeInsets.all(14),
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
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Allergie ajoutée avec succès')),
                      );

                      Navigator.pop(context);
                    }
                  },
                  child: Text('Ajouter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Couleur de fond du bouton
                    // Couleur du texte du bouton
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Bordures arrondies
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.0), // Espacement vertical du bouton
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _ajouterMedicament(BuildContext context) async {
    final result = await showDialog<Medicament>(
      context: context,
      builder: (BuildContext context) {
        return AjouterMedicamentAllergieDialog();
      },
    );

    if (result != null) {
      setState(() {
        _medicaments.add(result);
      });
    }
  }
}
