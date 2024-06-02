import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:SmartBaby/features/homeDoctor/history_Med/Maps/maps.dart';
import 'package:get/get.dart';
import 'package:SmartBaby/data/repositories/authentication/authentication_repository.dart';

import 'mapsParent.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
const AndroidInitializationSettings android = AndroidInitializationSettings('@drawable/ic_launcher');
final FirebaseFirestore _db = FirebaseFirestore.instance;

class InitNotifications2 {
  static Future<void> initialize() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      final token = await FirebaseMessaging.instance.getToken();
      print('FCM token: $token');
      if (token != null) {
        AuthenticationRepository authRepo = AuthenticationRepository.instance;
        String? userId = authRepo.getUserID;

        if (userId != null) {
          await FirebaseFirestore.instance.collection('Users').doc(userId).update({
            'fcmToken': token,
          });
        } else {
          print('No user ID found, user might not be logged in');
        }
      }
    } else {
      print('User declined or has not accepted permission');
    }

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        String? payload = notificationResponse.payload;
        if (payload != null) {
          handleNotificationPayload(payload);
        }
      },
    );

    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message received in foreground: ${message.notification?.title}, ${message.notification?.body}");
      if (message.notification != null) {
        _showNotification(
          message.notification?.title ?? 'No Title',
          message.notification?.body ?? 'No Body',
          message.data['payload'] ?? '', // Assuming payload contains the redirection info
        );
      }
    });

    listenForNewRequests();
  }

  static Future<void> _showNotification(String title, String body, String payload) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'high_importance_channel', // id
      'High Importance Notifications', // name
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: BigTextStyleInformation(''),
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  static void handleNotificationPayload(String? payload) {
    if (payload == 'maps') {
      Get.to(() => DoctorMapPage());
    }
  }

  static void listenForNewRequests() {
    String doctorId = AuthenticationRepository.instance.getUserID;
    FirebaseFirestore.instance.collection('Requests').snapshots().listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          var newRequest = change.doc.data();
          if (newRequest != null && newRequest['doctorId'] == doctorId && newRequest['status'] == 'pending') {
            _showNotification('Nouvelle Demande', 'Vous avez reçu une nouvelle demande.', 'maps');
          }
        }
      }
    });
  }
}

Future<void> backgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
  if (message.notification != null) {
    InitNotifications2._showNotification(
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      message.data['payload'] ?? '',
    );
  }
}
