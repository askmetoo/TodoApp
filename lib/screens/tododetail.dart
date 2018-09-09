import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'package:intl/intl.dart';

DbHelper helper = DbHelper();

class TodoDetail extends StatefulWidget {
  final Todo todo;
  TodoDetail(this.todo);

  @override
  State<StatefulWidget> createState() => TodoDetailState(todo);
}

class TodoDetailState extends State<TodoDetail> {
  Todo todo;
  final _priorities = ["High", "Medium", "Low"];
  String _priority = "Low";
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit;

  void initState() {
    super.initState();
    isEdit = todo.title == '' ? false : true;
    titleController.text = todo.title;
    descriptionController.text = todo.description;
  }

  TodoDetailState(this.todo);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      fontSize: 16.0,
      color: Colors.black54,
      fontWeight: FontWeight.w600,
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.indigoAccent,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 0.0),
        child: Column(
          children: <Widget>[
            Text(
              isEdit ? "Edit the plan" : "Add the plan",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0,
                  color: Colors.white),
            ),
            SizedBox(
              height: 40.0,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
              child: Text(
                "Fill the form below, plan something creative and worth doing. ",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15.0,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black38,
                      blurRadius: 15.0,
                      spreadRadius: -5.0,
                      offset: Offset(0.0, 7.0)),
                ],
              ),
              width: 320.0,
              height: 370.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 25.0, vertical: 15.0),
                child: ListView(
                  children: <Widget>[
                    TextField(
                      onChanged: (value) {
                        todo.title = titleController.text;
                      },
                      keyboardType: TextInputType.text,
                        controller: titleController,
                        style: textStyle,
                        decoration: InputDecoration(
                          hintText: 'Title',
                          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                          labelStyle: textStyle,
                        )),
                    SizedBox(height: 10.0,),
                    TextField(
                      onChanged: (value) {
                        todo.description = descriptionController.text;
                      },
                      keyboardType: TextInputType.text,
                        controller: descriptionController,
                        style: textStyle,
                        decoration: InputDecoration(
                          hintText: 'Specific content',
                          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                          labelStyle: textStyle,
                        )),
                    SizedBox(height: 10.0,),
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Priority',
                        contentPadding: EdgeInsets.zero,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          items: _priorities.map((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          style: textStyle,
                          value: retrievePriority(todo.priority),
                          onChanged: (value)=>updatePriority(value),
                        ),
                      ),
                    ),
                    SizedBox(height: 50.0,),
                    RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      padding: EdgeInsets.all(13.0),
                      elevation: 2.0,
                      textColor: Colors.white,
                      color: Colors.amber,
                      onPressed: () => save(),
                      child: Text(isEdit ? "Edit" : "Add",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600
                      ),),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            debugPrint("Click Floated Back.");
            helper.deleteTodo(todo.id);
            Navigator.pop(context, true);
          },
          elevation: 5.0,
          backgroundColor: Colors.red,
          tooltip: "Cancel",
          child: new Icon(
            Icons.clear,
            size: 35.0,
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void save()  {
    todo.date = new DateFormat.yMd().format(DateTime.now());
    if (todo.id != null) {
      helper.updateTodo(todo);
    } else {
      helper.insertTodo(todo);
    }
    Navigator.pop(context, true);
  }

  void updatePriority(String value) {
    switch(value) {
      case 'High':
        todo.priority = 1;
        break;
      case 'Medium':
        todo.priority = 2;
        break;
      case 'Low':
        todo.priority = 3;
        break;
    }

    setState(() {
          _priority = value;
        });
  }

  String retrievePriority(int value) {
    return _priorities[value - 1];
  }

  void updateTitle(){
    setState(() {
          todo.title = titleController.text;
        });
  }

  void updateDescription(){
    setState(() {
       todo.description = descriptionController.text;
          
        });
  }

}

