// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:todo_app/Task_Page.dart';
import 'package:todo_app/database_connector.dart';

import 'Task_Widget.dart';

class Home extends StatefulWidget {
   Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DatabaseConnector dbConnector = DatabaseConnector();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade900,
        centerTitle: true,
        title:  const Text("To Do List",
        style: TextStyle(fontSize: 26.0,
        fontWeight: FontWeight.bold,
        ),
        ),
      ),
      body: Container(
        color: Color(0xFFF6F6F6),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 32,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Expanded(
                  child: FutureBuilder(
                    initialData: [],
                    future: dbConnector.getTask(),
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
                                       
                                       await dbconnector.deleteTask(snapshot.data[index].id);
                                       setState(() {
                                       });
                                     },
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute
                                (builder: (context)=> TaskPage(task: snapshot.data[index]),),
                                );
                              },
                              child: taskWidget(
                                title: snapshot.data[index].title,
                                description: snapshot.data[index].description,
                              ),
                            ),
                          );
                        },
                        );
                    },
                  ),
                ),
                        
              ],),
         Positioned(
              bottom: 0.0,
              right: 0.0,
              child: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context)=> TaskPage(task : null) 
                      ),
                  ).then((value) {
                    setState(() {
                      
                    });
                  });
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red.shade900,
                    borderRadius: BorderRadius.circular(20),
                     ),
                     child: const Image(
                       image: AssetImage("assets/add_icon.png"),),
                ),
              ),
            ),
          ],
        ),
        
      ),
    );
  }
}