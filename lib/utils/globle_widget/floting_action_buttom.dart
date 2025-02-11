import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:talk_nest/view_model/provider/chat_provider.dart';
import 'package:uuid/uuid.dart';
import '../constants/app_string.dart';
import '../constants/sizes.dart';

class FloatingActionButtomM extends StatelessWidget {
  final String userName, userImage, userId, notificationToken;

  const FloatingActionButtomM(
      {super.key,
      required this.userName,
      required this.userImage,
      required this.userId,
      required this.notificationToken});

  @override
  Widget build(BuildContext context) {
    var sizes = MediaQuery.of(context).size;
    var uuid = const Uuid();
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;
    RxString senderButtom = ''.obs;

    return Consumer<ChatProvider>(
      builder: (BuildContext context, chatProvider, Widget? child) {
        return Container(
          height: sizes.height * 0.1 - 30,
          margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 7),
          padding: const EdgeInsets.symmetric(
              vertical: AppSizes.cardRadiusXs,
              horizontal: AppSizes.cardRadiusLg),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100), color: Colors.grey),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {}, icon: const Icon(Iconsax.emoji_normal)),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: chatProvider.inputMessage,
                  decoration: const InputDecoration(
                    filled: false,
                    border: InputBorder.none,
                    disabledBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: AppString.typeMessage,
                  ),
                  onChanged: (value) {
                    if (value.trim().isNotEmpty) {
                      chatProvider.updateTypingStatus(currentUserId, true);
                    } else {
                      chatProvider.updateTypingStatus(currentUserId, false);
                    }
                    senderButtom.value = value;
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  chatProvider.pickImageFromChatGallery();
                },
                icon: const Icon(Iconsax.gallery),
              ),
              const SizedBox(width: 10),
              Obx(() {
                bool isImageSelected = chatProvider.imageFile != null;
                bool isMessageTyped = senderButtom.value.trim().isNotEmpty;
                if (!isImageSelected && !isMessageTyped) {
                  return IconButton(
                    onPressed: () {
                      // Action for microphone
                    },
                    icon: const Icon(Iconsax.microphone5),
                  );
                } else {
                  return IconButton(
                      onPressed: () {
                        chatProvider.sendMessage(
                            userId,
                            chatProvider.inputMessage.text,
                            notificationToken,
                            userName,
                            userImage);
                        chatProvider.inputMessage.clear();
                      },
                      icon: const SizedBox(
                        width: 25,
                        child: Icon(Iconsax.send1),
                      ));
                }
              }),
            ],
          ),
        );
      },
    );
  }
}
