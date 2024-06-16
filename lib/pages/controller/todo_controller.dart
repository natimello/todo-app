import 'package:bloc/bloc.dart';
import 'package:todo_project/models/todo.dart';
import 'package:todo_project/pages/controller/todo_state.dart';
import 'package:todo_project/repositories/todo_service.dart';

class TodoController extends Cubit<TodoState> {
  final TodoService service;

  TodoController({required this.service}) : super(TodoState.initial());

  Future<List<Todo>> getAllTodos() async {
    try {
      List<Todo> allTodos = await service.getAllTodos();
      emit(state.copyWith(status: TodoStatus.success, allTodos: allTodos));
      return allTodos;
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.failure));
      rethrow;
    }
  }

  Future<Todo?> getTodo(int todoId) async {
    try {
      Todo? todo = await service.getTodo(todoId);
      emit(state.copyWith(status: TodoStatus.success, todo: todo));
      return todo;
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.failure));
      return null;
    }
  }

  Future<void> addTodo(Todo todo) async {
    try {
      await service.addTodo(todo);
      emit(state.copyWith(status: TodoStatus.todoCreated));
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.failure));
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      await service.updateTodo(todo);
      emit(state.copyWith(
        status: TodoStatus.todoUpdated,
        allTodos: _updateTodoList(state.allTodos!, todo),
      ));
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.failure));
    }
  }

  Future<void> deleteTodo(int todoId) async {
    try {
      await service.deleteTodo(todoId);
      emit(state.copyWith(
        status: TodoStatus.todoDeleted,
        allTodos: state.allTodos!.where((todo) => todo.id != todoId).toList(),
      ));
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.failure));
    }
  }

  List<Todo> _updateTodoList(List<Todo> todos, Todo updatedTodo) {
    return todos
        .map((todo) => todo.id == updatedTodo.id ? updatedTodo : todo)
        .toList();
  }
}
