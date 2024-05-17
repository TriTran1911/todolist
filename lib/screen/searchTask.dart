import 'package:flutter/material.dart';

import '../widget/task.dart';

class TaskSearch extends SearchDelegate<Task> {
  final TaskProvider taskProvider;

  TaskSearch({required this.taskProvider});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, Task());
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Task> suggestions = taskProvider.tasks
        .where(
            (task) => task.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final task = suggestions[index];
        return Card(
          elevation: 3,
          color: Colors.white,
          surfaceTintColor: Colors.blue,
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ListTile(
            title: Text(
              task.title!,
              style: TextStyle(
                decoration: task.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: Text(
              'Due: ${task.dueDate!.day}-${task.dueDate!.month}-${task.dueDate!.year} at  ${task.dueDate!.hour}:${task.dueDate!.minute}',
            ),
            onTap: () {
              close(context, task);
            },
          ),
        );
      },
    );
  }
}
