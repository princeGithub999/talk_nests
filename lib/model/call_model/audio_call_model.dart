import 'dart:convert';

CallModel audioCallModelFromJson(String str) =>
    CallModel.fromJson(json.decode(str));

String audioCallModelToJson(CallModel data) => json.encode(data.toJson());

class CallModel {
  CallModel(
      {this.callId,
      this.callReceiverUid,
      this.callerUid,
      this.callReceiverName,
      this.callReceiverEmail,
      this.callerEmail,
      this.callerName,
      this.callerPic,
      this.callReceiverPic,
      this.status,
      this.callType});

  String? callId;
  String? callReceiverUid;
  String? callerUid;
  String? callReceiverName;
  String? callReceiverEmail;
  String? callerEmail;
  String? callerName;
  String? callerPic;
  String? callReceiverPic;
  String? status;
  String? callType;

  factory CallModel.fromJson(Map<dynamic, dynamic> json) => CallModel(
      callId: json["callId"],
      callReceiverUid: json["callReceiverUid"],
      callerUid: json["callerUid"],
      callReceiverName: json["callReceiverName"],
      callReceiverEmail: json["callReceiverEmail"],
      callerEmail: json["callerEmail"],
      callerName: json["callerName"],
      callerPic: json["callerPic"],
      callReceiverPic: json["callReceiverPic"],
      status: json["status"],
      callType: json['callType']);

  Map<String, dynamic> toJson() => {
        "callId": callId,
        "callReceiverUid": callReceiverUid,
        "callerUid": callerUid,
        "callReceiverName": callReceiverName,
        "callReceiverEmail": callReceiverEmail,
        "callerEmail": callerEmail,
        "callerName": callerName,
        "callerPic": callerPic,
        "callReceiverPic": callReceiverPic,
        "status": status,
        "callType": callType
      };
}
