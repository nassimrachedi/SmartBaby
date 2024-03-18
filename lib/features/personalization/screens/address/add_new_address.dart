import 'package:get/get.dart'; // Package GetX pour la gestion de l'état et de la navigation
import 'package:flutter/material.dart'; // Package Flutter pour la création d'interfaces utilisateur
import 'package:iconsax/iconsax.dart'; // Package Iconsax pour les icônes personnalisées
import '../../../../../utils/constants/sizes.dart'; // Fichier contenant des constantes de tailles
import '../../../../common/widgets/appbar/appbar.dart'; // Widget AppBar personnalisé
import '../../../../utils/validators/validation.dart'; // Fonctions de validation des données
import '../../controllers/address_controller.dart'; // Contrôleur pour la gestion des adresses

// Classe représentant l'écran d'ajout d'une nouvelle adresse
class AddNewAddressScreen extends StatelessWidget {
  const AddNewAddressScreen({super.key}); // Constructeur de la classe

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressController()); // Initialisation du contrôleur de l'adresse avec GetX

    return Scaffold( // Création de l'interface Scaffold
      appBar: const TAppBar(showBackArrow: true, title: Text('Add new Address')), // AppBar personnalisée
      body: SingleChildScrollView( // Utilisation d'un SingleChildScrollView pour faire défiler le contenu si nécessaire
        child: Container( // Conteneur principal
          padding: const EdgeInsets.all(TSizes.defaultSpace), // Padding autour du contenu
          child: Form( // Utilisation d'un Form pour la validation des champs de saisie
            key: controller.addressFormKey, // Clé pour identifier le formulaire
            child: Column( // Colonnes pour organiser les différents champs
              mainAxisSize: MainAxisSize.min, // Taille principale minimale
              children: [
                TextFormField( // Champ de texte pour le nom
                  controller: controller.name, // Contrôleur pour le champ de texte
                  validator: (value) => TValidator.validateEmptyText('Name', value), // Validation du champ de texte avec une fonction personnalisée
                  decoration: const InputDecoration(prefixIcon: Icon(Iconsax.user), labelText: 'Name'), // Décoration du champ de texte
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields), // Espacement vertical
                // Champs de texte pour le numéro de téléphone avec décoration
                TextFormField(
                  controller: controller.phoneNumber,
                  validator: TValidator.validatePhoneNumber, // Validation du numéro de téléphone
                  decoration: const InputDecoration(prefixIcon: Icon(Iconsax.mobile), labelText: 'Phone Number'),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields), // Espacement vertical
                // Ligne contenant les champs de texte pour la rue et le code postal
                Row(
                  children: [
                    Expanded( // Champ de texte pour la rue
                      child: TextFormField(
                        controller: controller.street,
                        validator: (value) => TValidator.validateEmptyText('Street', value), // Validation de la rue
                        expands: false,
                        decoration: const InputDecoration(
                          labelText: 'Street',
                          prefixIcon: Icon(Iconsax.building_31),
                        ),
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwInputFields), // Espacement horizontal
                    Expanded( // Champ de texte pour le code postal
                      child: TextFormField(
                        controller: controller.postalCode,
                        validator: (value) => TValidator.validateEmptyText('Postal Code', value), // Validation du code postal
                        expands: false,
                        decoration: const InputDecoration(
                          labelText: 'Postal Code',
                          prefixIcon: Icon(Iconsax.code),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields), // Espacement vertical
                // Ligne contenant les champs de texte pour la ville et l'état
                Row(
                  children: [
                    Expanded( // Champ de texte pour la ville
                      child: TextFormField(
                        controller: controller.city,
                        validator: (value) => TValidator.validateEmptyText('City', value), // Validation de la ville
                        expands: false,
                        decoration: const InputDecoration(
                          labelText: 'City',
                          prefixIcon: Icon(Iconsax.building),
                        ),
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwInputFields), // Espacement horizontal
                    Expanded( // Champ de texte pour l'état
                      child: TextFormField(
                        controller: controller.state,
                        validator: (value) => TValidator.validateEmptyText('State', value), // Validation de l'état
                        expands: false,
                        decoration: const InputDecoration(
                          labelText: 'State',
                          prefixIcon: Icon(Iconsax.activity),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields), // Espacement vertical
                // Champ de texte pour le pays
                TextFormField(
                  controller: controller.country,
                  validator: (value) => TValidator.validateEmptyText('Country', value), // Validation du pays
                  decoration: const InputDecoration(prefixIcon: Icon(Iconsax.global), labelText: 'Country'),
                ),
                const SizedBox(height: TSizes.defaultSpace), // Espacement vertical par défaut
                // Bouton pour enregistrer les informations de l'adresse
                SizedBox(
                  width: double.infinity, // Largeur du bouton étendue sur toute la largeur disponible
                  child:
                  ElevatedButton(onPressed: () => controller.addNewAddresses(), child: const Text('Save')), // Bouton avec texte 'Save' et action associée
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}