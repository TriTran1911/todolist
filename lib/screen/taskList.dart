import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../widget/component.dart';
import 'searchTask.dart';
import '../widget/task.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _selectedFilter = 'All';
  bool isSelected = false;
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');
  final DateFormat _timeFormat = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('To-Do List'),
        backgroundColor: Colors.blue[50],
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: DropdownButton<String>(
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              underline: const SizedBox(),
              value: _selectedFilter,
              items: <String>['All', 'Today', 'Upcoming']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0))
                      .animate()
                      .fadeIn(),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFilter = newValue!;
                });
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: TaskSearch(
                    taskProvider:
                        Provider.of<TaskProvider>(context, listen: false)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.select_all),
            onPressed: () {
              setState(() {
                isSelected = !isSelected;
                isSelected
                    ? Provider.of<TaskProvider>(context, listen: false)
                        .tasks
                        .forEach((task) {
                        task.isDone = true;
                      })
                    : Provider.of<TaskProvider>(context, listen: false)
                        .tasks
                        .forEach((task) {
                        task.isDone = false;
                      });
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false)
                  .tasks
                  .where((task) => task.isDone)
                  .toList()
                  .forEach((task) {
                Provider.of<TaskProvider>(context, listen: false)
                    .deleteTask(task);
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                List<Task> filteredTasks =
                    taskProvider.getTasksByFilter(_selectedFilter);
                return ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    return Card(
                      elevation: 3,
                      color: Colors.white,
                      surfaceTintColor: Colors.blue,
                      margin: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        title: Text(
                          task.title!,
                          style: TextStyle(
                            color: task.isDone ? Colors.grey : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          'Due: ${task.dueDate!.day}-${task.dueDate!.month}-${task.dueDate!.year} at  ${task.dueDate!.hour}:${task.dueDate!.minute}',
                        ),
                        trailing: IconButton(
                          icon: task.isDone
                              ? Icon(Icons.check_box, color: Colors.green[300])
                              : const Icon(Icons.check_box_outline_blank),
                          onPressed: () {
                            taskProvider.toggleTask(task);
                          },
                        ),
                        onTap: () {
                          if (task.isDone) {
                            showDeleteTaskDialog(context, task);
                          }
                        },
                      ).animate().fadeIn().scale(),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        hintText: 'Select due date',
                        labelText: 'Due Date',
                        labelStyle: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                        prefixIcon: const Icon(
                          Icons.date_range,
                          color: Colors.blue,
                        ),
                      ),
                      child: Text(
                        _selectedDate != null
                            ? _dateFormat.format(_selectedDate!)
                            : 'Pick a date',
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          _selectedTime = pickedTime;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        hintText: 'Select due time',
                        labelText: 'Due Time',
                        labelStyle: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                        prefixIcon: const Icon(
                          Icons.access_time,
                          color: Colors.blue,
                        ),
                      ),
                      child: Text(
                        _selectedTime != null
                            ? _timeFormat.format(DateTime(2022, 1, 1,
                                _selectedTime!.hour, _selectedTime!.minute))
                            : 'Pick a time',
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _taskController,
                      decoration: InputDecoration(
                        hintText: 'Enter task',
                        labelText: 'New Task',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                        prefixIcon: const Icon(
                          Icons.task,
                          color: Colors.blue,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear, color: Colors.blue),
                          onPressed: () {
                            _taskController.clear();
                          },
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline_outlined,
                        color: Colors.blue),
                    onPressed: () {
                      if (_taskController.text.isNotEmpty &&
                          _selectedDate != null &&
                          _selectedTime != null) {
                        _selectedDate = DateTime(
                            _selectedDate!.year,
                            _selectedDate!.month,
                            _selectedDate!.day,
                            _selectedTime!.hour,
                            _selectedTime!.minute);
                        Provider.of<TaskProvider>(context, listen: false)
                            .addTask(Task(
                                id: Provider.of<TaskProvider>(context,
                                        listen: false)
                                    .tasks
                                    .length,
                                title: _taskController.text,
                                dueDate: _selectedDate!));
                        _taskController.clear();
                        setState(() {
                          _selectedDate = null;
                          _selectedTime = null;
                        });
                      }
                    },
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
