import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/pages/create_or_update_todo_page.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = useState<List<Todo>>([]);

    useEffect(
      () {
        final todos = sharedPreferences.getStringList('todos');
        if (todos == null) return;
        data.value = todos.map((e) => Todo.fromJson(jsonDecode(e))).toList();
        return null;
      },
      const [],
    );

    useEffect(
      () {
        sharedPreferences.setStringList(
          'todos',
          data.value.map((e) => jsonEncode(e.toJson())).toList(),
        );
        return null;
      },
      [data.value],
    );

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

              data.value = [
                ...data.value,
                Todo(
                  title: text,
                  checked: false,
                )
              ];
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: data.value.length,
        itemBuilder: (context, index) {
          final item = data.value[index];
          return Dismissible(
            key: ValueKey(item),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
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
            },
            onDismissed: (_) {
              data.value = [
                for (final i in data.value)
                  if (i == item) ...[] else i,
              ];
            },
            background: const ColoredBox(
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
            ),
            child: ListTile(
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

                data.value = [
                  for (final i in data.value)
                    if (i == item)
                      Todo(
                        title: text,
                        checked: i.checked,
                      )
                    else
                      i,
                ];
              },
              trailing: Checkbox(
                value: item.checked,
                onChanged: (value) {
                  if (value == null) return;
                  data.value = [
                    for (final i in data.value)
                      if (i == item)
                        Todo(
                          title: item.title,
                          checked: value,
                        )
                      else
                        i,
                  ];
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
