import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import '../../utils/constants/app_string.dart';
import '../../view_model/provider/auth_provider.dart';
import '../../view_model/service/chat_service.dart';

class VideoCallPage extends StatelessWidget {
  final String targetUserId;

  const VideoCallPage({super.key, required this.targetUserId});

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProviderIn>(context, listen: false);
    var userName = authProvider.currentUser.userName;
    ChatService chatService = ChatService();
    var roomId = chatService.messageId(targetUserId);

    return ZegoUIKitPrebuiltCall(
        appID: ZeGoCloudConfig.appId,
        appSign: ZeGoCloudConfig.appSign,
        callID: roomId,
        userID: FirebaseAuth.instance.currentUser!.uid,
        userName: userName!,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall());
  }
}
