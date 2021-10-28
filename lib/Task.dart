// ignore_for_file: file_names

class Task{
   int? id;
   String? title;
   String? description;
   Task({this.id, this.title, this.description});

  Map<String,dynamic> toMap(){
    return {
    'id': id,
    'title': title,
    'description' : description
    };
  }
}