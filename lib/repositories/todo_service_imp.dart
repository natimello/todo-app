import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_project/models/todo.dart';
import 'package:todo_project/repositories/todo_service.dart';

class TodoServiceImp implements TodoService {
  static const String _keyTodos = 'todos';

  @override
  Future<List<Todo>> getAllTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? todosString = prefs.getString(_keyTodos);
    if (todosString != null) {
      List<dynamic> todosJson = jsonDecode(todosString);
      List<Todo> todos = todosJson.map((json) => Todo.fromJson(json)).toList();
      return todos;
    }
    return [];
  }

  @override
  Future<Todo?> getTodo(int todoId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? todosString = prefs.getString(_keyTodos);
    if (todosString != null) {
      List<dynamic> todosJson = jsonDecode(todosString);
      List<Todo> todos = todosJson.map((json) => Todo.fromJson(json)).toList();

      try {
        Todo? foundTodo = todos.firstWhere((todo) => todo.id == todoId);
        return foundTodo;
      } catch (e) {
        throw Exception('Tarefa não encontrada');
      }
    }
    return null;
  }

  @override
  Future<void> addTodo(Todo todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Todo> todos = await getAllTodos();
    todo.id = _generateNextId(todos);
    todos.add(todo);
    await _saveTodos(prefs, todos);
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Todo> todos = await getAllTodos();
    int index = todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      todos[index] = todo;
      await _saveTodos(prefs, todos);
    }
  }

  @override
  Future<void> deleteTodo(int todoId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Todo> todos = await getAllTodos();
    todos.removeWhere((todo) => todo.id == todoId);
    await _saveTodos(prefs, todos);
  }

  int _generateNextId(List<Todo> todos) {
    int maxId = todos.isNotEmpty
        ? todos.map((todo) => todo.id).reduce((a, b) => a > b ? a : b)
        : 0;
    return maxId + 1;
  }

  Future<void> _saveTodos(SharedPreferences prefs, List<Todo> todos) async {
    List<Map<String, dynamic>> todosJson =
        todos.map((todo) => todo.toJson()).toList();
    await prefs.setString(_keyTodos, jsonEncode(todosJson));
  }
}
