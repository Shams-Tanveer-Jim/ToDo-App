// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:todo_app/HomePageWidget.dart';
import 'package:todo_app/Task_Widget.dart';
import 'package:todo_app/ToDo.dart';
import 'package:todo_app/database_connector.dart';

import 'Task.dart';

class TaskPage extends StatefulWidget {
  
  Task? task;
  TaskPage({required this.task});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
String _taskTitle ="";
String _taskDescription ="";
int _taskId = 0;
int parentId =0;
late FocusNode titleFocus;
late FocusNode descriptionFocus;
late FocusNode todoFocus;
bool contentvisibility = false;

TextEditingController taskName_controller = TextEditingController();
TextEditingController taskDesc_controller = TextEditingController();
TextEditingController todoName_controller = TextEditingController();
DatabaseConnector dbConnector = DatabaseConnector();


@override
  void initState() {

    if(widget.task != null){
      contentvisibility = true;
      _taskTitle = widget.task!.title!;
      parentId = widget.task!.id!;
      if(widget.task!.description != null){
       _taskDescription = widget.task!.description!;
      }
      
    }
    titleFocus =FocusNode();
    descriptionFocus = FocusNode();
    todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleFocus.dispose();
    descriptionFocus.dispose();
    todoFocus.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
              Navigator.push(context, MaterialPageRoute
                              (builder: (context)=> Home(),)
                              ).then((value){
                                setState(() {
                                  
                                });
                              });
              
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.red.shade900,
        title:  const Text("To Do List",
        style: TextStyle(fontSize: 26.0,
        fontWeight: FontWeight.bold,
        ),
        ),
      ),

      body:Stack(
        children: [
          Container(
            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Expanded(
                   child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Column(
                      children:  [
                           TextField(
                             focusNode: titleFocus,
                             onSubmitted: (value) async{
                                 DatabaseConnector dbconnector = DatabaseConnector ();
                                 if(value !="")
                                 {

                                   if(widget.task == null)
                                   {
                                     Task _new = Task(
                                                  title: value,
                                
                                                );
                                    _taskId = await dbconnector.insertTask(_new);
                                   setState(() {
                                     contentvisibility = true;
                                     _taskTitle = value ;
                                   });
                                   }
                                   else{
                                     await dbconnector.UpdateTaskName(widget.task!.id!,taskName_controller.text);
                                   }
                                 }
                                 descriptionFocus.requestFocus();
                             },
                             controller: taskName_controller..text = _taskTitle,
                           
                            decoration: const InputDecoration(
                              hintText: "Enter Task Name",
                              border: InputBorder.none,
                            ),
                            
                            style: const TextStyle(color: Colors.black,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            ),
                            ), 

                          Divider(
                        thickness: 2,
                        endIndent: 10,
                        color: Colors.grey.shade900,
                          ),

                       const SizedBox(height: 1,),
                          Visibility(
                            visible: contentvisibility,
                            child: TextField(
                              focusNode: descriptionFocus,
                              onSubmitted: (value) async{
                                DatabaseConnector dbconnector = DatabaseConnector ();
                                 if(widget.task !=null){
                                 await dbconnector.UpdateTaskDescription(widget.task!.id!,value);
                                 }else{
                                  await dbconnector.UpdateTaskDescription(_taskId,value); 
                                 }
                                 setState(() {
                                   _taskDescription = value;
                                 });
                                todoFocus.requestFocus();

                              },
                              controller: taskDesc_controller..text= _taskDescription,
                            decoration: const InputDecoration(
                            hintText: "Enter description for the task",
                            border: InputBorder.none,
                        ),
                        style: const TextStyle(color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        ),
                        ),
                          ),
                        Visibility(
                          visible: contentvisibility,
                          child: Expanded(
                            child: FutureBuilder(
                             initialData: [],
                             future: widget.task == null ? dbConnector.getTodo(_taskId) : dbConnector.getTodo(widget.task!.id!),
                             builder:  (context,AsyncSnapshot snapshot){
                               return ListView.builder(
                                 itemCount: snapshot.data.length,
                                 itemBuilder: (context,index)
                                 {
                                   return Dismissible(
                                     key: ObjectKey(snapshot.data[index]),
                                     background: swipeActionRight(),
                                     direction: DismissDirection.endToStart,
                                     onDismissed: (direction) async{
                                       DatabaseConnector dbconnector = DatabaseConnector ();
                                       
                                       await dbconnector.deleteTodo(snapshot.data[index].id,snapshot.data[index].taskId,);
                                       setState(() {
                                       });
                                     },
                                   child: todoWidget(
                                     id: snapshot.data[index].id,
                                     taskId: snapshot.data[index].taskId,
                                    checkBoxTitle: snapshot.data[index].title,
                                    isDone: snapshot.data[index].isDone== 0 ? false : true,
                                   ),);
                                 },
                                 );
                             },
                  ),
                          ),
                        ),
                        Visibility(
                          visible: contentvisibility,
                          child: Row(
                             children: [
                               Container(
                                 width: 30,
                                 height: 30,
                                 margin: EdgeInsets.only(left: 5,right: 12),
                                 decoration: BoxDecoration(
                                   border: Border.all(
                                     color: Colors.black,
                                     width: 2.5
                                   ),
                                   borderRadius: BorderRadius.circular(20)
                                 ),
                                 
                               ),
                                Expanded(
                                 child: TextField(
                                   focusNode: todoFocus,
                                   controller: todoName_controller,
                                   decoration: const InputDecoration(
                                     hintText: "What to do",
                                     border: InputBorder.none,
                                   ),
                                   style: const TextStyle(
                                     fontSize: 26,
                                     color: Colors.black,
                                     fontWeight: FontWeight.bold),
                                 ),
                               ),
                               Padding(
                                 padding: const EdgeInsets.only(right: 10.0),
                                 child: Container(
                                  
                                  
                                   decoration: BoxDecoration(
                                     color: Colors.grey,
                                     border: Border.all(
                                       color: Colors.black,
                                       width: 2.5
                                     ),
                                     borderRadius: BorderRadius.circular(10)
                                   ),
                                   

                                   child: IconButton(
                                     onPressed: () async {
                                       if(todoName_controller.text != null){
                                           DatabaseConnector dbconnector = DatabaseConnector();
                                            
                                            if(widget.task ==  null){
                                            ToDo _new = ToDo(
                                                         title: todoName_controller.text,
                                                         isDone: 0,
                                                         taskId: _taskId,
                                                       );
                                                       await dbconnector.insertTodo(_new);
                                            }else{
                                              ToDo _new = ToDo(
                                                         title: todoName_controller.text,
                                                         isDone: 0,
                                                         taskId: widget.task!.id,
                                                       );
                                                       await dbconnector.insertTodo(_new);

                                            }
                                           
                                           setState(() {
                                           });
                                          }
                                          
                                     }, icon: const Icon(Icons.arrow_upward_outlined,
                                     size: 35,),
                                   ),

                                 ),
                               )
                             ],
                           ),
                        ),
                      ],
                      
                    ),
                ),
                 ),
                
              ],
              ),
              ),
            
        ],
      ),
    );
  }


}

  Widget swipeActionRight(){
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: Colors.red,
      child: Icon(Icons.delete_forever,color: Colors.white,size: 50,),
    );

  }