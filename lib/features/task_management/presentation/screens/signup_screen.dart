import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/core/utils/global_funtions.dart';
import 'package:task_management_app/features/task_management/domains/entities/my_user.dart';
import 'package:task_management_app/features/task_management/presentation/bloc_cubits/user_cubit.dart';
import 'package:task_management_app/features/task_management/presentation/screens/login_screen.dart';

import '../../../../main.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cnfPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userBlocCubit = BlocProvider.of<UserCubit>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Sign-Up"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 50,
            width: double.infinity,
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                  hintText: "Name", border: OutlineInputBorder()),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 50,
            width: double.infinity,
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                  hintText: "Email", border: OutlineInputBorder()),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 50,
            width: double.infinity,
            child: TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  hintText: "Password", border: OutlineInputBorder()),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 50,
            width: double.infinity,
            child: TextField(
              controller: cnfPasswordController,
              decoration: InputDecoration(
                  hintText: "Confirm Password", border: OutlineInputBorder()),
            ),
          ),
          InkWell(
            onTap: () {
              if (nameController.text.trim().isNotEmpty &&
                  emailController.text.trim().isNotEmpty &&
                  passwordController.text.trim().isNotEmpty) {
                if (GlobalFuntions.isValidEmail(emailController.text)) {
                  if (passwordController.text.trim() ==
                      cnfPasswordController.text.trim()) {
                    if (passwordController.text.trim().length > 5) {
                      userBlocCubit.createAccount(
                          name: nameController.text,
                          email: emailController.text,
                          password: passwordController.text);
                    } else {
                      GlobalFuntions.showAlert(context, "Error",
                          "Password should be minimum 6 character long !");
                    }
                  } else {
                    GlobalFuntions.showAlert(
                        context, "Error", "Password did not matched !");
                  }
                } else {
                  GlobalFuntions.showSnacbar(
                      navKey.currentContext!, "Invalid email !");
                }
              } else {
                GlobalFuntions.showSnacbar(
                    navKey.currentContext!, "All fields required !");
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Text(
                  "Sign Up".toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Already have an account !"),
                SizedBox(
                  width: 10,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => LoginScreen()));
                    },
                    child: Text("Login")),
              ],
            ),
          )
        ],
      ),
    );
  }
}
