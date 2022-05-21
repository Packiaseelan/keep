class UserModel {
  String? userId;
  String? userName;
  String? emailId;
  bool? isSelected;

  UserModel({
    required this.userId,
    required this.userName,
    required this.emailId,
    this.isSelected = false
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'emailId': emailId,
    };
  }

  UserModel.fromJson(Map<dynamic, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    emailId = json['emailId'];
  }
}
