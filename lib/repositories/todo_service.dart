import 'package:todo_project/models/todo.dart';

abstract class TodoService {
  Future<List<Todo>> getAllTodos();
  Future<Todo?> getTodo(int todoId);
  Future<void> addTodo(Todo todo);
  Future<void> updateTodo(Todo todo);
  Future<void> deleteTodo(int todoId);
}
