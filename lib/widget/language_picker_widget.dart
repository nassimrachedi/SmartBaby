import 'package:SmartBaby/l10n/l10n.dart';
import 'package:SmartBaby/provider/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center, // Alignez le contenu au centre
      margin: EdgeInsets.only(bottom: 120 ), // Marge seulement sur le haut pour positionner l'image un peu plus haut
      child: Column(
        children: [
          Image(
            image: AssetImage('assets/application/home1.jpg'),
            width: 300,
            height: 300,
          ),
          SizedBox(height: 10),
          Text(
            'Baby Monitor',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold,),
          ),
        ],
      ),
    );
  }
}


class LanguagePickerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    final locale = provider.locale ?? Locale('en');

    return DropdownButtonHideUnderline(
      child: DropdownButton(
        value: locale,
        icon: Container(width: 12),
        items: L10n.all.map(
              (locale) {
            final flag = L10n.getFlag(locale.languageCode);
            return DropdownMenuItem(
              child: Center(
                child: Text(
                  flag,
                  style: TextStyle(fontSize: 32),
                ),
              ),
              value: locale,
              onTap: () {
                final provider = Provider.of<LocaleProvider>(context, listen: false);
                provider.setLocale(locale);
              },
            );
          },
        ).toList(),
        onChanged: (_) {},
      ),
    );
  }
}
