import 'package:SmartBaby/app.dart';
import 'package:SmartBaby/provider/locale_provider.dart';
import 'package:SmartBaby/widget/language_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocalizationSystemPage extends StatefulWidget {
  @override
  _LocalizationSystemPageState createState() => _LocalizationSystemPageState();
}

class _LocalizationSystemPageState extends State<LocalizationSystemPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<LocaleProvider>(context, listen: false);

      provider.clearLocale();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      centerTitle: true,
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          LanguageWidget(),

        ],
      ),
    ),
  );
}
