import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:talk_nest/utils/constants/colors.dart';
import 'package:talk_nest/utils/globle_widget/shimmerEffect.dart';
import 'package:talk_nest/utils/helpers/helper_functions.dart';
import 'package:talk_nest/view/page/chat_page.dart';
import 'package:talk_nest/view_model/provider/auth_provider.dart';

import '../../view_model/notifaction_service/notification_service.dart';
import '../../view_model/provider/contect_provider.dart';

class ContectScreen extends StatefulWidget {
  const ContectScreen({super.key});

  @override
  State<ContectScreen> createState() => _ContectScreenState();
}

class _ContectScreenState extends State<ContectScreen> {
  NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final contectProvider =
          Provider.of<ContectProvider>(context, listen: false);
      contectProvider.setContact();
    });

    notificationHandler();
  }

  void notificationHandler() {
    notificationService.initialize();
    FirebaseMessaging.onMessage.listen((message) {
      notificationService.showNotificationWithReply(message);
    });
    notificationService.requestNotificationPermission();
  }

  @override
  Widget build(BuildContext context) {
    var sizes = MediaQuery.of(context).size;
    var isDark = AppHelperFunctions.isDarkMode(context);
    var authProvider = Provider.of<AuthProviderIn>(context, listen: false);

    return Consumer<ContectProvider>(
      builder: (BuildContext context, contectProvider, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Select Contact'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Padding(
                padding: EdgeInsets.only(left: sizes.width * 0.2),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("${contectProvider.contactList.length} Contacts"),
                ),
              ),
            ),
          ),
          body: contectProvider.isLoding
              ? const ShimmerEffect()
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: contectProvider.contactList.length,
                  itemBuilder: (context, index) {
                    final contact = contectProvider.contactList[index];

                    final name = contact['name']?.toString() ?? "Unknown";
                    final number = contact['number']?.toString() ?? "N/A";
                    final image = contact['image'];
                    final isMatched = contact['isMatched'] ?? false;
                    final userId = contact['userId'];
                    final userEmail = contact['userEmail'];
                    final notificationToken = contact['notificationToken'];

                    return ListTile(
                      onTap: () async {
                        if (isMatched) {
                          AppHelperFunctions.navigateToScreen(
                              context,
                              ChatPage(
                                userName: name,
                                userId: userId,
                                userImage: image,
                                notificationToken: notificationToken,
                              ));
                        } else {
                          var appLink =
                              await authProvider.inviteWithDynamicLink();
                          if (appLink != null) {
                            contectProvider.sendSms(number,
                                "Let's chat on Talk_next! It's a fast, simple, and secure app we can use to message and call each other for free. Get it at $appLink");
                          } else {
                            Fluttertoast.showToast(msg: 'uri null');
                          }
                        }
                      },
                      leading: CircleAvatar(
                        backgroundColor:
                            isDark ? AppColors.blue900 : AppColors.lightBlue,
                        child: ClipOval(
                          child: image != null
                              ? CachedNetworkImage(
                                  imageUrl: image,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                )
                              : Text(
                                  name.isNotEmpty
                                      ? name[0].toUpperCase()
                                      : 'N/A',
                                  style: const TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                      title: Text(
                        name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      subtitle: Text(number),
                      trailing: Text(
                        isMatched
                            ? FirebaseAuth.instance.currentUser!.uid == userId
                                ? 'you'
                                : ""
                            : "Invite",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
