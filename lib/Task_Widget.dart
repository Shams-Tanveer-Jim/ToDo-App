    // ignore_for_file: file_names

    import 'package:flutter/material.dart';
    import 'package:cupertino_icons/cupertino_icons.dart';

import 'database_connector.dart';

    class taskWidget extends StatelessWidget {
      
       String? title;
       String? description;

      taskWidget({this.title,this.description});
    
      @override
      Widget build(BuildContext context) {
        return Container(
          margin: EdgeInsetsDirectional.only(bottom: 20),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 32,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              Text( title ?? "(Unnamed Task)" ,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
               ),
              ),
              Text( description ?? "No Description",
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
               ),
              ),
            ],
          ),
        );
      }
    }

    class todoWidget extends StatefulWidget {
      String? checkBoxTitle ;
      bool? isDone;
      int? id;
      int? taskId;
     // dynamic item;

      todoWidget({this.id,this.taskId,this.checkBoxTitle,this.isDone});  

      @override
      State<todoWidget> createState() => _todoWidgetState();
}

class _todoWidgetState extends State<todoWidget> {
      @override
      Widget build(BuildContext context) {
        return Column(
          children: [
            Container(  
              height: 75,
              padding: EdgeInsets.only(top:5),
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                 BoxShadow(color: Colors.blueGrey.shade700 ,
                offset: Offset(4.0,4.0),
                blurRadius: 5,
                spreadRadius: .5,
                ),
                BoxShadow(color: Colors.white54,
                offset: Offset(-4.0,-4.0),
                blurRadius: 5,
                spreadRadius: .5,
                ),
              ]
            ),
              child: CheckboxListTile(
                activeColor: Colors.red.shade900,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(widget.checkBoxTitle ?? "Unnamed Todo",
                style: const TextStyle(fontSize: 24,
                fontWeight: FontWeight.w600),),
                value: widget.isDone ?? false,
                onChanged: (value)async{
                  DatabaseConnector dbconnector = DatabaseConnector ();
                    await dbconnector.UpdateTodoCheckBox(widget.id!, widget.taskId!,value== true ? 1 : 0);
                  setState(() {
                    widget.isDone = value!;
                    
                  });
                } ,
                ),
            ),
            SizedBox(height: 10,)
          ],
        );
      }
}