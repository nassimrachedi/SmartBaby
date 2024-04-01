// Importation des packages nécessaires
import 'package:flutter/material.dart'; // Package Flutter pour la création d'interfaces utilisateur
import 'package:get/get.dart'; // Package GetX pour la gestion de l'état et de la navigation
import 'package:iconsax/iconsax.dart'; // Package Iconsax pour les icônes personnalisées
import '../../../../common/widgets/appbar/appbar.dart'; // Widget AppBar personnalisé
import '../../../../common/widgets/loaders/circular_loader.dart'; // Widget de chargeur circulaire
import '../../../../utils/constants/colors.dart'; // Fichier contenant des constantes de couleurs
import '../../../../utils/constants/sizes.dart'; // Fichier contenant des constantes de tailles
import '../../../../utils/helpers/cloud_helper_functions.dart'; // Fonctions d'aide pour la communication avec le cloud
import '../../controllers/address_controller.dart'; // Contrôleur pour la gestion des adresses
import 'add_new_address.dart'; // Écran pour ajouter une nouvelle adresse
import 'widgets/single_address_widget.dart'; // Widget pour afficher une seule adresse
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Classe représentant l'écran des adresses de l'utilisateur
class UserAddressScreen extends StatelessWidget {
  const UserAddressScreen({Key? key}) : super(key: key); // Constructeur de la classe

  @override
  Widget build(BuildContext context) {
    final controller = AddressController.instance; // Récupération de l'instance du contrôleur des adresses
    return Scaffold( // Création de l'interface Scaffold
      appBar: TAppBar( // AppBar personnalisée
        showBackArrow: true, // Affichage de la flèche de retour
        title: Text(AppLocalizations.of(context)!.address, style: Theme.of(context).textTheme.headlineSmall), // Titre de la page
      ),
      body: Padding( // Padding autour du contenu
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Obx( // Utilisation de Obx pour observer les changements d'état
              () => FutureBuilder( // Utilisation de FutureBuilder pour gérer les futures asynchrones
            // Utilisation de Key pour déclencher un rafraîchissement
            key: Key(controller.refreshData.value.toString()),
            future: controller.allUserAddresses(), // Appel de la fonction pour récupérer toutes les adresses de l'utilisateur
            builder: (_, snapshot) {
              /// Helper Function: Handle Loader, No Record, OR ERROR Message
              // Utilisation de la fonction d'aide pour gérer l'état des données
              final response = TCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot);
              if (response != null) return response; // Affichage du message d'erreur, du chargeur ou de l'absence de données

              return ListView.builder( // Création d'une ListView pour afficher la liste des adresses
                shrinkWrap: true, // Réduction de la taille de la ListView pour s'adapter au contenu
                itemCount: snapshot.data!.length, // Nombre d'éléments dans la liste
                itemBuilder: (_, index) => TSingleAddress( // Utilisation du widget TSingleAddress pour afficher chaque adresse
                  address: snapshot.data![index], // Récupération de l'adresse à afficher
                  onTap: () async { // Action lors du clic sur une adresse
                    Get.defaultDialog( // Affichage d'une boîte de dialogue par défaut
                      title: '', // Titre vide
                      onWillPop: () async {return false;}, // Empêcher le retour arrière
                      barrierDismissible: false, // Empêcher de fermer la boîte de dialogue en cliquant à l'extérieur
                      backgroundColor: Colors.transparent, // Fond transparent
                      content: const TCircularLoader(), // Affichage d'un chargeur circulaire
                    );
                    await controller.selectAddress(snapshot.data![index]); // Sélection de l'adresse en cours
                    Get.back(); // Fermeture de la boîte de dialogue
                  },
                ),
              );
            },
          ),
        ),
      ),

      /// Add new Address button
      floatingActionButton: FloatingActionButton( // Bouton flottant pour ajouter une nouvelle adresse
        backgroundColor: TColors.primary, // Couleur de fond du bouton
        onPressed: () => Get.to(() => const AddNewAddressScreen()), // Action lors du clic sur le bouton pour naviguer vers l'écran d'ajout d'une nouvelle adresse
        child: const Icon(Iconsax.add, color: TColors.white), // Icône du bouton pour ajouter une nouvelle adresse
      ),
    );
  }
}