import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:talk_nest/utils/helpers/helper_functions.dart';
import 'package:talk_nest/view/page/chat_page.dart';
import 'package:talk_nest/view_model/google_secret/google_secret.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final currentUser = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else {
      Fluttertoast.showToast(msg: 'User denied permission');
    }
  }

  Future<void> initialize() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    FirebaseMessaging.onMessage.listen(
      (event) {
        showNotification(event);
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        handlerMessage(message);
      },
    );

    FirebaseMessaging.instance.getInitialMessage().then(
      (value) {
        if (value != null) {
          handlerMessage(value);
        }
      },
    );
  }

  Future<void> showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channelId',
      'channelName',
      channelDescription: 'channelDescription',
      importance: Importance.max,
      priority: Priority.high,
    );

    int notificationId = 1;

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      notificationId,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
      payload: 'not payload',
    );
  }

  void sendOrderNotification(
      {required String message,
      required String token,
      required String senderName,
      required String userId,
      required String targetUserName,
      required String targetUserImage,
      required String targetUserFcmToken}) async {
    print("token id: $token");
    final serverKey = await GoogleSecret.getServerKey();

    try {
      final response = await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/flutterfirebaseauth-439e4/messages:send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverKey',
        },
        body: jsonEncode(<String, dynamic>{
          "message": {
            "token": token,
            "data": {
              'userId': userId,
              'reciverName': targetUserName,
              'targetUserImage': targetUserImage,
              'targetUserFcmToken': targetUserFcmToken
            },
            "notification": {"title": senderName, "body": message}
          }
        }),
      );

      if (response.statusCode == 200) {
        // Fluttertoast.showToast(msg: 'send notification');
      } else {
        print(
            'Failed to send notification. Status Code: ${response.statusCode}');
        Fluttertoast.showToast(
          msg: "Failed to send notification",
        );
      }
    } catch (e) {
      print('Error sending notification: $e');
      Fluttertoast.showToast(
        msg: "Error sending notification",
      );
    }
  }

  Future<void> handlerMessage(RemoteMessage message) async {
    AppHelperFunctions.navigateToScreen(
        Get.context!,
        ChatPage(
          userId: message.data['userId'],
          userImage: message.data['targetUserImage'],
          notificationToken: message.data['targetUserFcmToken'],
          userName: message.data['reciverName'],
        ));
  }
}
