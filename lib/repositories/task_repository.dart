import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

const taskListKey = 'task_list';

class TaskRepository{

  late SharedPreferences sharedPreferences;
  
  Future<List<Task>> getTaskList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(taskListKey) ?? '[]'; //lista vazia (json)
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => Task.fromJson(e)).toList(); //converte os itens do json em objeto Task e transforma de volta em lista
  }

  void saveTaskList(List<Task> tasks){
    final jsonString = json.encode(tasks);
    sharedPreferences.setString(taskListKey, jsonString);
  }
}

