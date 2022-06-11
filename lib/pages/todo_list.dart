import 'package:flutter/material.dart';
import 'package:my_todo/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'todo_detail.dart';
import 'package:my_todo/models/todo.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Todo> todoList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateListView();
    // print(todoList.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getTodosListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Todo('', '', ''), 'Adicionar');
        },
        tooltip: '+ 1 A fazer',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget getTodosListView() {
    if (todoList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 12),
        child: Center(
          child: Column(
            children: [
              const Text("Adicione algum item para poder visualizados aqui."),
              OutlinedButton(
                onPressed: () {
                  navigateToDetail(Todo('', '', ''), 'Adicionar');
                },
                child: const Text("Adicionar"),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: todoList.length,
      itemBuilder: (context, index) {
        Todo todo = todoList[index];

        return Card(
          child: ListTile(
            leading: const FlutterLogo(size: 72.0),
            title: Text(todo.title),
            subtitle: Text(todo.description),
            isThreeLine: true,
            onTap: () {
              navigateToDetail(todo, 'Update');
            },
          ),
        );
      },
    );
  }

  getAvatar(String title) {
    if (title.length < 2) {
      return '';
    } else {
      return title.substring(0, 2);
    }
  }

  void _delete(BuildContext context, Todo todo) async {
    // int result = await databaseHelper.deleteTodo(todo.id);
    int result = 0;

    if (result != 0) {
      _showSnackBar(context, 'Deletado...');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Todo>> todoListFuture = databaseHelper.getTodoList();
      todoListFuture.then((todoList) {
        setState(() {
          this.todoList = todoList;
        });
      });
    });
  }

  void navigateToDetail(Todo todo, String title) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      debugPrint("Chamou a segunda tela");
      return TodoDetail(todo, title);
    })).then((result) {
      if (result ?? true) {
        updateListView();
      }
    });
  }
}
