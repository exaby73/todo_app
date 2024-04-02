import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/state/todo_cubit.dart';
import 'package:todo_app/widgets/todo_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        actions: [
          IconButton(
            onPressed: () => _addTodo(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: const TodoList(),
    );
  }

  void _addTodo(BuildContext context) async {
    final String? text = await Navigator.of(context).pushNamed('/create_or_update') as String?;
    if (!context.mounted || text == null) return;
    context.read<TodoCubit>().add(text);
  }
}
