class AuthModel {
  String? currentUserId;
  String? userName;
  int? userPhone;
  String? userEmail;
  String? userPassword;
  String? userAddress;
  String? userImage;
  String? chatStatus;
  bool? typingStatus;
  String? timeStamp;
  String? notificationToken;

  // Constructor
  AuthModel({
    this.currentUserId,
    this.chatStatus,
    this.userName,
    this.userEmail,
    this.userAddress,
    this.userPassword,
    this.userPhone,
    this.userImage,
    this.typingStatus,
    this.timeStamp,
    this.notificationToken,
  });

  // Convert the object to a map
  Map<String, dynamic> toMap() {
    return {
      'currentUserId': currentUserId,
      'userName': userName,
      'userPhone': userPhone,
      'userEmail': userEmail,
      'userPassword': userPassword,
      'userAddress': userAddress,
      'userImage': userImage,
      'chatStatus': chatStatus,
      'typingStatus': typingStatus,
      'timeStamp': timeStamp,
      'notificationToken': notificationToken
    };
  }

  // Create an object from a map
  factory AuthModel.fromMap(Map<String, dynamic> map) {
    return AuthModel(
        currentUserId: map['currentUserId'],
        userName: map['userName'],
        userEmail: map['userEmail'],
        userAddress: map['userAddress'],
        userPassword: map['userPassword'],
        userPhone: map['userPhone'],
        userImage: map['userImage'],
        chatStatus: map['chatStatus'],
        typingStatus: map['typingStatus'],
        timeStamp: map['timeStamp'],
        notificationToken: map['notificationToken']);
  }
}
