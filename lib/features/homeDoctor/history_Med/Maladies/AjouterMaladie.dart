import 'package:flutter/material.dart';
import '../MedicamentModel.dart';
import 'AjouterMedicaments.dart';
import 'MaladieModel.dart';

class AjouterMaladie extends StatefulWidget {
  const AjouterMaladie({Key? key});

  @override
  State<AjouterMaladie> createState() => _AjouterMaladieState();
}

class _AjouterMaladieState extends State<AjouterMaladie> {
  final _formKey = GlobalKey<FormState>();
  final _nomMaladieController = TextEditingController();
  List<Medicament> _medicaments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter maladie'),
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
                  labelText: 'Nom de la maladie',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom de maladie';
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
                      final maladie = Maladie(
                        nom: _nomMaladieController.text,
                        medicaments: _medicaments, type: '',
                      );

                      // Vous pouvez ici utiliser l'objet maladie comme vous le souhaitez,
                      // par exemple, l'enregistrer dans une base de données ou l'envoyer à une autre page.

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Maladie ajoutée avec succès')),
                      );

                      Navigator.pop(context, maladie);
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

  void _ajouterMedicament(BuildContext context) async {
    final result = await showDialog<Medicament>(
      context: context,
      builder: (BuildContext context) {
        return AjouterMedicamentDialog();
      },
    );

    if (result != null) {
      setState(() {
        _medicaments.add(result);
      });
    }
  }
}
