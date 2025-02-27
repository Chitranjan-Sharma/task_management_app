import 'package:task_management_app/features/task_management/domains/entities/my_user.dart';

class UserModel extends MyUser {
  UserModel({required String uid, required String name, required String email})
      : super(name: name, email: email, uid: uid);

  factory UserModel.formMap(map) {
    return UserModel(uid: map['uid'], name: map['name'], email: map['email']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'uid': uid, 'name': name, 'email': email};
  }
}
