class MyUser {
  final String? uid, name, email;
  const MyUser({
    this.uid,
    this.name,
    this.email,
  });

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'name': name, 'email': email};
  }
}
