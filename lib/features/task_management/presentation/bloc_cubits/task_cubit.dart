import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/core/utils/global_funtions.dart';
import 'package:task_management_app/features/task_management/data/models/task_model.dart';
import 'package:task_management_app/features/task_management/domains/entities/task.dart';
import 'package:task_management_app/main.dart';

class TaskState {
  List<Task> tasks;
  bool isLoading;
  TaskState({this.tasks = const [], this.isLoading = false});
}

class TaskCubit extends Cubit<TaskState> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseDatabase database = FirebaseDatabase.instance;
  TaskCubit() : super(TaskState());

  addNewTask(TaskModel task) {
    database
        .ref("tasks")
        .child(firebaseAuth.currentUser!.uid)
        .push()
        .set(task.toJson())
        .then((data) {
      GlobalFuntions.showSnacbar(navKey.currentContext!, "Task created !");
      fetchAllTasks();
    }).catchError((onError) {
      GlobalFuntions.showAlert(navKey.currentContext!, "Error",
          "Something went wrong while adding task to database !");
    });
  }

  updateTask(TaskModel task) {
    database
        .ref("tasks")
        .child(firebaseAuth.currentUser!.uid)
        .child(task.id!)
        .set(task.toJson())
        .then((data) {
      GlobalFuntions.showSnacbar(navKey.currentContext!, "Task updated !");
      fetchAllTasks();
    }).catchError((onError) {
      GlobalFuntions.showAlert(navKey.currentContext!, "Error",
          "Something went wrong while adding task to database !");
    });
  }

  fetchAllTasks() async {
    emit(TaskState(isLoading: true, tasks: []));
    final databaseEvent =
        await database.ref("tasks").child(firebaseAuth.currentUser!.uid).once();
    final dataSnapshot = databaseEvent.snapshot.children;
    List<Task> taskList = [];
    for (var snapshot in dataSnapshot) {
      TaskModel taskModel = TaskModel.fromJson(snapshot.value);
      taskModel.id = snapshot.key ?? "";
      taskList.add(taskModel);
    }

    emit(TaskState(tasks: taskList.reversed.toList(), isLoading: false));
    taskList.clear();
  }

  markTaskCompleted(Task task) {
    database
        .ref("tasks")
        .child(firebaseAuth.currentUser!.uid)
        .child(task.id!)
        .child("isCompleted")
        .set(true);
    GlobalFuntions.showSnacbar(navKey.currentContext!, "Marked completed !");
    fetchAllTasks();
  }

  deleteTask(Task task) {
    database
        .ref("tasks")
        .child(firebaseAuth.currentUser!.uid)
        .child(task.id!)
        .remove();
    GlobalFuntions.showSnacbar(navKey.currentContext!, "Task deleted !");
    final taskList = state.tasks.where((todo) => todo.id != task.id).toList();
    emit(TaskState(tasks: taskList));
  }
}
