import 'package:flutter/material.dart';

import 'notification.dart';

class Task {
  int? id;
  String? title;
  bool isDone;
  DateTime? dueDate;

  Task({this.id, this.title, this.isDone = false, this.dueDate});
}

class TaskProvider extends ChangeNotifier {
  List<Task> tasks = [];

  List<Task> get getTasks => tasks;

  void addTask(Task task) {
    tasks.add(task);
    if (DateTime.now().isBefore(task.dueDate!.add(Duration(
        minutes: task.dueDate!.difference(DateTime.now()).inMinutes)))) {
      NotificationManage.pushNotification(
        title: 'Create task success!',
        body: 'Your task ${task.title!} is due before 10 minutes.',
      );
    } else {
      NotificationManage.scheduleNotification(
        id: task.id!,
        title: 'Task Reminder',
        body: 'Your task ${task.title!} is due in 10 minutes.',
        scheduledDate: task.dueDate!.subtract(const Duration(seconds: 10)),
      );
    }
    notifyListeners();
  }

  void toggleTask(Task task) {
    task.isDone = !task.isDone;
    notifyListeners();
  }

  void deleteTask(Task task) {
    tasks.remove(task);
    notifyListeners();
  }

  List<Task> getTasksByFilter(String filter) {
    DateTime now = DateTime.now();
    switch (filter) {
      case 'All':
        return tasks;
      case 'Today':
        return tasks.where((task) {
          return task.dueDate != null &&
              task.dueDate!.day == now.day &&
              task.dueDate!.month == now.month &&
              task.dueDate!.year == now.year;
        }).toList();
      case 'Upcoming':
        return tasks.where((task) {
          return task.dueDate != null &&
              task.dueDate!.isAfter(now) &&
              task.dueDate!.day != now.day &&
              task.dueDate!.month != now.month &&
              task.dueDate!.year != now.year;
        }).toList();
      default:
        return tasks;
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }
}
