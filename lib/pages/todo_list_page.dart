import 'package:flutter/material.dart';
import 'package:todo_list/models/task.dart';

import '../widgets/task_item.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController taskController = TextEditingController();

  List<Task> tasks = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 600,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: taskController,
                          style: TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Adicionar tarefa',
                            hintText: 'Estudar Flutter',
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                          onPressed: () {
                            String text = taskController.text;
                            setState(() {
                              Task newTask = Task(
                                title: text,
                                createDate: DateTime.now(),
                              );
                              tasks.add(newTask);
                            });
                            taskController.clear();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.teal,
                            padding: EdgeInsets.all(14),
                          ),
                          child: Icon(
                            Icons.add,
                            size: 30,
                          )),
                    ],
                  ),
                  SizedBox(height: 16),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for (Task task in tasks)
                          TaskListItem(
                            task: task,
                            onDelete: onDelete,
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                            'Você possui ${tasks.length} tarefas pendentes!'),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: Colors.teal,
                          padding: EdgeInsets.all(14),
                        ),
                        child: Text('Limpar tudo'),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Task task){
    setState(() {
      tasks.remove(task);
    });
  }
}
