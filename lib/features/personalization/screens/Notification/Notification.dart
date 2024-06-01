import 'package:flutter/material.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../data/repositories/user/user_repository.dart';
import '../../models/user_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationsSettingsPage extends StatefulWidget {
  @override
  _NotificationsSettingsPageState createState() => _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  String userId = AuthenticationRepository.instance.getUserID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.notificationsSettings),
      ),
      body: StreamBuilder<UserModel>(
        stream: UserRepository.instance.userNotificationsStream(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
            UserModel user = snapshot.data!;

            return ListView(
              children: <Widget>[
                buildSwitchListTile(
                  title: AppLocalizations.of(context)!.bpmNot,
                  value: user.notifyBPM,
                  onChanged: (newValue) {
                    UserRepository.instance.updateUserNotification(userId, 'NotifyBPM', newValue);
                  },
                ),
                buildSwitchListTile(
                  title: AppLocalizations.of(context)!.spo2Not,
                  value: user.notifySpO2,
                  onChanged: (newValue) {
                    UserRepository.instance.updateUserNotification(userId, 'NotifySpO2', newValue);
                  },
                ),
                buildSwitchListTile(
                  title: AppLocalizations.of(context)!.tempNot,
                  value: user.notifyTemperature,
                  onChanged: (newValue) {
                    UserRepository.instance.updateUserNotification(userId, 'NotifyTemperature', newValue);
                  },
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  SwitchListTile buildSwitchListTile({required String title, required bool value, required Function(bool) onChanged}) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}
