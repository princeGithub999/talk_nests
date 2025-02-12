import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:talk_nest/utils/theme/app_theme.dart';
import 'package:talk_nest/view/page/splace_screen.dart';
import 'package:talk_nest/view_model/notifaction_service/notification_service.dart';
import 'package:talk_nest/view_model/provider/auth_provider.dart';
import 'package:talk_nest/view_model/provider/buttom_navigation_provider.dart';
import 'package:talk_nest/view_model/provider/call_provider.dart';
import 'package:talk_nest/view_model/provider/chat_provider.dart';
import 'package:talk_nest/view_model/provider/contect_provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  NotificationService().initialize();
  FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true, cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => AuthProviderIn(),
      ),
      ChangeNotifierProvider(
        create: (context) => ButtomNavigationProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => ContectProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => ChatProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => CallProvider(),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const SplaceScreen(),
    );
  }
}

Future<void> backgroundHandler(RemoteMessage message) async {
  var data = message.data;
}
