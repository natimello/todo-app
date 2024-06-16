import 'package:equatable/equatable.dart';
import 'package:todo_project/models/todo.dart';

enum TodoStatus {
  initial,
  loading,
  success,
  failure,
  todoCreated,
  todoUpdated,
  todoDeleted,
}

class TodoState extends Equatable {
  final TodoStatus status;
  final List<Todo>? allTodos;
  final Todo? todo;

  TodoState({required this.status, this.allTodos, this.todo});

  @override
  List<Object?> get props => [status, allTodos, todo];

  const TodoState._({
    required this.status,
    this.allTodos,
    this.todo,
  });

  TodoState.initial() : this._(status: TodoStatus.initial);

  TodoState copyWith({
    TodoStatus? status,
    List<Todo>? allTodos,
    Todo? todo,
  }) {
    return TodoState._(
      status: status ?? this.status,
      allTodos: allTodos ?? this.allTodos,
      todo: todo ?? this.todo,
    );
  }
}
