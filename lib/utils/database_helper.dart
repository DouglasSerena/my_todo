import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:my_todo/models/todo.dart';
import 'package:path_provider/path_provider.dart';



class DatabaseHelper{
  //singleton

  static  DatabaseHelper? _databaseHelper;// SINGLETON
  static Database? _database;

  /////aplicando o singleton
  DatabaseHelper._createInstancia();//construtor

  factory DatabaseHelper(){
    if(_databaseHelper == null){
      _databaseHelper = DatabaseHelper._createInstancia();
    }
    return _databaseHelper!;
  }

/////terminado o singleton

///tabela que vamos criar
String todoTable = 'todo_table';
String colId = 'id';
String colTitle = 'title';
String colDesc = 'desc';
String colDate= 'date';

///
  /// TODO AUTO OU AUTOINCREMENT
void _createDb(Database db, int newVersion) async{
  await db.execute('Create table $todoTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDesc TEXT, $colDate TEXT)');
}

Future<Database> initializeDatabase() async{
  Directory diretorio= await getApplicationDocumentsDirectory();
  String path= diretorio.path+"todo.db";
  var todoDatabase = await openDatabase(path,version: 1,onCreate: _createDb);
  return todoDatabase;

}

Future<Database> get database async{
  if(_database ==null){
    _database = await initializeDatabase();
  }
  return _database!;
}

///CRUD
///Create
///READE
///Update
///DeleTE
///
///INSERT
Future<int> insertTodo(Todo todo) async{
  Database db = await this.database;
  var result = db.insert(todoTable, todo.toMap());
  return result;
}
Future<int> updateTodo(Todo todo) async {
  Database db = await this.database;
  var result = db.update(
      todoTable, todo.toMap(), where: '$colId =?', whereArgs: [todo.id]);
  //var result2 = db.query("UPDATE from.................... where id=id");
  //db.insert(todoTable, todo.toMap(), conflictAlgorithm:ConflictAlgorithm.replace);
  return result;
}
Future<int> deleteTodo(int id) async{
  Database db= await this.database;
  int result = await db.rawDelete("Delete from $todoTable where $colId=$id");
  return result;
}

Future<List<Map<String,dynamic>>> getTodoMapList() async{
  Database db= await this.database;
  var result=await db.query(todoTable, orderBy: "$colTitle ASC");
  return result;
}

Future<List<Todo>> getTodoList() async{
  var todoMapList = await getTodoMapList();
  int count= todoMapList.length;
  List<Todo> todoList= <Todo>[];
  for(int i=0; i<count; i++){
    todoList.add(Todo.fromMapObject(todoMapList[i]));
  }
  return todoList;
}

Future <int> getCount() async{
  var todoMapList = await getTodoMapList();
  int count = todoMapList.length;
  return count;

}

}


