import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/core/utils/global_funtions.dart';
import 'package:task_management_app/features/task_management/presentation/screens/signup_screen.dart';

import '../../../../main.dart';
import '../bloc_cubits/user_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final userBlocCubit = BlocProvider.of<UserCubit>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Login"),
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
          InkWell(
            onTap: () {
              if (GlobalFuntions.isValidEmail(emailController.text)) {
                if (passwordController.text.trim().isNotEmpty) {
                  userBlocCubit.userLogin(
                      email: emailController.text,
                      password: passwordController.text);
                } else {
                  GlobalFuntions.showAlert(
                      context, "Error", "All fields required to fill !");
                }
              } else {
                GlobalFuntions.showSnacbar(
                    navKey.currentContext!, "Invalid email !");
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
                  "Login".toUpperCase(),
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
                Text("Create new account !"),
                SizedBox(
                  width: 10,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => SignUpScreen()));
                    },
                    child: Text("Sign-Up")),
              ],
            ),
          )
        ],
      ),
    );
  }
}
