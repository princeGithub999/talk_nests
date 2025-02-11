class SqliteUserModel {
  String? roomId;
  String? userName;
  String? senderName;
  String? senderId;
  String? receiverId;
  String? userImageUrl;
  String? timestamp;
  String? onLineStatus;

  SqliteUserModel({
    this.userName,
    this.senderName,
    this.userImageUrl,
    this.timestamp,
    this.senderId,
    this.onLineStatus,
    this.receiverId,
    this.roomId,
  });

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'senderName': senderName,
      'imageUrl': userImageUrl,
      'timestamp': timestamp,
      'senderId': senderId,
      'onLineStatus': onLineStatus,
      'receiverId': receiverId,
      'roomId': roomId,
    };
  }

  factory SqliteUserModel.fromMap(Map<String, dynamic> map) {
    return SqliteUserModel(
      userName: map['userName'] as String,
      senderName: map['senderName'],
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      userImageUrl: map['imageUrl'],
      onLineStatus: map['onLineStatus'],
      timestamp: map['timestamp'],
      roomId: map['roomId'],
    );
  }
}
