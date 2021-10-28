// ignore_for_file: file_names

class ToDo{
  int? id;
  int? taskId;
   String? title;
   int? isDone;
   ToDo({this.id,this.taskId, this.title, this.isDone});

  Map<String,dynamic> toMap(){
    return {
    'id': id,
    'taskId': taskId,
    'title': title,
    'isDone' : isDone
    };
  }
}