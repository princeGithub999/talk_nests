import 'dart:convert';

UserChatModel userChatModelFromJson(String str) =>
    UserChatModel.fromJson(json.decode(str));

String userChatModelToJson(UserChatModel data) => json.encode(data.toJson());

class UserChatModel {
  String? messageStatus;
  String? senderName;
  String? senderId;
  String? audioUrl;
  String? receiverId;
  String? receiverName;
  String? videoUrl;
  String? imageUrl;
  String? documentUrl;
  String? id;
  String? message;
  String? timestamp;
  String? onLineStatus;
  bool? typingStatus;
  String? fcmToken;

  UserChatModel(
      {this.messageStatus = 'sending',
      this.senderName,
      this.senderId,
      this.audioUrl,
      this.receiverId,
      this.videoUrl,
      this.imageUrl,
      this.documentUrl,
      this.id,
      this.message,
      this.timestamp,
      this.onLineStatus,
      this.typingStatus,
      this.receiverName,
      this.fcmToken});

  factory UserChatModel.fromJson(Map<dynamic, dynamic> json) => UserChatModel(
      messageStatus: json["messageStatus"],
      senderName: json["senderName"],
      senderId: json["senderId"],
      audioUrl: json["audioUrl"],
      receiverId: json["receiverId"],
      videoUrl: json["videoUrl"],
      imageUrl: json["imageUrl"],
      documentUrl: json["documentUrl"],
      id: json["id"],
      message: json["message"],
      timestamp: json["timestamp"],
      onLineStatus: json["onLineStatus"],
      typingStatus: json["typingStatus"],
      receiverName: json['receiverName'],
      fcmToken: json['fcmToken']);

  Map<String, dynamic> toJson() => {
        "messageStatus": messageStatus,
        "senderName": senderName,
        "senderId": senderId,
        "audioUrl": audioUrl,
        "receiverId": receiverId,
        "videoUrl": videoUrl,
        "imageUrl": imageUrl,
        "documentUrl": documentUrl,
        "id": id,
        "message": message,
        "timestamp": timestamp,
        "onLineStatus": onLineStatus,
        "typingStatus": typingStatus,
        "receiverName": receiverName,
        "fcmToken": fcmToken
      };
}
