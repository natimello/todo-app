import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:todo_project/models/todo.dart';
import 'package:todo_project/pages/controller/todo_controller.dart';
import 'package:todo_project/pages/controller/todo_state.dart';
import 'package:todo_project/pages/edit_todo.dart';
import 'package:todo_project/pages/widgets/custom_app_bar.dart';
import 'package:todo_project/pages/widgets/menu_drawer.dart';

class AllTodos extends StatefulWidget {
  final TodoController controller;

  const AllTodos({Key? key, required this.controller}) : super(key: key);

  @override
  State<AllTodos> createState() => _AllTodosState();
}

class _AllTodosState extends State<AllTodos> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    widget.controller.getAllTodos();
  }

  void _updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Todas as tarefas',
        actions: [
          AnimSearchBar(
            width: 400,
            textController: TextEditingController(),
            onSuffixTap: () {
              setState(() {
                _searchQuery = '';
              });
            },
            onSubmitted: (query) {
              _updateSearchQuery(query);
            },
          ),
        ],
      ),
      drawer: MenuDrawer(),
      body: FutureBuilder<List<Todo>>(
        future: widget.controller.getAllTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.pink[300],
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar as tarefas'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Nenhuma tarefa encontrada'),
            );
          } else {
            List<Todo> todos = snapshot.data!;
            List<Todo> filteredTodos = todos
                .where((todo) => todo.title
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()))
                .toList();

            return ListView.builder(
              itemCount: filteredTodos.length,
              itemBuilder: (context, index) {
                final todo = filteredTodos[index];
                return ListTile(
                  title: Text(todo.title),
                  subtitle: Text(todo.completed ? 'Concluída' : 'Pendente'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.pink[300]),
                        onPressed: () {
                          _deleteTodoAndRefresh(todo.id);
                        },
                      ),
                      Checkbox(
                        value: todo.completed,
                        onChanged: (bool? value) {
                          _updateTodoAndRefresh(todo, value!);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    _showTodoDetailsDialog(context, todo);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  void _deleteTodoAndRefresh(int todoId) async {
    await widget.controller.deleteTodo(todoId);
    setState(() {
      widget.controller.getAllTodos();
    });
  }

  void _updateTodoAndRefresh(Todo todo, bool completed) async {
    todo.completed = completed;
    await widget.controller.updateTodo(todo);
    setState(() {
      widget.controller.getAllTodos();
    });
  }

  void _showTodoDetailsDialog(BuildContext context, Todo todo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detalhes da Tarefa'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Título: ${todo.title}'),
              const SizedBox(height: 8),
              Text('Concluída: ${todo.completed ? "Sim" : "Não"}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Fechar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _editTodoDetails(context, todo);
              },
              child: const Text('Editar'),
            ),
          ],
        );
      },
    );
  }

  void _editTodoDetails(BuildContext context, Todo todo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditTodo(controller: widget.controller, todoId: todo.id),
      ),
    );
  }
}
