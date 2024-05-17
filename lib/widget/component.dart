import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'task.dart';

void showDeleteTaskDialog(BuildContext context, Task task) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Remove Task'),
        content: const Text('Are you sure you want to remove this task?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false)
                  .deleteTask(task);
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
        ],
      );
    },
  );
}
