import 'package:flutter/material.dart';

// Le widget pour la page de paramètres de notifications.
class NotificationsSettingsPage extends StatefulWidget {
  @override
  _NotificationsSettingsPageState createState() => _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  bool _bpmNotificationsEnabled = false;
  bool _spo2NotificationsEnabled = false;
  bool _temperatureNotificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications Settings"),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: Text("BPM Notifications"),
            value: _bpmNotificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _bpmNotificationsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: Text("SpO2 Notifications"),
            value: _spo2NotificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _spo2NotificationsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: Text("Temperature Notifications"),
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


