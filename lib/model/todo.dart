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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Todo && other.title == title && other.checked == checked;
  }

  @override
  int get hashCode => title.hashCode ^ checked.hashCode;
}
