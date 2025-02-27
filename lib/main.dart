import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/core/network/firebase_init.dart';
import 'package:task_management_app/features/task_management/presentation/bloc_cubits/task_cubit.dart';
import 'package:task_management_app/features/task_management/presentation/screens/home_screen.dart';
import 'package:task_management_app/features/task_management/presentation/screens/login_screen.dart';

import 'features/task_management/data/source/firebase_ref.dart';
import 'features/task_management/presentation/bloc_cubits/user_cubit.dart';
import 'features/task_management/presentation/screens/signup_screen.dart';

final navKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseInit.init();
  FirebaseRef.auth = FirebaseAuth.instance;
  FirebaseRef.fDb = FirebaseDatabase.instance;
  runApp(BlocProvider(
    lazy: true,
    create: (cnxt) => UserCubit(),
    child: BlocProvider(
        lazy: true, create: (cnxt) => TaskCubit(), child: const MainApp()),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(centerTitle: false),
          scaffoldBackgroundColor: const Color.fromARGB(255, 238, 238, 238)),
      home: checkIsLoggedIn(context),
    );
  }

  checkIsLoggedIn(BuildContext context) {
    final userBlocCubit = BlocProvider.of<UserCubit>(context);
    final taskBlocCubit = BlocProvider.of<TaskCubit>(context);

    if (FirebaseAuth.instance.currentUser != null) {
      userBlocCubit.findUserDetails();
      taskBlocCubit.fetchAllTasks();
      return HomeScreen();
    } else {
      return LoginScreen();
    }
  }
}
