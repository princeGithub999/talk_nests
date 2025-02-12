import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:talk_nest/model/call_model/audio_call_model.dart';
import 'package:talk_nest/view_model/provider/auth_provider.dart';
import 'package:talk_nest/view_model/provider/call_provider.dart';
import 'package:talk_nest/view_model/provider/chat_provider.dart';
import 'package:talk_nest/view_model/service/audio_call_service.dart';

class ChatStatusGetX extends GetxController with WidgetsBindingObserver {
  late ChatProvider chatProvider;
  late CallProvider callProvider;
  late AuthProviderIn authProviderIn;
  DateTime currentTime = DateTime.now();
  CallService audioCallService = CallService();

  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    chatProvider = Provider.of<ChatProvider>(Get.context!, listen: false);
    await chatProvider.updateOnlineStatus('online');

    callProvider = Provider.of<CallProvider>(Get.context!, listen: false);
    callProvider.getCallNotification().listen(
      (List<CallModel> audioCall) {
        if (audioCall.isNotEmpty) {
          var callData = audioCall[0];

          if (callData.callType == 'audioCall') {
            callProvider.audioCallNotification(callData);
          } else {
            callProvider.videoCallNotification(callData);
          }
        }
      },
    );

    // chatProvider.checkInitialConnectivity();

    // authProviderIn.getCurrentUser();
    // authProviderIn.getProfileData();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    currentTime = DateTime.now();

    if (state == AppLifecycleState.inactive) {
      await chatProvider.updateOnlineStatus('offline');
      String lastSeenMessage = _formatLastSeen(currentTime);
      chatProvider.updateUserTimeSpend(lastSeenMessage);
    } else if (state == AppLifecycleState.resumed) {
      await chatProvider.updateOnlineStatus('online');
    }
  }

  String _formatLastSeen(DateTime lastSeenTime) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(lastSeenTime);

    if (difference.inDays == 0) {
      return 'last seen today at ${lastSeenTime.hour}:${lastSeenTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'last seen yesterday at ${lastSeenTime.hour}:${lastSeenTime.minute.toString().padLeft(2, '0')}';
    } else {
      return 'last seen on ${lastSeenTime.day}/${lastSeenTime.month}/${lastSeenTime.year} at ${lastSeenTime.hour}:${lastSeenTime.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
}
