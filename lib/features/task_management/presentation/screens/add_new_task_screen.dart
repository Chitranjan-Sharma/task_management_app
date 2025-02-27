import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/features/task_management/data/models/task_model.dart';
import 'package:task_management_app/features/task_management/presentation/bloc_cubits/task_cubit.dart';

import '../../../../core/utils/global_funtions.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();

  String selectedDate = "dd/mm/yy";

  @override
  Widget build(BuildContext context) {
    final taskBlocCubit = BlocProvider.of<TaskCubit>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add new task"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              height: 50,
              width: double.infinity,
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                    hintText: "Title", border: OutlineInputBorder()),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: double.infinity,
              child: TextField(
                controller: desController,
                maxLines: 8,
                minLines: 8,
                decoration: InputDecoration(
                    hintText: "Description", border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2),
              child: ListTile(
                title: Text("Deadline"),
                subtitle: Text(selectedDate.toString()),
                onTap: () {
                  showDatePicker(
                          context: context,
                          firstDate: DateTime(2025),
                          lastDate: DateTime(2027))
                      .then((date) {
                    if (date != null) {
                      setState(() {
                        selectedDate =
                            "${date.day > 9 ? date.day : "0${date.month}"}/${date.month > 9 ? date.month : "0${date.month}"}/${date.year}";
                      });
                    }
                  });
                },
                trailing: Icon(Icons.calendar_month),
              ),
            ),
            InkWell(
              onTap: () {
                if (titleController.text.trim().isNotEmpty &&
                    desController.text.trim().isNotEmpty) {
                  taskBlocCubit.addNewTask(TaskModel(
                      title: titleController.text,
                      description: desController.text,
                      createdAt: selectedDate,
                      isCompleted: false));
                  setState(() {
                    titleController.clear();
                    desController.clear();
                    selectedDate = "dd/mm/yy";
                  });
                } else {
                  GlobalFuntions.showAlert(
                      context, "Error", "All fields required to filled up !");
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(5)),
                child: Center(
                  child: Text(
                    "Save".toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
