import 'package:SmartBaby/widget/initNotifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app.dart';
import 'data/repositories/authentication/authentication_repository.dart';
import 'features/homeDoctor/history_Med/Maps/maps.dart';
import 'features/personalization/screens/DoctorAi/ChatAi.dart';
import 'firebase_options.dart';
import 'provider/locale_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  /// -- GetX Local Storage
  await GetStorage.init();

  /// -- Overcome from transparent spaces at the bottom in iOS full Mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  /// -- Await Splash until other items Load
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// -- Initialize Firebase & Authentication Repository
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then(
        (FirebaseApp value) => Get.put(AuthenticationRepository()),
  );

  LocaleProvider localeProvider = LocaleProvider();
  await localeProvider.loadSavedLocale(); // Charger la langue sauvegardée

  /// -- Initialiser les notifications et gérer les changements de données Firestore
// Ajouter cette ligne pour initialiser les notifications

  // -- Main App Starts here...
  runApp(App(locale: localeProvider.locale));
  await InitNotifications.initialize();
}

void handleNotificationPayload(String payload) {
  if (payload == 'maps') {
    Get.to(() => MapPages());
  } else if (payload == 'chatbot') {
    Get.to(() => Home());
  }
}
