import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/state/todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit({required this.sharedPreferences}) : super(const TodoState()) {
    final todos = sharedPreferences.getStringList('todos');
    if (todos == null) return;
    emit(
      TodoState(
        todos: todos.map((e) => Todo.fromJson(jsonDecode(e))).toList(),
      ),
    );
  }

  final SharedPreferences sharedPreferences;

  void add(String title) {
    if (title.isEmpty) return;
    final todo = Todo(title: title, checked: false);
    emit(TodoState(
      todos: [todo, ...state.todos],
    ));
  }

  void update(int index, String title) {
    if (title.isEmpty) return;
    emit(
      TodoState(
        todos: [
          for (int i = 0; i < state.todos.length; i++)
            if (i == index)
              Todo(
                title: title,
                checked: state.todos[i].checked,
              )
            else
              state.todos[i],
        ],
      ),
    );
  }

  void toggle(int index) {
    emit(
      TodoState(
        todos: [
          for (int i = 0; i < state.todos.length; i++)
            if (i == index)
              Todo(
                title: state.todos[i].title,
                checked: !state.todos[i].checked,
              )
            else
              state.todos[i],
        ],
      ),
    );
  }

  void remove(int index) {
    emit(
      TodoState(
        todos: [
          for (int i = 0; i < state.todos.length; i++)
            if (i != index) state.todos[i],
        ],
      ),
    );
  }

  @override
  void onChange(Change<TodoState> change) {
    super.onChange(change);
    final data = change.nextState;
    sharedPreferences.setStringList(
      'todos',
      data.todos.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }
}
