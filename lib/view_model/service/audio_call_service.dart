import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talk_nest/model/call_model/audio_call_model.dart';
import 'package:talk_nest/utils/helpers/helper_functions.dart';

class CallService {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> callAction(CallModel audioCallData) async {
    try {
      await db
          .collection('CallNotification')
          .doc(audioCallData.callReceiverUid)
          .collection('Call')
          .doc(audioCallData.callId)
          .set(audioCallData.toJson());

      await db
          .collection('Chatting_UserData')
          .doc(auth.currentUser!.uid)
          .collection('Call')
          .doc(audioCallData.callId)
          .set(audioCallData.toJson());

      await db
          .collection('Chatting_UserData')
          .doc(audioCallData.callReceiverUid)
          .collection('Call')
          .doc(audioCallData.callId)
          .set(audioCallData.toJson());

      Future.delayed(
        Duration(seconds: 10),
        () {
          endCall(audioCallData);
        },
      );
    } catch (error) {
      AppHelperFunctions.showSnackBar('Error $error');
    }
  }

  Future<void> endCall(CallModel audioCall) async {
    try {
      await db
          .collection('CallNotification')
          .doc(audioCall.callReceiverUid)
          .collection('Call')
          .doc(audioCall.callId)
          .delete();
    } catch (errro) {
      AppHelperFunctions.showSnackBar('Call $errro');
    }
  }
}
