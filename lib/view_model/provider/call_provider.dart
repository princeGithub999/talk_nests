import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:talk_nest/view/page/video_call_page.dart';
import 'package:talk_nest/view_model/service/audio_call_service.dart';
import 'package:uuid/uuid.dart';

import '../../model/call_model/audio_call_model.dart';
import '../../utils/helpers/helper_functions.dart';
import '../../view/page/audio_call_page.dart';
import 'auth_provider.dart';

class CallProvider extends ChangeNotifier {
  final uuid = Uuid().v4();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  CallService audioCallService = CallService();
  var authProvider = Provider.of<AuthProviderIn>(Get.context!, listen: false);

  Future<void> callAction(String callReceiverEmail, String callReceiverName,
      String callReceiverPic, String callReceiverUid, String callType) async {
    var userName = authProvider.currentUser.userName;
    var userImage = authProvider.currentUser.userImage;
    var fcmToken = authProvider.currentUser.userPhone;
    var userId = authProvider.currentUser.userPhone;
    var phoneNumber = authProvider.currentUser.userPhone;
    var userEmail = authProvider.currentUser.userEmail;

    String id = uuid;
    var newCall = CallModel(
        callId: id,
        callerUid: auth.currentUser!.uid,
        callerName: userName,
        callerEmail: userEmail,
        callerPic: userImage,
        callReceiverEmail: callReceiverEmail,
        callReceiverName: callReceiverName,
        callReceiverPic: callReceiverPic,
        callReceiverUid: callReceiverUid,
        callType: callType);
    audioCallService.callAction(newCall);
  }

  Stream<List<CallModel>> getCallNotification() {
    return db
        .collection('CallNotification')
        .doc(auth.currentUser!.uid)
        .collection('Call')
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => CallModel.fromJson(e.data()),
              )
              .toList(),
        );
  }

  Future<void> endCall(CallModel audioCall) async {
    audioCallService.endCall(audioCall);
  }

  Future<void> audioCallNotification(CallModel callData) async {
    Get.snackbar(
        backgroundColor: Colors.blueGrey,
        duration: Duration(days: 1),
        callData.callerName!,
        'Incoming Audio call',
        barBlur: 0,
        isDismissible: false,
        icon: const Icon(Icons.call), onTap: (snack) {
      AppHelperFunctions.navigateToScreen(
          Get.context!,
          AudioCallPage(
            targetUserId: callData.callerUid!,
          ));
      Get.back();
    },
        mainButton: TextButton(
            onPressed: () {
              endCall(callData);
              Get.back();
            },
            child: const Text('end Call')));
  }

  Future<void> videoCallNotification(CallModel callData) async {
    Get.snackbar(
        backgroundColor: Colors.blueGrey,
        duration: Duration(days: 1),
        callData.callerName!,
        'Incoming Video call',
        barBlur: 0,
        isDismissible: false,
        icon: const Icon(Icons.call), onTap: (snack) {
      AppHelperFunctions.navigateToScreen(
          Get.context!,
          VideoCallPage(
            targetUserId: callData.callerUid!,
          ));
      Get.back();
    },
        mainButton: TextButton(
            onPressed: () {
              endCall(callData);
              Get.back();
            },
            child: const Text('end Call')));
  }
}
