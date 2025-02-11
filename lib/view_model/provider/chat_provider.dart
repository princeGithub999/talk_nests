import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:talk_nest/model/auth_model/auth_model.dart';
import 'package:talk_nest/model/chat_model/chat_room_model.dart';
import 'package:talk_nest/model/chat_model/user_chat_model.dart';
import 'package:talk_nest/utils/constants/colors.dart';
import 'package:talk_nest/view_model/service/chat_service.dart';
import 'package:talk_nest/view_model/service/sqlite_db_service.dart';
import 'package:uuid/uuid.dart';
import '../../utils/helpers/helper_functions.dart';
import '../../utils/internet.dart';
import '../notifaction_service/notification_service.dart';
import 'auth_provider.dart';

class ChatProvider extends ChangeNotifier {
  ChatService chatService = ChatService();
  bool isLoading = false;
  List<UserChatModel> messageList = [];
  List<ChatRoomModel> chatRoomList = [];
  bool isConnected = false;

  TextEditingController inputMessage = TextEditingController();
  var auth = FirebaseAuth.instance.currentUser!.uid;
  final db = FirebaseFirestore.instance;
  var messageId = const Uuid();
  Timer? _typingTimer;
  File? imageFile;
  var authProvider = Provider.of<AuthProviderIn>(Get.context!, listen: false);
  SqliteDbService sqliteDbService = SqliteDbService();

  void sendMessage(
      String targetUserId,
      String message,
      String notificationToken,
      String targetUserName,
      String targetUserImage) async {
    isLoading = true;
    notifyListeners();

    String? imageUrl;
    var name = authProvider.currentUser.userPhone;

    var userName = authProvider.currentUser.userName;
    var userImage = authProvider.currentUser.userImage;
    var fcmToken = authProvider.currentUser.notificationToken;

    UserChatModel sender = UserChatModel(
        senderName: userName,
        senderId: auth,
        imageUrl: userImage,
        fcmToken: fcmToken);

    UserChatModel receiver = UserChatModel(
        receiverName: targetUserName,
        receiverId: targetUserId,
        imageUrl: targetUserImage,
        fcmToken: notificationToken);

    try {
      if (imageFile != null) {
        imageUrl = await chatService.uploadChatImage(imageFile!);
      }

      if (message.isEmpty && (imageUrl == null || imageUrl.isEmpty)) {
        AppHelperFunctions.showSnackBar(
            'Please type in the message field or add an image.');
        return;
      }

      var data = UserChatModel(
        timestamp: DateTime.now().toString(),
        id: messageId.v4(),
        message: message,
        imageUrl: imageUrl ?? '',
        receiverId: targetUserId,
        senderId: FirebaseAuth.instance.currentUser!.uid,
        senderName: userName,
        receiverName: targetUserName,
        messageStatus: "sending",
      );

      var chatRoom = ChatRoomModel(
        timestamp: DateTime.now().toString(),
        lastMessage: message,
        receiver: receiver,
        sender: sender,
        userImage: targetUserImage,
        fcmToken: notificationToken,
      );

      print('Sending message: ${data.toJson()}');
      print('ChatRoom: ${chatRoom.toJson()}');

      await chatService.sendMessage(targetUserId, data, chatRoom);

      NotificationService().sendOrderNotification(
          message: message,
          token: notificationToken,
          senderName: userName!,
          userId: targetUserId,
          targetUserName: targetUserName,
          targetUserFcmToken: notificationToken,
          targetUserImage: targetUserImage);

      inputMessage.clear();
      imageFile = null;
    } catch (e) {
      print('Error sending message: $e');
      AppHelperFunctions.showSnackBar('Failed to send message: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Stream<AuthModel> getChatStatus(String targetUserId) {
    return db.collection('Chatting_UserData').doc(targetUserId).snapshots().map(
      (snapshot) {
        if (snapshot.exists) {
          return AuthModel.fromMap(snapshot.data()!);
        } else {
          throw Exception('User not found');
        }
      },
    );
  }

  Future<void> updateTypingStatus(String userId, bool isTyping) async {
    try {
      chatService.updateTypingStatus(userId, isTyping);

      if (isTyping) {
        if (_typingTimer != null) {
          _typingTimer!.cancel();
        }
        _typingTimer = Timer(
          Duration(seconds: 2),
          () {
            chatService.updateTypingStatus(userId, false);
          },
        );
      }
    } catch (e) {
      AppHelperFunctions.showSnackBar('Error $e');
    }
  }

  Future<void> updateOnlineStatus(String isOnline) async {
    try {
      chatService.updateOnlineStatus(isOnline);
    } catch (e) {
      AppHelperFunctions.showSnackBar('$e');
    }
  }

  Future<void> updateUserTimeSpend(String time) async {
    try {
      chatService.updateUserTimeSpend(time);
    } catch (e) {
      AppHelperFunctions.showSnackBar('$e');
    }
  }

  void pickImageFromChatGallery() async {
    var getImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (getImage != null) {
      imageFile = File(getImage.path);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    inputMessage.dispose();
    super.dispose();
  }

  Future<void> imageCroup(File image) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: AppColors.lightBlue,
          toolbarWidgetColor: Colors.white,
          cropFrameColor: Colors.yellow,
          backgroundColor: Colors.grey,
          cropStyle: CropStyle.rectangle,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
          ],
          lockAspectRatio: false,
        ),
      ],
    );

    if (croppedFile != null) {
      imageFile = File(croppedFile.path);
      notifyListeners();
    } else {
      print('Image cropping canceled.');
    }
  }

  void checkInitialConnectivity() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      Fluttertoast.showToast(msg: ' Mobile network available.');
      notifyListeners();
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      Fluttertoast.showToast(msg: 'wife network available.');
      notifyListeners();
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      Fluttertoast.showToast(msg: '  Ethernet connection available.');
      notifyListeners();
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      Fluttertoast.showToast(msg: 'No available network types');
      notifyListeners();
    }
  }

  Future<void> updateMessageStatus(
      String status, String targetUserId, List<UserChatModel> chats) async {
    await chatService.updateMessageStatus(status, targetUserId, chats);
  }

  Stream<List<ChatRoomModel>> getChatRoomsList() {
    return db
        .collection('chat')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((e) => ChatRoomModel.fromJson(e.data()))
          .where((element) => element.id != null && element.id!.contains(auth))
          .toList();
    });
  }

  UserChatModel getSender(UserChatModel currentUser, UserChatModel targetUser) {
    return currentUser.senderId!.compareTo(targetUser.receiverId!) > 0
        ? currentUser
        : targetUser;
  }

  UserChatModel getReceiver(
      UserChatModel currentUser, UserChatModel targetUser) {
    return currentUser.senderId!.compareTo(targetUser.receiverId!) > 0
        ? targetUser
        : currentUser;
  }
}
