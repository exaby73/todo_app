import 'package:todo_app/model/todo.dart';

class TodoState {
  final List<Todo> todos;

  const TodoState({this.todos = const []});

  factory TodoState.fromJson(Map<String, dynamic> json) {
    return TodoState(
      todos: List<Todo>.from(json['todos'].map((x) => Todo.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'todos': todos.map((x) => x.toJson()).toList(),
    };
  }
}
