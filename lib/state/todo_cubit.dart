import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/state/todo_state.dart';

class TodoCubit extends HydratedCubit<TodoState> {
  TodoCubit() : super(const TodoState());

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
  TodoState? fromJson(Map<String, dynamic> json) {
    return TodoState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(TodoState state) {
    return state.toJson();
  }
}
