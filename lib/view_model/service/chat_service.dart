import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:talk_nest/model/chat_model/user_chat_model.dart';
import 'package:talk_nest/view_model/service/sqlite_db_service.dart';

import '../../model/chat_model/chat_room_model.dart';

class ChatService {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var currentUser = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseStorage storage = FirebaseStorage.instance;
  SqliteDbService sqliteDbService = SqliteDbService();

  String messageId(String targetUserId) {
    User? currentUser = auth.currentUser;
    if (currentUser == null) {
      throw Exception("User not authenticated");
    }
    String currentUserId = currentUser.uid;
    return (currentUserId.compareTo(targetUserId) > 0)
        ? currentUserId + targetUserId
        : targetUserId + currentUserId;
  }

  Future<void> sendMessage(String targetUserId, UserChatModel chatModel,
      ChatRoomModel chatRoom) async {
    String roomId = messageId(targetUserId);
    var room = ChatRoomModel(
      id: roomId,
      lastMessage: chatRoom.lastMessage,
      timestamp: chatRoom.timestamp,
      receiver: chatRoom.receiver,
      sender: chatRoom.sender,
      userImage: chatRoom.userImage,
      fcmToken: chatRoom.fcmToken,
    );
    await firestore.collection('chat').doc(roomId).set(room.toJson());
    await firestore
        .collection('chat')
        .doc(roomId)
        .collection('message')
        .doc(chatModel.id)
        .set(chatModel.toJson());
  }

  Stream<List<UserChatModel>> getMessage(String targetUserId) async* {
    String roomId = messageId(targetUserId);
    yield* firestore
        .collection('chat')
        .doc(roomId)
        .collection('message')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((doc) => UserChatModel.fromJson(doc.data()))
            .toList());
  }

  void updateTypingStatus(String userId, bool isTyping) async {
    await firestore
        .collection('Chatting_UserData')
        .doc(userId)
        .update({'typingStatus': isTyping});
  }

  void updateOnlineStatus(String isOnline) async {
    await firestore
        .collection('Chatting_UserData')
        .doc(currentUser)
        .update({'chatStatus': isOnline});
  }

  void updateUserTimeSpend(String time) async {
    await firestore
        .collection('Chatting_UserData')
        .doc(currentUser)
        .update({'timeStamp': time});
  }

  Future<String> uploadChatImage(File imageFile) async {
    final ref = storage.ref().child('chat_user_image');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  Future<void> updateMessageStatus(
      String status, String targetUserId, List<UserChatModel> chats) async {
    String roomId = messageId(targetUserId);

    var filteredChat = chats.where(
      (element) =>
          element.messageStatus == "sending" &&
          element.senderId != auth.currentUser?.uid.toString(),
    );

    filteredChat.forEach(
      (element) async {
        await FirebaseFirestore.instance
            .collection('chat')
            .doc(roomId)
            .collection('message')
            .doc('${element.id}')
            .update({'messageStatus': status});
      },
    );
  }
}
