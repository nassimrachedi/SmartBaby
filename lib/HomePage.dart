import 'package:SmartBaby/page/localization_system_page.dart';
import 'package:SmartBaby/provider/locale_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'features/authentication/screens/ChooseRole/choose_role.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key); // Utilisez un constructeur const

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    bottomNavigationBar: buildBottomBar(),
    body: buildPages(),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        // Afficher une boîte de dialogue pour sélectionner la langue
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.changerLangue),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LanguageOption('English', Locale('en')),
                LanguageOption('Français', Locale('fr')),
                LanguageOption('العربية', Locale('ar')),
              ],
            ),
          ),
        );
      },
      child: Icon(Icons.language),
    ),
  );

  Widget buildBottomBar() {
    final style = TextStyle(color: Colors.white);

    return BottomNavigationBar(
      backgroundColor: Theme.of(context).primaryColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      currentIndex: index,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings', // Définir un libellé pour le deuxième élément
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.arrow_forward), // Utilisez une icône d'arrière-plan ici
          label: 'Choose Role', // Définissez le texte du bouton ici
        ),
      ],
      onTap: (int index) {
        if (index == 1) {
          // Rediriger vers ChooseYourRole lorsque l'utilisateur appuie sur le bouton "Choose Role"
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChooseYourRole()),
          );
        } else {
          setState(() => this.index = index);
        }
      },
    );
  }

  Widget buildPages() {
    switch (index) {
      case 0:
        return LocalizationSystemPage();

      default:
        return Container();
    }
  }
}

class LanguageOption extends StatelessWidget {
  final String language;
  final Locale locale;

  const LanguageOption(this.language, this.locale);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        final provider = Provider.of<LocaleProvider>(context, listen: false);
        provider.setLocale(locale);
        Navigator.pop(context); // Fermer la boîte de dialogue après avoir sélectionné la langue
      },
      child: Text(language),
    );
  }
}
