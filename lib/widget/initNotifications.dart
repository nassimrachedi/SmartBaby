import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../data/repositories/EtatSante/EtatSante_repository.dart';
import '../data/repositories/authentication/authentication_repository.dart';
import '../data/repositories/child/child_repository.dart';
import '../features/homeDoctor/history_Med/Maps/maps.dart';
import '../features/personalization/models/children_model.dart';
import '../features/personalization/screens/DoctorAi/ChatAi.dart';
import 'package:get/get.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
const AndroidInitializationSettings android = AndroidInitializationSettings('@drawable/ic_launcher');

Future<void> background(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class InitNotifications {
  static Future<void> initialize() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      final token = await FirebaseMessaging.instance.getToken();
      print('FCM token: $token');
      if (token != null) {
        AuthenticationRepository authRepo = AuthenticationRepository.instance;
        String? parentId = authRepo.getUserID;

        if (parentId != null) {
          await FirebaseFirestore.instance.collection('Users').doc(parentId).update({
            'fcmToken': token,
          });
        } else {
          print('No parent ID found, user might not be logged in');
        }
      }
    } else {
      print('User declined or has not accepted permission');
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        String? payload = notificationResponse.payload;
        if (payload != null) {
          handleNotificationPayload(payload);
        }
      },
    );

    FirebaseMessaging.onBackgroundMessage(background);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message received in foreground: ${message.notification?.title}, ${message.notification?.body}");
      _showNotification(
        message.notification?.title ?? 'No Title',
        message.notification?.body ?? 'No Body',
        message.data['payload'] , // Assuming payload contains the redirection info
      );
    });

    // Listen for changes in Firestore
    FirebaseFirestore.instance.collection('SmartWatchEsp32').doc('pfe2024').snapshots().listen((snapshot) async {
      if (snapshot.exists) {
        var newData = snapshot.data();
        // Add your logic to check newData and trigger notifications
        if (newData != null) {
          ModelChild? currentChild = await getCurrentChild();
          if (currentChild != null) {
            checkHealthStatus(newData, currentChild);
          } else {
            print("No current child found.");
          }
        }
      }
    });
  }

  static Future<void> _showNotification(String title, String body, String payload) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'high_importance_channel', // id
      'High Importance Notifications', // name
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: BigTextStyleInformation(''), // Pour le texte long
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'consult_doctor', // id
          'Localiser un médecin', // title
          showsUserInterface: true,
          // This determines if the button will open your app when clicked
        ),
      ],
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  static void handleNotificationPayload(String payload) {
    if (payload == 'maps') {
      Get.to(() => MapPages());
    } else if (payload == 'chatbot') {
      Get.to(() => Home());
    } else if (payload == 'consult_doctor') {
      Get.to(() => MapPages());
    } else if (payload == 'get_advice') {
      Get.to(() => Home());
    }
  }

  static void checkHealthStatus(Map<String, dynamic> newData, ModelChild currentChild) {
    String? childName = currentChild.firstName;
    if (childName == null) {
      print("Child name not found in the data.");
      return;
    }

    String alertMessage = 'DANGER ! Un rythme cardiaque extrêmement bas a été détecté pour votre bébé : $childName ';

    String payload = 'maps';

    try {
      if (newData['bpm'] < currentChild.minBpm || newData['bpm'] > currentChild.maxBpm) {
        alertMessage += '(Valeur actuelle: ${newData['bpm']}, plage autorisée: ${currentChild.minBpm}-${currentChild.maxBpm}). ';
      }

      if (newData['spo2'] < currentChild.spo2) {
        alertMessage += ' SpO2 trop bas (Actuel: ${newData['spo2']}, Attendu: ${currentChild.spo2}). ';
      }

      if (newData['tempBody'] < currentChild.minTemp || newData['tempBody'] > currentChild.maxTemp) {
        alertMessage += ' Température corporelle hors de la plage autorisée (Actuelle: ${newData['temp']}, Attendue: ${currentChild.minTemp}-${currentChild.maxTemp}). ';
        payload = 'chatbot'; // Rediriger vers le chatbot pour ce type d'alerte
      }
    } catch (e) {
      print("Error checking health status: $e");
    }

    _showNotification('Alerte Danger', alertMessage, payload);
  }

  static Future<ModelChild?> getCurrentChild() async {
    try {
      String? parentId = AuthenticationRepository.instance.getUserID;
      if (parentId == null) {
        print("No parent ID found.");
        return null;
      }

      DocumentSnapshot<Map<String, dynamic>> parentSnapshot = await FirebaseFirestore.instance
          .collection('Parents').doc(parentId).get();
      String? childId = parentSnapshot.data()?['ChildId'];

      if (childId != null) {
        DocumentSnapshot<Map<String, dynamic>> childSnapshot = await FirebaseFirestore.instance
            .collection('Children').doc(childId).get();
        if (childSnapshot.exists && childSnapshot.data() != null) {
          return ModelChild.fromSnapshot(childSnapshot);
        }
      }
    } catch (e) {
      print("Error getting current child: $e");
    }
    return null;
  }
}
