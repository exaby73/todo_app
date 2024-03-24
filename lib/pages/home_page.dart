import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/pages/create_or_update_todo_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Todo> _data = [];

  @override
  void initState() {
    super.initState();
    final todos = sharedPreferences.getStringList('todos');
    if (todos == null) return;
    _data.addAll(todos.map((e) => Todo.fromJson(jsonDecode(e))).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        actions: [
          IconButton(
            onPressed: () async {
              final String? text =
                  await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const CreateOrUpdateTodoPage();
                },
              ));

              if (text == null) return;

              setState(() {
                _data.add(Todo(
                  title: text,
                  checked: false,
                ));
              });
              
              sharedPreferences.setStringList(
                'todos',
                _data.map((e) => jsonEncode(e.toJson())).toList(),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (context, index) {
          final item = _data[index];
          return ListTile(
            title: Text(item.title),
            onTap: () async {
              final String? text = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return CreateOrUpdateTodoPage(initialValue: item.title);
                  },
                ),
              );
              if (text == null) return;

              setState(() {
                _data[index] = Todo(title: text, checked: item.checked);
              });
              
              sharedPreferences.setStringList(
                'todos',
                _data.map((e) => jsonEncode(e.toJson())).toList(),
              );
            },
            trailing: Checkbox(
              value: item.checked,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _data[index] = Todo(title: item.title, checked: value);
                });
              },
            ),
          );
        },
      ),
    );
  }
}
