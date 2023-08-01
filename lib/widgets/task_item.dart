import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/models/task.dart';

class TaskListItem extends StatelessWidget {
  const TaskListItem({
    Key? key,
    required this.task,
    required this.onDelete,
  }) : super(key: key);

  final Task task;
  final Function(Task) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          extentRatio: 0.2,
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(5),
              backgroundColor: Colors.red,
              icon: Icons.delete,
              label: 'Excluir',
              onPressed: (context) => onDelete(task),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey[200],
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                task.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Criado em: ${DateFormat('dd/MM/yyyy - HH:mm').format(task.createDate)}',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
