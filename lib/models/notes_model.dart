class NotesResponse {
  String? key;
  NotesModel? value;

  NotesResponse({this.key, this.value});

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value?.toJson(),
    };
  }
NotesResponse.fromJson(Map<dynamic, dynamic> json) {
    key = json['key'];
    value = NotesModel.fromJson(json['value']);
  }

}

class NotesModel {
   String? userId;
   int? dateTime;
   String? title;
   String? description;
   bool? isPinned;
   String? imagePath;
   String? sharedBy;

  NotesModel({
    required this.userId,
    required this.dateTime,
    this.title,
    required this.description,
    this.isPinned = false,
    this.imagePath,
    this.sharedBy,
  });


  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'dateTime': dateTime,
      'isPinned': isPinned,
      'imagePath': imagePath,
    };
  }

  NotesModel.fromJson(Map<dynamic, dynamic> json) {
    userId = json['userId'];
    title = json['title'];
    description = json['description'];
    dateTime = json['dateTime'];
    isPinned = json['isPinned'];
    imagePath = json['imagePath'];
  }
}