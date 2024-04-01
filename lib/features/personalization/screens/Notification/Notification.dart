import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Le widget pour la page de paramètres de notifications.
class NotificationsSettingsPage extends StatefulWidget {
  @override
  _NotificationsSettingsPageState createState() => _NotificationsSettingsPageState();
}
late BuildContext _context;
class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  bool _bpmNotificationsEnabled = false;
  bool _spo2NotificationsEnabled = false;
  bool _temperatureNotificationsEnabled = false;

  @override
  @override
  void initState() {
    super.initState();
    _context = context; // Initialiser _context dans initState()
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(_context)!.notificationsSettings),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: Text(AppLocalizations.of(_context)!.bpmNotifications),
            value: _bpmNotificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _bpmNotificationsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: Text(AppLocalizations.of(_context)!.spo2Notifications),
            value: _spo2NotificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _spo2NotificationsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: Text(AppLocalizations.of(_context)!.temperatureNotifications),
            value: _temperatureNotificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _temperatureNotificationsEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }
}


