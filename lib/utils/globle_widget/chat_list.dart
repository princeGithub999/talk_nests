import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talk_nest/utils/constants/colors.dart';
import 'package:talk_nest/utils/constants/images.dart';
import 'package:talk_nest/view_model/provider/chat_provider.dart';

class ChatList extends StatelessWidget {
  final String message, time, imageUrl, messageStatus;
  bool inComing;

  ChatList(
      {super.key,
      required this.message,
      required this.inComing,
      required this.time,
      required this.imageUrl,
      required this.messageStatus});

  @override
  Widget build(BuildContext context) {
    var sizes = MediaQuery.of(context).size;

    return Consumer<ChatProvider>(
      builder: (BuildContext context, chatProvider, Widget? child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment:
                inComing ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                constraints: BoxConstraints(
                  maxWidth: sizes.width / 1.3,
                ),
                decoration: BoxDecoration(
                    color: AppColors.grey,
                    borderRadius: inComing
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(10),
                          )
                        : const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(0),
                          )),
                child: imageUrl.isEmpty
                    ? Text(message)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl: imageUrl,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          message == '' ? Container() : Text(message)
                        ],
                      ),
              ),
              const SizedBox(
                height: 3,
              ),
              Row(
                mainAxisAlignment:
                    inComing ? MainAxisAlignment.start : MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  inComing
                      ? Text(time)
                      : Row(
                          children: [
                            Text(time),
                            SizedBox(
                              width: 5,
                            ),
                            messageStatus == 'seen'
                                ? Image.asset(
                                    AppImage.doubleTick,
                                    width: sizes.width * 0.1 - 20,
                                  )
                                : Image.asset(
                                    AppImage.singleTick,
                                    width: sizes.width * 0.1 - 20,
                                  ),
                          ],
                        )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
