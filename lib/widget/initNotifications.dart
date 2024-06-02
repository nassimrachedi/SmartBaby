import 'dart:ffi';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../data/repositories/authentication/authentication_repository.dart';
import '../features/homeDoctor/history_Med/Maps/maps.dart';
import '../features/personalization/models/children_model.dart';
import 'package:get/get.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
const AndroidInitializationSettings android = AndroidInitializationSettings('@drawable/ic_launcher');
final FirebaseFirestore _db = FirebaseFirestore.instance;
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


    FirebaseFirestore.instance.collection('SmartWatchEsp32').doc('pfe2024').snapshots().listen((snapshot) async {
      if (snapshot.exists) {
        var newData = snapshot.data();
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
      styleInformation: BigTextStyleInformation(''),
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'consult_doctor', // id
          'Localiser un médecin',
          showsUserInterface: true,
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

      Get.to(() => MapPages());

  }

  static Future<void> checkHealthStatus(Map<String, dynamic> newData, ModelChild currentChild) async {
    String? childName = currentChild.firstName;
    if (childName == null) {
      print("Child name not found in the data.");
      return;
    }
    String? parentId = AuthenticationRepository.instance
        .getUserID;
    DocumentSnapshot<Map<String, dynamic>> parentSnapshot = await _db
        .collection('Parents').doc(parentId).get();
    bool? bpmactive = parentSnapshot.data()?['NotifyBPM'];
    bool? Spo2active = parentSnapshot.data()?['NotifySpO2'];
    bool? Tempactive = parentSnapshot.data()?['NotifyTemperature'];
    bool? isYella= false;

    String alertMessage = 'DANGER ! : ';
    String payload = 'maps';

    try {
      if (newData['bpm'] < currentChild.minBpm && bpmactive==true) {
        alertMessage += 'Un rythme cardiaque extrêmement bas a été détecté pour votre bébé : $childName (Valeur actuelle: ${newData['bpm']}, plage autorisée: ${currentChild.minBpm}-${currentChild.maxBpm}). ';
        isYella=true;
      }
      if (newData['bpm'] > currentChild.maxBpm && bpmactive==true) {
        alertMessage += 'Un rythme cardiaque extrêmement haut a été détecté pour votre bébé : $childName (Valeur actuelle: ${newData['bpm']}, plage autorisée: ${currentChild.minBpm}-${currentChild.maxBpm}). ';
        isYella=true; }

      if (newData['spo2'] < currentChild.spo2 && Spo2active==true) {
        alertMessage += ' SpO2 trop bas  a été détecté pour votre bébé : $childName (Valeur actuelle : ${newData['spo2']}, Attendu: ${currentChild.spo2}). ';
        isYella=true; }

      if (newData['bodyTemp'] < currentChild.minTemp && Tempactive==true) {
        alertMessage += ' Température corporelle extrêmement basse a été détectée pour votre bébé : $childName (Actuelle: ${newData['bodyTemp']}, Attendue: ${currentChild.minTemp}-${currentChild.maxTemp}). ';
        ///payload = 'chatbot';
        isYella=true; }
      if (newData['bodyTemp'] > currentChild.maxTemp && Tempactive==true) {
        alertMessage += ' Température corporelle extrêmement haute a été détectée pour votre bébé : $childName (Actuelle: ${newData['bodyTemp']}, Attendue: ${currentChild.minTemp}-${currentChild.maxTemp}). ';
        ///  payload = 'chatbot';
        isYella=true;
      }
    } catch (e) {
      print("Error checking health status: $e");
    }
    if(isYella==true)
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
