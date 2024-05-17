import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widget/notification.dart';
import 'widget/task.dart';
import 'screen/taskList.dart';
  
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationManage.init();
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TaskListScreen(),
    );
  }
}
