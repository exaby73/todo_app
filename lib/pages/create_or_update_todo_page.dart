import 'package:flutter/material.dart';

class CreateOrUpdateTodoPage extends StatefulWidget {
  const CreateOrUpdateTodoPage({super.key, this.initialValue});

  final String? initialValue;

  @override
  State<CreateOrUpdateTodoPage> createState() => _CreateOrUpdateTodoPageState();
}

class _CreateOrUpdateTodoPageState extends State<CreateOrUpdateTodoPage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.initialValue == null ? 'Create Todo' : 'Update Todo';
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop(_controller.text);
        },
        child: const Icon(Icons.save),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Title',
            border: OutlineInputBorder(),
            filled: true,
          ),
          onFieldSubmitted: (value) {
            Navigator.of(context).pop(value);
          },
        ),
      ),
    );
  }
}
