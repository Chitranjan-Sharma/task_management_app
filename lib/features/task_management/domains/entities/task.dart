class Task {
  String? title, description, id, createdAt;
  bool? isCompleted;

  Task(
      {this.id,
      this.title,
      this.description,
      this.createdAt,
      this.isCompleted});
}
