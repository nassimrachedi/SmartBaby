import 'package:SmartBaby/features/authentication/screens/ChooseRole/choose_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'bindings/general_bindings.dart';
import 'l10n/l10n.dart';
import 'page/localization_system_page.dart';
import 'provider/locale_provider.dart';
import 'routes/app_routes.dart';
import 'utils/constants/colors.dart';
import 'utils/constants/text_strings.dart';
import 'utils/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class App extends StatelessWidget {
  const App({Key? key, Locale? locale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        LocaleProvider provider = LocaleProvider();
        provider.loadSavedLocale(); // Charger la langue sauvegardée
        return provider;
      },
      builder: (context, child) {
        final provider = Provider.of<LocaleProvider>(context);

        return GetMaterialApp(
          title: TTexts.appName,
          themeMode: ThemeMode.system,
          theme: TAppTheme.lightTheme,
          darkTheme: TAppTheme.darkTheme,
          debugShowCheckedModeBanner: false,
          initialBinding: GeneralBindings(),
          getPages: AppRoutes.pages,
          locale: provider.locale,

          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: L10n.all,
          /// Show Loader or Circular Progress Indicator meanwhile Authentication Repository is deciding to show relevant screen.
          home: const Scaffold(backgroundColor: TColors.primary, body: Center(child: CircularProgressIndicator(color: Colors.white))),
        );
      },
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Changer Langue'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LanguageOption('English', Locale('en'), 'assets/Drapeau/Uk.svg'),
                    LanguageOption('Français', Locale('fr'), 'assets/Drapeau/Fr.svg'),
                    LanguageOption('العربية', Locale('ar'), 'assets/Drapeau/Dz.svg'),
                  ],
                ),
              ),
            );
          },
          icon: Icon(Icons.language, size: 30,),
        ),
      ],
    ),
    body: buildPages(),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChooseYourRole()),
        );
      },
      child: Icon(Icons.arrow_forward),
    ),
  );

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
  final String flagAsset;

  const LanguageOption(this.language, this.locale, this.flagAsset);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        final provider = Provider.of<LocaleProvider>(context, listen: false);
        provider.setLocale(locale);
        print('Langue sélectionnée : ${locale.languageCode}');
        Navigator.pop(context); // Fermer la boîte de dialogue après avoir sélectionné la langue
      },
      child: Row(
        children: [
          SvgPicture.asset(
            flagAsset,
            width: 32,
            height: 32,
          ),
          SizedBox(width: 8),
          Text(language),
        ],
      ),
    );
  }
}
