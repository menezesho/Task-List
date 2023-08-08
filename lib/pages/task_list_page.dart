import 'package:flutter/material.dart';
import 'package:todo_list/models/task.dart';
import 'package:todo_list/repositories/task_repository.dart';
import '../widgets/task_item.dart';

class TaskListPage extends StatefulWidget {
  TaskListPage({Key? key}) : super(key: key);

  @override
  State<TaskListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TaskListPage> {
  final TextEditingController taskController =
      TextEditingController(); //controle de edição da TextBox do nome da tarefa
  final TaskRepository taskRepository = TaskRepository();

  List<Task> tasks = []; //lista para armazenar todas as tarefas
  Task? deletedTask; //armazena a última tarefa excluída
  int? deletedTaskPosition; //armazena a posição da última tarefa excluída

  String? errorMessage;

  @override
  void initState() {
    super.initState();

    taskRepository.getTaskList().then((value) {
      setState(() {
        tasks = value;
      });
    });
  }

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
                            labelStyle: TextStyle(
                              color: Colors.teal,
                            ),
                            errorText: errorMessage,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.teal,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          String text = taskController.text;

                          //verifica se o campo está vazio
                          if (text.isEmpty) {
                            setState(() {
                              errorMessage = 'Campo obrigatório!';
                            });
                            return;
                          }

                          setState(() {
                            Task newTask = Task(
                              title: text,
                              createDate: DateTime.now(),
                            );
                            tasks.add(newTask);
                            errorMessage = null;
                          });
                          taskController.clear();
                          taskRepository.saveTaskList(tasks);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.teal,
                          padding: EdgeInsets.all(14),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 30,
                        ),
                      ),
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
                        child: Text(tasks.length == 0
                            ? 'Nenhuma tarefa pendente!'
                            : tasks.length == 1
                                ? '${tasks.length} tarefa pendente!'
                                : '${tasks.length} tarefas pendentes!'),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                        onPressed: showDeleteTasksConfirmationDialog,
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

  void onDelete(Task task) {
    deletedTask = task; //armazena o nome da tarefa excluída
    deletedTaskPosition = tasks.indexOf(
        task); //armazena a posição nas lista da tarefa que foi deletada

    setState(() {
      tasks.remove(task); //remove a tarefa da lista
    });
    taskRepository.saveTaskList(tasks);

    ScaffoldMessenger.of(context)
        .clearSnackBars(); //limpa todas as SnackBars existentes
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Tarefa ${task.title} removida com sucesso!',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      action: SnackBarAction(
        label: 'Desfazer',
        textColor: Colors.teal,
        onPressed: () {
          setState(() {
            tasks.insert(deletedTaskPosition!,
                deletedTask!); //'!' serve para dar certeza que a variável não é nula
          });
          taskRepository.saveTaskList(tasks);
        },
      ),
      duration: const Duration(seconds: 7),
    ));
  }

  void showDeleteTasksConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Excluir tudo?'),
        content: Text('Deseja mesmo apagar todas as tarefas?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              primary: Colors.teal,
            ),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteAllTasks();
            },
            style: TextButton.styleFrom(
              primary: Colors.red,
            ),
            child: Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void deleteAllTasks() {
    setState(() {
      tasks.clear(); //limpa todas as tarefas
    });
    taskRepository.saveTaskList(tasks);
  }
}
