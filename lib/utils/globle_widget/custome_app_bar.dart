import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:talk_nest/model/auth_model/auth_model.dart';
import 'package:talk_nest/utils/constants/colors.dart';
import 'package:talk_nest/utils/helpers/helper_functions.dart';
import 'package:talk_nest/view_model/provider/call_provider.dart';
import 'package:talk_nest/view_model/provider/chat_provider.dart';

import '../../view/page/audio_call_page.dart';
import '../../view/page/video_call_page.dart';

class CustomChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String userName, userImage, userId;

  const CustomChatAppBar({
    super.key,
    required this.userName,
    required this.userImage,
    required this.userId,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    var sizes = MediaQuery.of(context).size;

    return Consumer<ChatProvider>(
      builder: (BuildContext context, chatProvider, Widget? child) {
        return AppBar(
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.blue900,
                radius: 18,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: userImage,
                    fit: BoxFit.cover,
                    width: sizes.width * 0.1,
                    height: sizes.height * 0.1,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      userName,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 5),
                    StreamBuilder<AuthModel>(
                      stream: chatProvider.getChatStatus(userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text('');
                        } else if (snapshot.hasError) {
                          return Text(
                            '${snapshot.error}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10),
                          );
                        } else {
                          String chatStatus =
                              snapshot.data!.chatStatus ?? 'No Status';
                          String timeSpend =
                              snapshot.data!.timeStamp ?? 'No Status';
                          var typingStatus = snapshot.data!.typingStatus;

                          return typingStatus == true
                              ? Text(
                                  'type...',
                                  style: Theme.of(context).textTheme.titleSmall,
                                )
                              : chatStatus == 'online'
                                  ? Text(
                                      chatStatus,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    )
                                  : Text(
                                      timeSpend,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            Consumer<CallProvider>(
              builder: (BuildContext context, callProvider, Widget? child) {
                return IconButton(
                    onPressed: () {
                      AppHelperFunctions.navigateToScreen(
                          context,
                          AudioCallPage(
                            targetUserId: userId,
                          ));
                      callProvider.callAction('hima@gmail.com', userName,
                          userImage, userId, 'audioCall');
                    },
                    icon: const Icon(Iconsax.call));
              },
            ),
            Consumer<CallProvider>(
              builder: (BuildContext context, callProvider, Widget? child) {
                return IconButton(
                    onPressed: () {
                      AppHelperFunctions.navigateToScreen(
                          context,
                          VideoCallPage(
                            targetUserId: userId,
                          ));
                      callProvider.callAction('hima@gmail.com', userName,
                          userImage, userId, 'videoCall');
                    },
                    icon: const Icon(Iconsax.video5));
              },
            ),
          ],
        );
      },
    );
  }
}
