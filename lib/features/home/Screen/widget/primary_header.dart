import 'package:SmartBaby/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:SmartBaby/features/home/Screen/historique/historique.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../data/repositories/user/user_repository.dart';
import '../../../personalization/models/user_model.dart';
import 'AppBarWidget.dart';
import 'search_enfant.dart';
final authRepo = AuthenticationRepository.instance;

final String displayName = authRepo.getUserID;


class primary_header extends StatelessWidget {
  const primary_header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TPrimaryHeaderContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          appBar(),
          SizedBox(height: 30), // Espacement entre la barre de recherche et les boutons
          Padding(
            padding: const EdgeInsets.only(left: 30.0), // Ajouter un padding à gauche du Column
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<UserModel>(
                  future: UserRepository.instance.fetchUserDetails(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Indicateur de chargement pendant la récupération des données
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return Text('Hello, User');
                    } else {
                      return Text(
                        'Hello, ${snapshot.data!.fullName}',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                  },
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
