import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../MedicamentModel.dart';


class AjouterMedicamentDialog extends StatefulWidget {
  @override
  _AjouterMedicamentDialogState createState() => _AjouterMedicamentDialogState();
}

class _AjouterMedicamentDialogState extends State<AjouterMedicamentDialog> {
  final _nomMedicamentController = TextEditingController();
  final _typeMedicamentController = TextEditingController();
  final _descriptionMedicamentController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Clé du formulaire

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Form( // Envelopper les champs de texte avec un formulaire
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Ajouter un médicament',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _nomMedicamentController,
                  decoration: InputDecoration(
                    labelText: 'Nom du médicament',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le nom du médicament';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _typeMedicamentController,
                  decoration: InputDecoration(
                    labelText: 'Type du médicament',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le type du médicament';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionMedicamentController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Annuler'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) { // Vérifie si le formulaire est valide
                          final medicament = Medicament(
                            nom: _nomMedicamentController.text,
                            type: _typeMedicamentController.text,
                            description: _descriptionMedicamentController.text,
                          );
                          Navigator.of(context).pop(medicament);
                        }
                      },
                      child: Text('Ajouter'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


