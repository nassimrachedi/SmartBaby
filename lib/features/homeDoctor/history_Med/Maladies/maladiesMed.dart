import 'package:flutter/material.dart';
import 'AjouterMaladie.dart';

class ListMaladiesMed extends StatefulWidget {
  const ListMaladiesMed({Key? key});

  @override
  _ListMaladiesMedState createState() => _ListMaladiesMedState();
}

class _ListMaladiesMedState extends State<ListMaladiesMed> {
  List<String> _maladies = []; // Liste de noms de maladies

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maladies'),
      ),
      body: _maladies.isEmpty
          ? Center(
        child: Text('Aucune maladie ajoutée'),
      )
          : ListView.builder(
        itemCount: _maladies.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_maladies[index]),
            onTap: () {
              // Naviguer vers la page d'ajout de médicaments pour cette maladie
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AjouterMaladie()),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _ajouterMaladie(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _ajouterMaladie(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AjouterMaladie()),
    );

    if (result != null && result is String) {
      setState(() {
        _maladies.add(result);
      });
    }
  }
}
