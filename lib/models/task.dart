class Task {

  Task({required this.title, required this.createDate});

  Task.fromJson(Map<String, dynamic> json)
  :title = json['title'],
  createDate = DateTime.parse(json['createdate']);

  String title;
  DateTime createDate;

  Map<String, dynamic> toJson(){
    return{
      'title': title,
      'createDate': createDate.toIso8601String(),
    };
  }
}