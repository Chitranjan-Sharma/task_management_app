import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/core/utils/global_funtions.dart';
import 'package:task_management_app/features/task_management/domains/entities/task.dart';
import 'package:task_management_app/features/task_management/presentation/screens/add_new_task_screen.dart';
import 'package:task_management_app/features/task_management/presentation/screens/login_screen.dart';
import 'package:task_management_app/features/task_management/presentation/screens/update_task_screen.dart';

import '../bloc_cubits/task_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final taskBlocCubit = BlocProvider.of<TaskCubit>(context);
    taskBlocCubit.fetchAllTasks();
    //print(taskBlocCubit.state.tasks);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Management System"),
        actions: [
          IconButton(
              onPressed: () {
                taskBlocCubit.fetchAllTasks();
              },
              icon: Icon(Icons.refresh)),
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                    (d) => false);
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: 50,
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      hintText: "Search...", border: InputBorder.none),
                )),
                IconButton(onPressed: () {}, icon: Icon(Icons.search))
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<TaskCubit, TaskState>(
              builder: (context, state) {
                List<Task> searchList = [];
                if (searchController.text.trim().isNotEmpty) {
                  searchList = state.tasks
                      .where((task) =>
                          task.title!.contains(searchController.text) ||
                          task.description!.contains(searchController.text) ||
                          task.createdAt!.contains(searchController.text))
                      .toList();
                } else {
                  searchList.clear();
                }
                return state.isLoading == false
                    ? state.tasks.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.all(5),
                            itemCount: searchController.text.trim().isEmpty &&
                                    searchList.isEmpty
                                ? state.tasks.length
                                : searchList
                                    .where((task) =>
                                        task.title!
                                            .contains(searchController.text) ||
                                        task.description!
                                            .contains(searchController.text) ||
                                        task.createdAt!
                                            .contains(searchController.text))
                                    .toList()
                                    .length,
                            itemBuilder: (_, i) {
                              Task task = searchController.text.trim().isEmpty
                                  ? state.tasks[i]
                                  : searchList[i];

                              return Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: ListTile(
                                  onTap: () {
                                    GlobalFuntions.showTaskDetailsSheet(task);
                                  },
                                  title: Text(
                                    task.title ?? "",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task.description ?? "",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            task.createdAt ?? "",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                UpdateTaskScreen(
                                                                    task:
                                                                        task)));
                                                  },
                                                  icon: Icon(
                                                      Icons.edit_document)),
                                              Checkbox(
                                                  value: task.isCompleted,
                                                  onChanged: (onChanged) {
                                                    if (task.isCompleted ==
                                                        false) {
                                                      taskBlocCubit
                                                          .markTaskCompleted(
                                                              task);
                                                    }
                                                  }),
                                              IconButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (_) => AlertDialog(
                                                                  title: Text(
                                                                      "Alert"),
                                                                  content: Text(
                                                                      "Do you want to delete this task ?"),
                                                                  actions: [
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: Text(
                                                                            "no")),
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          taskBlocCubit
                                                                              .deleteTask(task);
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: Text(
                                                                            "Yes")),
                                                                  ],
                                                                ));
                                                  },
                                                  icon: Icon(Icons.close)),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })
                        : Center(
                            child: Text("No task found"),
                          )
                    : Center(
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator(),
                        ),
                      );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => AddNewTaskScreen()));
          }),
    );
  }
}
