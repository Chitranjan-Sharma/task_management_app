import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/core/utils/global_funtions.dart';
import 'package:task_management_app/features/task_management/data/models/user_model.dart';
import 'package:task_management_app/features/task_management/presentation/screens/home_screen.dart';
import 'package:task_management_app/features/task_management/presentation/screens/login_screen.dart';
import 'package:task_management_app/main.dart';

import '../../domains/entities/my_user.dart';

class UserState {
  MyUser user;
  UserState({this.user = const MyUser()});
}

class UserCubit extends Cubit<UserState> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseDatabase database = FirebaseDatabase.instance;
  UserCubit() : super(UserState());

  createAccount(
      {required String name, required String email, required String password}) {
    GlobalFuntions.showLoader();
    firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((UserCredential uCred) {
      print(uCred.user!.uid);
      UserModel myUser = UserModel(
          uid: uCred.user!.uid, email: uCred.user!.email!, name: name);
      print(myUser.toJson());

      database
          .ref("users")
          .child(myUser.uid!)
          .set(myUser.toJson())
          .then((onValue) {
        print("success");

        emit(UserState(user: myUser));
        print(state.user.toJson());
        Navigator.of(navKey.currentContext!).pop();
        Navigator.of(navKey.currentContext!)
            .push(MaterialPageRoute(builder: (_) => LoginScreen()));
      }).catchError((onError) {
        Navigator.of(navKey.currentContext!).pop();
        GlobalFuntions.showAlert(
            navKey.currentContext!, "Sign Up Error", onError.toString());
      });
    });
  }

  userLogin({required String email, required String password}) {
    GlobalFuntions.showLoader();
    firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((UserCredential uCred) async {
      print(uCred.user!.uid);

      final dbEven = await database.ref("users").child(uCred.user!.uid).once();
      final userObj = dbEven.snapshot.value;

      emit(UserState(user: UserModel.formMap(userObj)));

      Navigator.of(navKey.currentContext!).pop();
      Navigator.of(navKey.currentContext!).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => HomeScreen()), (d) => false);
      print(state.user.toJson());
    }).catchError((onError) {
      Navigator.of(navKey.currentContext!).pop();
      GlobalFuntions.showAlert(
          navKey.currentContext!, "Sign Up Error", onError.toString());
    });
  }

  void findUserDetails() async {
    final dbEven = await database
        .ref("users")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .once();
    final userObj = dbEven.snapshot.value;

    emit(UserState(user: UserModel.formMap(userObj)));
  }
}
