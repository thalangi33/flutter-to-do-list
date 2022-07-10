final String tableTasks = 'tasks';

class TaskFields {
  static final List<String> values = [
    id, toDo, isFinished
  ];

  static final String id = '_id';
  static final String toDo = 'doDo';
  static final String isFinished = 'isFinished';
}

class Task {
  int? id;
  String toDo;
  bool isFinished;

  Task({this.id, required this.toDo, required this.isFinished});

  static Task fromJson(Map<String, Object?> json) => Task(
        id: json[TaskFields.id] as int?,
        toDo: json[TaskFields.toDo] as String,
        isFinished: json[TaskFields.isFinished] == 1
      );

  Map<String, Object?> toJson() => {
        TaskFields.id: id,
        TaskFields.toDo: toDo,
        TaskFields.isFinished: isFinished ? 1 : 0,
      };

  Task copy({
    int? id,
    String? toDo,
    bool? isFinished,
  }) =>
      Task(
        id: id ?? this.id,
        toDo: toDo ?? this.toDo,
        isFinished: isFinished ?? this.isFinished,
      );
}
