import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:talk_nest/utils/helpers/helper_functions.dart';
import 'package:talk_nest/view_model/provider/chat_provider.dart';
import 'package:talk_nest/view_model/service/sqlite_db_service.dart';
import '../../../model/chat_model/chat_room_model.dart';
import '../../../utils/constants/colors.dart';
import '../chat_page.dart';
import '../contect_screen.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  SqliteDbService sqliteDbService = SqliteDbService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ChatProvider>(context, listen: false).getChatRoomsList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var isDark = AppHelperFunctions.isDarkMode(context);
    return Consumer<ChatProvider>(
      builder: (BuildContext context, chatProvider, Widget? child) {
        return Scaffold(
          body: StreamBuilder<List<ChatRoomModel>>(
            stream: chatProvider.getChatRoomsList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No chat rooms available.'));
              }

              final chatRooms = snapshot.data!;
              return ListView.builder(
                itemCount: chatRooms.length,
                itemBuilder: (context, index) {
                  var chatRoom = chatRooms[index];

                  String currentUserId =
                      FirebaseAuth.instance.currentUser?.uid ?? '';
                  bool isCurrentUserReceiver =
                      chatRoom.receiver?.receiverId == currentUserId;

                  String userImage = isCurrentUserReceiver
                      ? (chatRoom.sender?.imageUrl ?? '')
                      : (chatRoom.receiver?.imageUrl ?? '');

                  String userName = isCurrentUserReceiver
                      ? (chatRoom.sender?.senderName ?? '')
                      : (chatRoom.receiver?.receiverName ?? '');

                  String notiToken = isCurrentUserReceiver
                      ? (chatRoom.sender?.fcmToken ?? '')
                      : (chatRoom.receiver?.fcmToken ?? '');

                  String userId = isCurrentUserReceiver
                      ? (chatRoom.sender?.senderId ?? '')
                      : (chatRoom.receiver?.receiverId ?? '');

                  DateTime timeStamp = DateTime.parse(chatRoom.timestamp ?? '');
                  String formattedTime =
                      DateFormat('hh:mm a').format(timeStamp);

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          isDark ? AppColors.blue900 : AppColors.lightBlue,
                      child: ClipOval(
                        child: userImage.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: userImage,
                                width: 50,
                                height: 50,
                                fit: BoxFit.fill,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )
                            : const Icon(Icons.person),
                      ),
                    ),
                    title: Text(
                      userName,
                      style: const TextStyle(fontSize: 15),
                    ),
                    subtitle: Text(chatRoom.lastMessage ?? ''),
                    trailing: Text(formattedTime),
                    onTap: () {
                      AppHelperFunctions.navigateToScreen(
                        context,
                        ChatPage(
                          userImage: userImage,
                          userId: userId,
                          userName: userName,
                          notificationToken: notiToken,
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              AppHelperFunctions.navigateToScreen(
                context,
                const ContectScreen(),
              );
            },
            heroTag: 'bnm',
            child: const HugeIcon(
              icon: HugeIcons.strokeRoundedMessageAdd02,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
