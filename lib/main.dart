import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_project/pages/all_todos.dart';
import 'package:todo_project/pages/controller/todo_controller.dart';
import 'package:todo_project/pages/add_todo.dart';
import 'package:todo_project/pages/edit_todo.dart';
import 'package:todo_project/pages/google_maps.dart';
import 'package:todo_project/repositories/todo_service_imp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();

  TodoController controller = TodoController(service: TodoServiceImp());

  runApp(MyApp(controller: controller));
}

class MyApp extends StatelessWidget {
  final TodoController controller;

  const MyApp({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TodoApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/allTodos',
      routes: {
        '/allTodos': (context) => AllTodos(controller: controller),
        '/addTodo': (context) => AddTodo(
              controller: controller,
            ),
        '/editTodo': (context) => EditTodo(controller: controller, todoId: 0),
        '/googleMaps': (context) => const GoogleMaps(),
      },
    );
  }
}
