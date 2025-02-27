import 'package:task_management_app/features/task_management/domains/entities/task.dart';

class TaskModel extends Task {
  TaskModel(
      { String? id,
      required String title,
      required String description,
      required String createdAt,
      required bool isCompleted})
      : super(
            id: id,
            title: title,
            description: description,
            createdAt: createdAt,
            isCompleted: isCompleted);

  factory TaskModel.fromJson(json) {
    return TaskModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        createdAt: json['createdAt'],
        isCompleted: json['isCompleted']);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'isCompleted': isCompleted
    };
  }
}
