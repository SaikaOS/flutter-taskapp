import 'package:flutter/material.dart';
import '../models/task.dart';
import '../storage/task_storage.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  TaskFilter filter = TaskFilter.all;
  final TaskStorage _storage = TaskStorage();

  List<Task> get tasks {
  switch (filter) {
    case TaskFilter.completed:
      return _tasks.where((task) => task.isCompleted).toList();
    case TaskFilter.uncompleted:
      return _tasks.where((task) => !task.isCompleted).toList();
    default:
      return _tasks;
  }
}

  TaskProvider() {
    loadTasks();
  }

  Future<void> loadTasks() async {
    _tasks = await _storage.loadTasks();
    notifyListeners();
  }

  void addTask(String title) {
    _tasks.add(Task(
      id: DateTime.now().toString(),
      title: title,
    ));
    _saveAndNotify();
  }

  void toggleTask(String id) {
  final taskIndex = _tasks.indexWhere((t) => t.id == id);
  if (taskIndex != -1) {
    _tasks[taskIndex].isCompleted = !_tasks[taskIndex].isCompleted;
    _saveAndNotify(); 
  }
}

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    _saveAndNotify();
  }

  void setFilter(TaskFilter newFilter) {
    filter = newFilter;
    notifyListeners();
  }

  void _saveAndNotify() {
    _storage.saveTasks(_tasks);
    notifyListeners();
  }
}

enum TaskFilter { all, completed, uncompleted }