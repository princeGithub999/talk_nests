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
      onDidReceiveNotificationResponse: handleNotificationResponse,
    );

    FirebaseMessaging.onMessage.listen(
      (event) {
        showNotificationWithReply(event);
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

  Future<void> showNotificationWithReply(RemoteMessage message) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'reply_channel_id',
      'Reply Notifications',
      channelDescription: 'Chat message with direct reply',
      importance: Importance.high,
      priority: Priority.high,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'reply_action_id',
          'Reply',
          inputs: <AndroidNotificationActionInput>[
            AndroidNotificationActionInput(label: 'Type your message...')
          ],
        ),
        AndroidNotificationAction('mute_action_id', 'Mute'),
        AndroidNotificationAction('end_chat_action_id', 'Mark as read'),
      ],
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
      payload: jsonEncode(message.data),
    );
  }

  void handleNotificationResponse(NotificationResponse response) async {
    if (response.payload != null && response.input != null) {
      Map<String, dynamic> data = jsonDecode(response.payload!);
      String replyText = response.input!;

      String senderId = currentUser?.uid ?? '';
      String receiverId = data['userId'];

      // Firestore me reply save karna
      await firestore.collection('messages').add({
        'senderId': senderId,
        'receiverId': receiverId,
        'message': replyText,
        'timestamp': FieldValue.serverTimestamp(),
      });
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

  void sendOrderNotification(
      {required String message,
      required String token,
      required String senderName,
      required String userId,
      required String targetUserName,
      required String targetUserImage,
      required String targetUserFcmToken}) async {
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
}
