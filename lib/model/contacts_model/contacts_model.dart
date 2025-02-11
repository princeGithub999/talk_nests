class ContactsModel {
  String? userId;
  String? userName;
  int? contactNumber;
  String? userImage;
  String? userEmail;
  String? notificationToken;

  ContactsModel(
      {this.userId,
      this.userName,
      this.contactNumber,
      this.userImage,
      this.userEmail,
      this.notificationToken});

  factory ContactsModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return ContactsModel(
        userId: map['userId'],
        userName: map['userName'],
        contactNumber: map['contactNumber'],
        userImage: map['userImage'],
        userEmail: map['userEmail'],
        notificationToken: map['notificationToken']);
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'contactNumber': contactNumber,
      'userImage': userImage,
      'userEmail': userEmail,
      'notificationToken': notificationToken
    };
  }
}
