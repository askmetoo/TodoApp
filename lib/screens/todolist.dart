import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'package:todo_app/screens/tododetail.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TodoListState();
}

class TodoListState extends State {
  DbHelper helper = DbHelper();
  List<Todo> todos;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (todos == null) {
      todos = List<Todo>();
      getData();
    }
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 246, 246),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: todoListItems(),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigateToDetail(Todo('',3,''));
          },
          tooltip: "Add new Todo",
          child: new Icon(
            Icons.add,
            size: 35.0,
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  ListView todoListItems() {
    return ListView.builder(
        padding: EdgeInsets.only(top: 10.0),
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 235, 235, 243),
                      blurRadius: 10.0,
                      spreadRadius: -9.0,
                      offset: Offset(0.0, 7.0)),
                ],
              ),
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Colors.white,
                  elevation: 0.0,
                  child: ListTile(
                    // TODO: Find the way to align this avatar to top left corner
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 17.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 7.0,
                            backgroundColor: getColor(this.todos[position].priority),
                          ),
                          SizedBox(
                            height: 57.0,
                          ),
                        ],
                      ),
                    ),

                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        this.todos[position].title,
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.w800),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          this.todos[position].description,
                          style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black38),
                        ),
                        SizedBox(
                          height: 15.0,
                        ), // it smell
                        Text(
                          'Deadline ' +
                              this.todos[position].date.substring(10, 16),
                          style: TextStyle(
                              fontSize: 11.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black38),
                        ),
                      ],
                    ),
                    contentPadding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 20.0),
                    // contentPadding: EdgeInsets.zero,
                    isThreeLine: true,
                    onTap: () {
                      debugPrint(
                          "Tapped on " + this.todos[position].id.toString());
                      navigateToDetail(this.todos[position]);
                    },
                  )),
            ),
          );
        });
  }

  void getData() {
    final dbFuture = helper.initalizeDb();
    dbFuture.then((result) {
      final todosFuture = helper.getTodos();
      todosFuture.then((result) {
        List<Todo> todoList = List<Todo>();
        count = result.length;
        for (int i = 0; i < count; i++) {
          todoList.add(Todo.fromObject(result[i]));
          debugPrint(todoList[i].title);
        }
        setState(() {
          todos = todoList;
          count = count;
        });
        debugPrint("Items: " + count.toString());
      });
    });
  }

  Color getColor(int priority) {
    switch(priority){
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.amber;
        break;
      case 3:
        return Colors.lime;
        break;

      default:
        return Colors.lime;
    }
  }

  void navigateToDetail(Todo todo) async {
    bool result = await Navigator.push(context, 
      MaterialPageRoute(builder: (context) => TodoDetail(todo)),
    );
    
  }

}
