import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:talk_nest/view_model/provider/chat_provider.dart';

import '../constants/colors.dart';

class ChatImageSend extends StatelessWidget {
  const ChatImageSend({super.key});

  @override
  Widget build(BuildContext context) {
    var sizes = MediaQuery.of(context).size;
    return Consumer<ChatProvider>(
      builder: (BuildContext context, chatProvider, Widget? child) {
        return Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Stack(
              children: [
                Container(
                  height: sizes.height * 0.8,
                  width: sizes.width * 0.9 + 50,
                  decoration: BoxDecoration(
                    color: AppColors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    width: sizes.width * 0.5,
                    height: sizes.height * 0.5,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                FileImage(File(chatProvider.imageFile!.path)),
                            fit: BoxFit.contain)),
                  ),
                ),
                Positioned(
                    right: 10,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              chatProvider.imageCroup(chatProvider.imageFile!);
                            },
                            icon: const Icon(Iconsax.crop)),
                        IconButton(
                            onPressed: () {
                              chatProvider.imageFile = null;
                              chatProvider.notifyListeners();
                            },
                            icon: const Icon(Iconsax.close_circle)),
                      ],
                    )),
              ],
            ));
      },
    );
  }
}
