import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/pages/create_or_update_todo_page.dart';
import 'package:todo_app/state/todo_cubit.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    final todos = context.select((TodoCubit cubit) => cubit.state.todos);
    if (todos.isEmpty) {
      return const Center(
        child: Text('No Todos'),
      );
    }

    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final item = todos[index];
        return Dismissible(
          key: ValueKey(item),
          direction: DismissDirection.endToStart,
          confirmDismiss: (_) => _showDeleteConfirmation(context),
          onDismissed: (_) => context.read<TodoCubit>().remove(index),
          background: const _DismissibleBackground(),
          child: ListTile(
            title: Text(item.title),
            onTap: () => _updateTodo(context, index, item.title),
            trailing: Checkbox(
              value: item.checked,
              onChanged: (_) => context.read<TodoCubit>().toggle(index),
            ),
          ),
        );
      },
    );
  }

  Future<void> _updateTodo(
    BuildContext context,
    int index,
    String initialValue,
  ) async {
    final String? text = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return CreateOrUpdateTodoPage(initialValue: initialValue);
        },
      ),
    );
    if (!context.mounted || text == null) return;
    context.read<TodoCubit>().update(index, text);
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Todo'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class _DismissibleBackground extends StatelessWidget {
  const _DismissibleBackground();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
