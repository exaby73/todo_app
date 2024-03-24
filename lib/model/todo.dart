class Todo {
  final String title;
  final bool checked;

  Todo({
    required this.title,
    required this.checked,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      checked: json['checked'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'checked': checked,
    };
  }
}
