class SharedWithModel {
  String? userId;
  String? noteId;

  SharedWithModel({
    required this.userId,
    required this.noteId,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'noteId': noteId,
    };
  }

  SharedWithModel.fromJson(Map<dynamic, dynamic> json) {
    userId = json['userId'];
    noteId = json['noteId'];
  }
}
