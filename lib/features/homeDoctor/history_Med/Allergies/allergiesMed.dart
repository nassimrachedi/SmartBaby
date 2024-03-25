import 'package:flutter/material.dart';
import 'AjouterAllergie.dart';
import 'AllergieModel.dart';

class ListAllergiesMed extends StatefulWidget {
  const ListAllergiesMed({super.key});

  @override
  _ListAllergiesMedState createState() => _ListAllergiesMedState();
}

class _ListAllergiesMedState extends State<ListAllergiesMed> {
  List<Allergie> _allergies = []; // Liste des allergies ajoutées

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Allergies'),
      ),
      body: ListView.builder(
        itemCount: _allergies.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_allergies[index].nom),
            subtitle: Text(_allergies[index].type),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _ajouterAllergie(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _ajouterAllergie(BuildContext context) async {
    final result = await Navigator.push<Allergie>(
      context,
      MaterialPageRoute(builder: (context) => AjouterAllergie()),
    );

    if (result != null) {
      setState(() {
        _allergies.add(result);
      });
    }
  }
}
