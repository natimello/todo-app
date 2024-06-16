import 'package:flutter/material.dart';
import 'package:todo_project/models/todo.dart';
import 'package:todo_project/pages/controller/todo_controller.dart';
import 'package:todo_project/pages/widgets/custom_app_bar.dart';
import 'package:todo_project/pages/widgets/custom_button.dart';
import 'package:todo_project/pages/widgets/menu_drawer.dart';

class EditTodo extends StatefulWidget {
  final TodoController controller;
  final int todoId;

  const EditTodo({
    Key? key,
    required this.controller,
    required this.todoId,
  }) : super(key: key);

  @override
  _EditTodoState createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _loadTodoDetails();
  }

  void _loadTodoDetails() async {
    try {
      Todo? todo = await widget.controller.getTodo(widget.todoId);
      if (todo != null) {
        setState(() {
          _titleController.text = todo.title;
          _completed = todo.completed;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao carregar os detalhes da tarefa'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context); // Voltar para a tela anterior
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao carregar os detalhes da tarefa'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context); // Voltar para a tela anterior
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final updatedTodo = Todo(
        id: widget.todoId,
        title: _titleController.text,
        completed: _completed,
      );
      await widget.controller.updateTodo(updatedTodo);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tarefa atualizada com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pushNamedAndRemoveUntil(context, '/allTodos', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Editar Tarefa'),
      drawer: MenuDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um título';
                  }
                  return null;
                },
              ),
              CheckboxListTile(
                title: const Text('Concluída'),
                value: _completed,
                onChanged: (bool? value) {
                  setState(() {
                    _completed = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                onPressed: _submitForm,
                title: 'Salvar',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
