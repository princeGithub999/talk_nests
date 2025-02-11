import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:talk_nest/utils/globle_widget/chat_list.dart';
import 'package:talk_nest/view_model/provider/chat_provider.dart';
import 'package:talk_nest/view_model/service/chat_service.dart';
import '../../utils/globle_widget/chat_image_send.dart';
import '../../utils/globle_widget/custome_app_bar.dart';
import '../../utils/globle_widget/floting_action_buttom.dart';

class ChatPage extends StatefulWidget {
  final String? userName, userId, userImage, notificationToken;

  const ChatPage({
    super.key,
    this.userName,
    this.userId,
    this.userImage,
    this.notificationToken,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomChatAppBar(
        userName: widget.userName!,
        userImage: widget.userImage!,
        userId: widget.userId!,
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 10, bottom: 70, right: 10, left: 10),
        child: Consumer<ChatProvider>(
          builder: (BuildContext context, chatProvider, Widget? child) {
            return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      StreamBuilder(
                        stream: chatService.getMessage(widget.userId!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }
                          if (snapshot.data == null) {
                            return const Center(
                              child: Text('No Message'),
                            );
                          } else {
                            chatProvider.updateMessageStatus(
                                'seen', widget.userId!, snapshot.data!);

                            return ListView.builder(
                              reverse: true,
                              itemCount: snapshot.data?.length ?? 0,
                              itemBuilder: (context, index) {
                                var chatData = snapshot.data![index];
                                DateTime timeStamp = DateTime.parse(
                                    snapshot.data![index].timestamp ?? '');
                                String formattedTime =
                                    DateFormat('hh:mm a').format(timeStamp);

                                return ChatList(
                                  message: chatData.message ?? '',
                                  inComing: chatData.senderId == widget.userId,
                                  time: formattedTime,
                                  imageUrl: chatData.imageUrl ?? '',
                                  messageStatus: chatData.messageStatus ?? '',
                                );
                              },
                            );
                          }
                        },
                      ),
                      chatProvider.imageFile != null
                          ? const ChatImageSend()
                          : const SizedBox()
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButtomM(
        userName: widget.userName!,
        userId: widget.userId!,
        notificationToken: widget.notificationToken!,
        userImage: widget.userImage!,
      ),
    );
  }
}
