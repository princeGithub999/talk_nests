import 'dart:convert';

import 'package:talk_nest/model/chat_model/user_chat_model.dart';

ChatRoomModel chatRoomModelFromJson(String str) =>
    ChatRoomModel.fromJson(json.decode(str));

String chatRoomModelToJson(ChatRoomModel data) => json.encode(data.toJson());

class ChatRoomModel {
  UserChatModel? receiver;
  UserChatModel? sender;
  String? lastMessage;
  List<UserChatModel>? messages;
  String? id;
  String? lastMessageTimeStamp;
  String? timestamp;
  String? userImage;
  String? fcmToken;

  ChatRoomModel(
      {this.receiver,
      this.sender,
      this.lastMessage,
      this.messages,
      this.id,
      this.lastMessageTimeStamp,
      this.timestamp,
      this.userImage,
      this.fcmToken});

  factory ChatRoomModel.fromJson(Map<dynamic, dynamic> json) => ChatRoomModel(
      receiver: json["receiver"] != null
          ? UserChatModel.fromJson(json["receiver"])
          : null,
      sender: json["sender"] != null
          ? UserChatModel.fromJson(json["sender"])
          : null,
      lastMessage: json["lastMessage"],
      messages: json["messages"] != null
          ? List<UserChatModel>.from(
              json["messages"].map((x) => UserChatModel.fromJson(x)))
          : null,
      id: json["id"],
      lastMessageTimeStamp: json["lastMessageTimeStamp"],
      timestamp: json["timestamp"],
      userImage: json['userImage'],
      fcmToken: json['fcmToken']);

  Map<String, dynamic> toJson() => {
        "receiver": receiver?.toJson(),
        "sender": sender?.toJson(),
        "lastMessage": lastMessage,
        "messages": messages != null
            ? List<dynamic>.from(messages!.map((x) => x.toJson()))
            : [],
        "id": id,
        "lastMessageTimeStamp": lastMessageTimeStamp,
        "timestamp": timestamp,
        "userImage": userImage,
        "fcmToken": fcmToken
      };
}
