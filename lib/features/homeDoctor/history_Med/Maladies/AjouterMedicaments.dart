import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../personalization/models/Medicament_Model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.add_medicine,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _nomMedicamentController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.name,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.enter_medicine_name;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _typeMedicamentController,
                  decoration: InputDecoration(
                    labelText:AppLocalizations.of(context)!.type,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.enter_medicine_type;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionMedicamentController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.description,
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
                      child: Text(AppLocalizations.of(context)!.cancel),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final medicament = Medicament(
                            nom: _nomMedicamentController.text,
                            type: _typeMedicamentController.text,
                            details: _descriptionMedicamentController.text,
                          );
                          Navigator.of(context).pop(medicament);
                        }
                      },
                      child: Text(AppLocalizations.of(context)!.add),
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
