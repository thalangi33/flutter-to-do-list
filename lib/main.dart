// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, deprecated_member_use, prefer_const_literals_to_create_immutables, unrelated_type_equality_checks
import 'package:flutter/material.dart';
import 'package:to_do_list/db/tasks_database.dart';
import 'task.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: Text("To-do-list"),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: TaskInput(),
          )),
    );
  }
}

// List<Task> tasks = [
//   Task(id: 1, toDo: 'Do homework', isFinished: false),
//   Task(id: 2, toDo: 'Workout', isFinished: false),
//   Task(id: 3, toDo: 'Sleep', isFinished: false)
// ];

class TaskInput extends StatefulWidget {
  const TaskInput({Key? key}) : super(key: key);

  @override
  State<TaskInput> createState() => _TaskInputState();
}

class _TaskInputState extends State<TaskInput> {
  // use this controller for getting user's input for tasks
  final taskInputController = TextEditingController();
  List<Task> tasks = [];

  Future<void> refreshTasks() async {
    tasks = await TasksDatabase.instance.readAllTasks();
    print("first");
    print(tasks);
  }

  @override
  void initState() {
    super.initState();
    refreshTasks();
    print(tasks);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: refreshTasks(),
        builder: (context, snapshot) {
          return Column(
            children: [
              Positioned(
                child: Container(
                    margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: taskInputController,
                      decoration: InputDecoration(
                          suffixIcon: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween, // added line
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  iconSize: 30.0,
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  onPressed: () {
                                    taskInputController.clear();
                                  },
                                  icon: Icon(Icons.clear),
                                  splashRadius: 20.0,
                                ),
                                IconButton(
                                  iconSize: 30.0,
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    setState(() {
                                      Task temp =
                                          Task(toDo: "", isFinished: false);
                                      temp.toDo = taskInputController.text;
                                      TasksDatabase.instance.create(temp);
                                      //refreshTasks();
                                    });
                                  },
                                  icon: Icon(Icons.add_circle_rounded),
                                  splashRadius: 20.0,
                                )
                              ]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: 'What are you planning to do?',
                          hintStyle: TextStyle(fontSize: 18.0)),
                    )),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return TaskCard(
                    toDo: tasks[index],
                    onTasksChanged: () {
                      setState(() {});
                    },
                  );
                },
              ),
            ],
          );
        });
  }
}

class TaskCard extends StatelessWidget {
  final Task toDo;
  final VoidCallback onTasksChanged;

  const TaskCard({required this.toDo, required this.onTasksChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 5.0),
      margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
      decoration: BoxDecoration(
        color: toDo.isFinished == true ? Colors.purple[200] : Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(children: <Widget>[
        Divider(),
        Expanded(
            flex: 18,
            child: Text(
              toDo.toDo,
              style: TextStyle(color: Color(0xFF000000), fontSize: 22.0),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )),
        Material(
            color: Colors.transparent,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: IconButton(
                    iconSize: 32.0,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: toDo.isFinished == true
                        ? Icon(Icons.undo_rounded)
                        : Icon(Icons.check_circle_rounded),
                    onPressed: () {
                      if (toDo.isFinished == false) {
                        toDo.isFinished = true;
                      } else {
                        toDo.isFinished = false;
                      }
                      TasksDatabase.instance.update(toDo);
                      onTasksChanged();
                    },
                    color: toDo.isFinished == true
                        ? Colors.white
                        : Colors.blue[400],
                    splashRadius: 20.0,
                  ),
                ),
                IconButton(
                  iconSize: 32.0,
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    //tasks.remove(toDo);
                    TasksDatabase.instance.delete(toDo.id as int);
                    onTasksChanged();
                  },
                  color:
                      toDo.isFinished == true ? Colors.white : Colors.blue[400],
                  splashRadius: 20.0,
                ),
              ],
            )),
      ]),
    );
  }
}
