import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CreateOrUpdateTodoPage extends HookWidget {
  const CreateOrUpdateTodoPage({super.key, this.initialValue});

  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: initialValue);
    final title = initialValue == null ? 'Create Todo' : 'Update Todo';

    final focusNode = useFocusNode();
    useEffect(
      () {
        focusNode.requestFocus();
        return null;
      },
      const [],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _popWithResult(context, controller.text),
        child: const Icon(Icons.save),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: const InputDecoration(
            labelText: 'Title',
            border: OutlineInputBorder(),
            filled: true,
          ),
          onFieldSubmitted: (value) => _popWithResult(context, value),
        ),
      ),
    );
  }

  void _popWithResult(BuildContext context, String value) {
    if (value.isEmpty) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(content: Text('Title is required.')),
        );
      return;
    }
    Navigator.of(context).pop(value);
  }
}
