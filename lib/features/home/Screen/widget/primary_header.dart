import 'package:SmartBaby/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:SmartBaby/features/home/Screen/historique/historique.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'AppBarWidget.dart';
import 'search_enfant.dart';

class primary_header extends StatelessWidget {
  const primary_header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TPrimaryHeaderContainer(
      child: Column(
        children: [
          appBar(),
          SearchEnfant(),
          SizedBox(height: 30), // Espacement entre la barre de recherche et les boutons
          Padding(
            padding: const EdgeInsets.only(left: 20.0), // Ajouter un padding à gauche du Column
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, Jaune Cooper',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5), // Espacement entre les deux textes
                Text(
                  'Vital Sign Values',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 15), // Espacement entre les textes et le bouton
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Naviguer vers la page d'historique lorsque l'utilisateur appuie sur le bouton
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HistoriquePage()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.history, color: Colors.black), // Couleur de l'icône en noir
                          SizedBox(width: 8.0),
                          Text(
                            'View History',
                            style: TextStyle(color: Colors.black), // Couleur du texte en noir
                          ),
                          SizedBox(width: 10), // Ajout d'un espace entre le texte et l'image
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
