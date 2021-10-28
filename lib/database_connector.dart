import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'ToDo.dart';
import 'Task.dart';

class DatabaseConnector{
Future<Database> database() async{
  return openDatabase(
    join(await getDatabasesPath(), 'todolist.db'),
    onCreate: (db, version) async {
    return db.execute(
      'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)');

   },
    version: 1,
  );
}

Future<Database> Tododatabase() async{
  return openDatabase(
    join(await getDatabasesPath(), 'todolist1.db'),
    onCreate: (db, version) async {
    return db.execute(
      'CREATE TABLE todo(id INTEGER PRIMARY KEY,taskId INTEGER, title TEXT, isDone INTEGER)');

   },
    version: 1,
  );
}

Future<int> insertTask(Task task) async{
  int taskID =0;
  Database _db = await database();

  await _db.insert("tasks", task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace).then((value){
    taskID = value;
  });
  return taskID;
}

Future<void> insertTodo(ToDo todo) async{
  Database _db = await Tododatabase();

  _db.insert("todo", todo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

}

Future<void> UpdateTaskName(int id,String newName) async{
  Database _db = await database();
  String sql =" Update tasks set title ='$newName' where id= '$id'";
  _db.rawQuery(sql);

}

Future<void> UpdateTaskDescription(int id,String descrip) async{
  Database _db = await database();
  String sql =" Update tasks set description='$descrip' where id= '$id'";
  await _db.rawQuery(sql);
}

Future<void> UpdateTodoCheckBox(int id,int parentId, int checkboxValue) async{
  Database _db = await Tododatabase();
  String sql =" Update todo set isDone='$checkboxValue' where id= '$id' and taskId='$parentId'";
  await _db.rawQuery(sql);
}

Future<List<Task>> getTask() async{
  Database _db = await database();
  List <Map<String, dynamic>> taskMap = await _db.query('tasks');
  return List.generate(taskMap.length,(index){
    return Task(id: taskMap[index]['id'],title: taskMap[index]['title'],
    description: taskMap[index]['description']);
  });

} 

Future<List<ToDo>> getTodo(int taskID) async{
  Database _db = await Tododatabase();
  String sql="SELECT *FROM todo WHERE taskId = '$taskID'";
  List <Map<String, dynamic>> todoMap = await _db.rawQuery(sql);
  return List.generate(todoMap.length,(index){
    return ToDo(id: todoMap[index]['id'],
    taskId: todoMap[index]['taskId'],
    title: todoMap[index]['title'],
    isDone: todoMap[index]['isDone']);
  });

} 

Future<void> deleteTodo(int id, int parentid)async {
  Database _db = await Tododatabase();
  String sql ="DELETE FROM todo WHERE id= '$id' and taskId = '$parentid'";
  await _db.rawDelete(sql);
}

Future<void> deleteTask(int id)async {
  Database _db = await database();
  String sql ="DELETE FROM tasks WHERE id = '$id'";
  await _db.rawDelete(sql);

  Database _db1 = await Tododatabase();
  String sql1 ="DELETE FROM todo WHERE taskId = '$id'";
  await _db1.rawDelete(sql1);
}

}