import 'package:flutter/material.dart';
import 'package:todo_project/models/todo.dart';
import 'package:todo_project/pages/controller/todo_controller.dart';
import 'package:todo_project/pages/widgets/custom_app_bar.dart';
import 'package:todo_project/pages/widgets/custom_button.dart';
import 'package:todo_project/pages/widgets/menu_drawer.dart';

class AddTodo extends StatefulWidget {
  final TodoController controller;

  const AddTodo({Key? key, required this.controller}) : super(key: key);

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  bool _completed = false;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newTodo = Todo(
        id: DateTime.now().millisecondsSinceEpoch,
        title: _titleController.text,
        completed: _completed,
      );
      widget.controller.addTodo(newTodo);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tarefa criada com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pushNamedAndRemoveUntil(context, '/allTodos', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Criar tarefa'),
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
                title: 'Adicionar',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
